//
//  HNCommentsViewController.swift
//  HackerNewsApp
//
//  Created by Venugopal Reddy Devarapally on 11/02/17.
//  Copyright © 2017 Venugopal Reddy Devarapally. All rights reserved.
//

import UIKit

class HNCommentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    var dataSource = [[CommentModel]]()
    var tableView: UITableView = UITableView()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    var noCommentsView: UILabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView = UITableView(frame: CGRect(x:0 , y:0 , width:self.view.frame.size.width, height:self.view.frame.size.height), style: UITableViewStyle.plain)
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        self.tableView.backgroundView = nil
        tableView.delegate      =   self
        tableView.dataSource    =   self
        tableView.backgroundColor = UIColor(colorLiteralRed: 244, green: 244, blue: 244, alpha: 1)
        tableView.register(CommentTableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.view.addSubview(self.tableView)
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        activityIndicator.center = view.center
        activityIndicator.startAnimating()
        self.view.addSubview(activityIndicator)
        
        noCommentsView = UILabel(frame: CGRect(x:0,y:0,width:375,height:25))
        noCommentsView.textAlignment = NSTextAlignment.center
        noCommentsView.center = self.view.center
        noCommentsView.text = "No Comments"
        noCommentsView.isHidden = true
        self.view.addSubview(noCommentsView)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.frame = CGRect(x:0 , y:0 , width:self.view.frame.size.width, height:self.view.frame.size.height)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    public func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let container: LayoutContainerView = LayoutContainerView(modelArray: dataSource[indexPath.row])
        return container.frame.size.height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as! CommentTableViewCell
        cell.selectionStyle = .none;
        let container: LayoutContainerView = LayoutContainerView(modelArray: dataSource[indexPath.row])
        cell.contentView.addSubview(container)
        return cell;
    }
    
    var detailItem: HNNewsItem? {
        didSet {
            // Update the view.
            getCommentsForNewsItem(item: detailItem!)
        }
    }
    
    func getCommentsForNewsItem(item: HNNewsItem) {
        let  _ = getCommentsFromHackerNews(item) { (response, error) in
            func sendError(_ error: String) {
                performUIUpdatesOnMain {
                    let alert = UIAlertController(title: "Oops!!", message: error, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion:nil)
                    self.activityIndicator.stopAnimating()
                    if self.dataSource.count == 0{
                        self.noCommentsView.isHidden = false
                    }else{
                        self.noCommentsView.isHidden = true
                    }
                }
            }
            guard error == nil else {
                sendError("No network. Please try after sometime.")
                return
            }
            let commentsItemsArray = response as! Array<AnyObject>
            self.dataSource.removeAll()
            let queue = DispatchQueue(label: "com.allaboutswift.dispatchgroup", attributes: .concurrent, target: .main)
            let group = DispatchGroup()
            for item in commentsItemsArray {
                group.enter()
                queue.async (group: group) {
                    let _ = getCommentsFromHackerNews(item as! HNNewsItem, completionHandlerForGET: { (replyResponse, error) in
                        var replyArray = [CommentModel]()
                        replyArray.append(self.getCommentsModelObj(item: item as! HNNewsItem))
                        for replyItem in replyResponse as! Array<AnyObject>{
                            replyArray.append(self.getCommentsModelObj(item: replyItem as! HNNewsItem)  )
                        }
                        self.dataSource.append(replyArray)
                        group.leave()
                    })
                }
            }
            group.notify(queue: DispatchQueue.main) {
                print("done doing stuff again")
                performUIUpdatesOnMain {
                    self.tableView.reloadData()
                    self.activityIndicator.stopAnimating()
                    if self.dataSource.count == 0{
                        self.noCommentsView.isHidden = false
                    }else{
                        self.noCommentsView.isHidden = true
                    }
                }
            }
        }
    }
    
    func getCommentsModelObj(item: HNNewsItem) -> CommentModel {
        let commentsModelObj = CommentModel(hnNewsItem: item)
        return commentsModelObj!
    }
}

