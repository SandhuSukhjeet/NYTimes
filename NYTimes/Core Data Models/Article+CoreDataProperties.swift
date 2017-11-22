//
//  Article+CoreDataProperties.swift
//  NYTimes
//
//  Created by sukhjeet singh sandhu on 21/11/17.
//  Copyright © 2017 sukhjeet singh sandhu. All rights reserved.
//
//

import Foundation
import CoreData


extension Article {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Article> {
        return NSFetchRequest<Article>(entityName: "Article")
    }

    @NSManaged public var headLine: String?
    @NSManaged public var imageUrl: String?
    @NSManaged public var mainImageUrl: String?
    @NSManaged public var publishedBy: String?
    @NSManaged public var publishedDate: NSDate?
    @NSManaged public var snippet: String?
    @NSManaged public var webUrl: String?
    @NSManaged public var largeImageUrl: String?

}
