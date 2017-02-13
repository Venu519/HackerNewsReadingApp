//
//  Constants.swift
//  HackerNewsApp
//
//  Created by Venugopal Reddy Devarapally on 11/02/17.
//  Copyright © 2017 Venugopal Reddy Devarapally. All rights reserved.
//

// MARK: - Constants

struct Constants {
    
    // MARK: HackerNews
    struct HackerNews {
        static let APIBaseURL = "https://hacker-news.firebaseio.com/v0/"
    }
    
    // MARK: HackerNews Parameter Keys
    struct HackerNewsParameterKeys {
        static let Method = "method"
        static let Extras = "extras"
        static let Format = "format"
        static let NoJSONCallback = "nojsoncallback"
    }
    
    // MARK: HackerNews Parameter Values
    struct HackerNewsItemsType {
        static let HackerNewsItemsTypeComment = "comment"
        static let HackerNewsItemsTypeStory = "story"
    }
    
    // MARK: HackerNews Response Keys
    struct HackerNewsResponseKeys {
        static let title =  "title"
        static let points =  "score"
        static let author = "by"
        static let newsId = "id"
        static let time = "time"
        static let commentsCount = "descendants"
        static let url = "url"
        static let comments = "kids"
        static let parentId = "parent"
        static let text = "text"
        static let newsType = "type"
    }
    
    // MARK: HackerNews Response Values
    struct HackerNewsResponseValues {
        static let OKStatus = "ok"
    }
}
