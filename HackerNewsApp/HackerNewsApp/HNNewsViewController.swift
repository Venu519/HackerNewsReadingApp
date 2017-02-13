//
//  HNNewsViewController.swift
//  HackerNewsApp
//
//  Created by Venugopal Reddy Devarapally on 11/02/17.
//  Copyright © 2017 Venugopal Reddy Devarapally. All rights reserved.
//

import UIKit

class HNNewsViewController: UITableViewController {

    var commentsViewController: HNCommentsViewController? = nil
    var objects = [Any]()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    var noNewsStoriesView: UILabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.commentsViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? HNCommentsViewController
        }
//        let titleView = HNNavigationBarTitleView.instanceFromNib()
//        titleView.title.text = ""
//        self.navigationController?.navigationItem.titleView = titleView
        
        navigationController!.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)]
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)
        
        self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        self.refreshControl?.tintColor = #colorLiteral(red: 0.9463866353, green: 0.5177738667, blue: 0.2307146788, alpha: 1)
        self.refreshControl?.addTarget(self, action: #selector(HNNewsViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        activityIndicator.center = view.center
        activityIndicator.startAnimating()
        self.view.addSubview(activityIndicator)
        
        noNewsStoriesView = UILabel(frame: CGRect(x:0,y:0,width:375,height:25))
        noNewsStoriesView.textAlignment = NSTextAlignment.center
        noNewsStoriesView.center = self.view.center
        noNewsStoriesView.text = "No News Stories"
        noNewsStoriesView.isHidden = true
        self.view.addSubview(noNewsStoriesView)
        
        getTopStories()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = objects[indexPath.row] as! HNNewsItem
                let controller = (segue.destination as! UINavigationController).topViewController as! HNCommentsViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! HNNewsTableViewCell
        let object = objects[indexPath.row] as! HNNewsItem
        cell.titleLabel?.text = object.title
        var commentStr: String = ""
        if object.commentsCount == -1{
            commentStr = "0 comments"
        }else if object.commentsCount == 1{
            commentStr = "\(object.commentsCount)" + " comment"
        }else{
            commentStr = "\(object.commentsCount)" + " comments"
        }
        cell.subTitleLabel?.text = "\(object.points)" + " points by " + object.author + " | " + commentStr
        cell.urlLabel?.text = object.url
        return cell
    }

    func handleRefresh(_ refreshControl: UIRefreshControl) {
        print("pull to refresh")
        self.refreshControl?.beginRefreshing()
        getTopStories()
    }
    
    private func getTopStories(){
        let _ = getTopStoriesFromHackerNews() { (response, error) in
            func sendError(_ error: String) {
                performUIUpdatesOnMain {
                    let alert = UIAlertController(title: "Oops!!", message: error, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion:nil)
                    self.refreshControl?.endRefreshing()
                    self.activityIndicator.stopAnimating()
                    if self.objects.count == 0{
                        self.noNewsStoriesView.isHidden = false
                    }else{
                        self.noNewsStoriesView.isHidden = true
                    }
                }
            }
            guard error == nil else {
                sendError("No Network. Please try after sometime.")
                return
            }
            let newsIdItemsArray = response as! Array<AnyObject>
            self.objects.removeAll()
            for item in newsIdItemsArray {
                self.objects.append(item)
            }
            performUIUpdatesOnMain {
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
                self.activityIndicator.stopAnimating()
                if self.objects.count == 0{
                    self.noNewsStoriesView.isHidden = false
                }else{
                    self.noNewsStoriesView.isHidden = true
                }
            }
        }
    }
}

