//
//  Article+CoreDataClass.swift
//  NYTimes
//
//  Created by sukhjeet singh sandhu on 21/11/17.
//  Copyright © 2017 sukhjeet singh sandhu. All rights reserved.
//
//

import Foundation
import CoreData
import SwiftyJSON

@objc(Article)
public class Article: NSManagedObject {

    static func checkIfArticlePresent(with webUrl: String, in context: NSManagedObjectContext) -> Bool {
        let fetchRequest: NSFetchRequest<Article> = Article.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "webUrl == %@", argumentArray: [webUrl])
        do {
            let articles = try context.fetch(fetchRequest)
            if articles.count > 0 {
                return true
            } else {
                return false
            }
        } catch {
            return false
        }
    }
    
    static func insert(new article: JSON, in context: NSManagedObjectContext) {
        if let webUrl = article["web_url"].string {
            if !self.checkIfArticlePresent(with: webUrl, in: context) {
                guard let headline = article["headline"]["main"].string else {
                    return
                }
                if !headline.isEmpty {
                    let addedArticle = Article(context: context)
                    addedArticle.webUrl = webUrl
                    addedArticle.headLine = headline
                    guard let snippet = article["snippet"].string else {
                        addedArticle.snippet = nil
                        return
                    }
                    addedArticle.snippet = snippet
                    guard let timestamp = article["pub_date"].string else {
                        addedArticle.publishedDate = nil
                        return
                    }
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                    dateFormatter.timeZone = TimeZone(abbreviation: "\(String(describing: NSTimeZone.local.abbreviation()))")
                    let date = dateFormatter.date(from: timestamp)
                    addedArticle.publishedDate = date as NSDate?
                    guard let publishedBy = article["byline"]["original"].string else {
                        addedArticle.publishedBy = nil
                        return
                    }
                    addedArticle.publishedBy = publishedBy
                    guard let multiMedia = article["multimedia"].array else {
                        addedArticle.imageUrl = nil
                        return
                    }
                    for media in multiMedia {
                        if media["subtype"].string == "thumbnail" {
                            addedArticle.imageUrl = media["url"].string
                        }
                        if media["subtype"].string == "wide" {
                            addedArticle.mainImageUrl = media["url"].string
                        }
                        if media["subtype"].string == "xlarge" {
                            addedArticle.largeImageUrl = media["url"].string
                        }
                    }
                }
            }
        }
    }
}
