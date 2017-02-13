//
//  HNNewsItem.swift
//  HackerNewsApp
//
//  Created by Venugopal Reddy Devarapally on 11/02/17.
//  Copyright © 2017 Venugopal Reddy Devarapally. All rights reserved.
//

import Foundation

class HNNewsItem: NSObject {
    let title: String
    let points: Int
    let author: String
    let newsId: Int
    let time: Int
    let commentsCount: Int
    let url: String
    let comments: [Int]
    let text: String
    let parentId: Int
    let newsType: String
    
    init(dictionary: [String:AnyObject]) {
        //Title
        if dictionary[Constants.HackerNewsResponseKeys.title] != nil {
            title = dictionary[Constants.HackerNewsResponseKeys.title] as! String
        }else{
            title = ""
        }
        
        //News ID
        if dictionary[Constants.HackerNewsResponseKeys.newsId] != nil {
            newsId = dictionary[Constants.HackerNewsResponseKeys.newsId] as! Int
        }else{
            newsId = -1
        }
        
        //Author
        if dictionary[Constants.HackerNewsResponseKeys.author] != nil {
            author = dictionary[Constants.HackerNewsResponseKeys.author] as! String
        }else{
            author = ""
        }
        
        //Points
        if dictionary[Constants.HackerNewsResponseKeys.points] != nil {
            points = dictionary[Constants.HackerNewsResponseKeys.points] as! Int
        }else{
            points = -1
        }
        
        //time
        if dictionary[Constants.HackerNewsResponseKeys.time] != nil {
            time = dictionary[Constants.HackerNewsResponseKeys.time] as! Int
        }else{
            time = -1
        }
        
        //CommentsCount
        if dictionary[Constants.HackerNewsResponseKeys.commentsCount] != nil {
            commentsCount = dictionary[Constants.HackerNewsResponseKeys.commentsCount] as! Int
        }else{
            commentsCount = -1
        }
        
        //URL
        if dictionary[Constants.HackerNewsResponseKeys.url] != nil {
            url = dictionary[Constants.HackerNewsResponseKeys.url] as! String
        }else{
            url = ""
        }
        
        //comments
        if dictionary[Constants.HackerNewsResponseKeys.comments] != nil {
            comments = dictionary[Constants.HackerNewsResponseKeys.comments] as! [Int]
        }else{
            comments = [-1]
        }
        
        //Text
        if dictionary[Constants.HackerNewsResponseKeys.text] != nil {
            text = dictionary[Constants.HackerNewsResponseKeys.text] as! String
        }else{
            text = ""
        }
        
        //ParentId
        if dictionary[Constants.HackerNewsResponseKeys.parentId] != nil {
            parentId = dictionary[Constants.HackerNewsResponseKeys.parentId] as! Int
        }else{
            parentId = -1
        }
        
        //Type
        if dictionary[Constants.HackerNewsResponseKeys.newsType] != nil {
            newsType = dictionary[Constants.HackerNewsResponseKeys.newsType] as! String
        }else{
            newsType = ""
        }
    }
    
    static func newsFromResults(_ result: [String:AnyObject]) -> HNNewsItem {
        return HNNewsItem(dictionary: result)
    }
}





