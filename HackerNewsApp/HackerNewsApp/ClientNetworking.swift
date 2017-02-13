//
//  ClientNetworking.swift
//  HackerNewsApp
//
//  Created by Venugopal Reddy Devarapally on 11/02/17.
//  Copyright © 2017 Venugopal Reddy Devarapally. All rights reserved.
//

import Foundation

// Mark: Networking

func taskForGetHackerNews(_ itemId: (Int), completionHandlerForGET: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
    var urlStr = "https://hacker-news.firebaseio.com/v0/topstories.json"
    if itemId == itemId && itemId != -1{
        urlStr = Constants.HackerNews.APIBaseURL + "item/" + String(describing: itemId) + ".json"
    }
    
    let url = URL(string: urlStr)
    let request = URLRequest(url: url!)
    
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        func sendError(_ error: String) {
            print(error)
            let userInfo = [NSLocalizedDescriptionKey : error]
            completionHandlerForGET(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
        }
        
        /* GUARD: Was there an error? */
        guard (error == nil) else {
            sendError("There was an error with your request: \(error)")
            return
        }
        
        /* GUARD: Did we get a successful 2XX response? */
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
            sendError("Your request returned a status code other than 2xx!")
            return
        }
        
        /* GUARD: Was there any data returned? */
        guard let data = data else {
            sendError("No data was returned by the request!")
            return
        }
        
        convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGET)
    }
    
    task.resume()
    
    return task
}

func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
    
    var parsedResult: AnyObject! = nil
    do {
        parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
    } catch {
        let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
        completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
    }
    
    completionHandlerForConvertData(parsedResult, nil)
}

func getHackerNewsItem(_ data: ArraySlice<Int>, completionHandlerForData: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void){
    var objects = [HNNewsItem]()
    var unsortedArray = [HNNewsItem]()
    let queue = DispatchQueue(label: "com.download.dispatchgroup", attributes: .concurrent, target: .main)
    let group = DispatchGroup()
    for item in data {
        group.enter()
        queue.async (group: group) {
            let _ = taskForGetHackerNews(item) { (response, error) in
                func sendError(_ error: String) {
                    print(error)
                    let userInfo = [NSLocalizedDescriptionKey : error]
                    completionHandlerForData(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
                }
                guard error == nil else {
                    sendError("There was an error with your request: \(error)")
                    return
                }
                if(response is NSDictionary){
                    let resultNewsItem = HNNewsItem.newsFromResults(response as! [String : AnyObject])
                    unsortedArray.append(resultNewsItem as HNNewsItem)
                }
                objects = unsortedArray.sorted { (obj1, obj2) -> Bool in
                    return (obj1.time) > (obj2.time)
                }
                group.leave()
            }
        }
    }
    group.notify(queue: DispatchQueue.main) {
        completionHandlerForData(objects as AnyObject?, nil)
    }
}

func getTopStoriesFromHackerNews(_ completionHandlerForGET: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
    let task = taskForGetHackerNews(-1) { (response, error) in
        func sendError(_ error: String) {
            print(error)
            let userInfo = [NSLocalizedDescriptionKey : error]
            completionHandlerForGET(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
        }
        
        guard (error == nil) else {
            sendError("There was an error with your request: \(error)")
            return
        }
        let newsIdItemsArray = (response as! Array<Int>).prefix(10)
        getHackerNewsItem(newsIdItemsArray, completionHandlerForData: completionHandlerForGET)
        
    }
    return task
}

func getCommentsFromHackerNews(_ newsItem: HNNewsItem, completionHandlerForGET: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> Void {
    let n = newsItem.comments.count
    let newsIdItemsArray = newsItem.comments.prefix(n)
    getHackerNewsItem(newsIdItemsArray, completionHandlerForData: completionHandlerForGET)
}





