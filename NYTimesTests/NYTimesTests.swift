//
//  NYTimesTests.swift
//  NYTimesTests
//
//  Created by sukhjeet singh sandhu on 20/11/17.
//  Copyright © 2017 sukhjeet singh sandhu. All rights reserved.
//

import XCTest
import SwiftyJSON
import CoreData
@testable import NYTimes

class NYTimesTests: XCTestCase {

    var json: JSON!

    override func setUp() {
        super.setUp()
        json = JSON([
                    "web_url": "https://www.nytimes.com/2017/11/01/business/soybeans-pesticide.html",
                    "snippet": "The herbicide dicamba is intended for soybeans and cotton crops that have been genetically modified. But other crops on nearby fields are suffering.",
                    "multimedia": [
                        [
                            "type": "image",
                            "subtype": "xlarge",
                            "url": "images/2017/11/02/business/02PESTICIDE1/02PESTICIDE1-articleLarge.jpg"
                        ],
                        [
                            "type": "image",
                            "subtype": "wide",
                            "url": "images/2017/11/02/business/02PESTICIDE1/02PESTICIDE1-thumbWide.jpg"
                        ],
                        [
                            "type": "image",
                            "subtype": "thumbnail",
                            "url": "images/2017/11/02/business/02PESTICIDE1/02PESTICIDE1-thumbStandard.jpg"
                        ]
                    ],
                    "headline": [
                        "main": "Crops in 25 States Damaged by Unintended Drift of Weed Killer",
                        "print_headline": "E.P.A. Says Drift of Herbicide Damaged Crops in 25 States"
                    ],
                    "pub_date": "2017-11-01T23:48:28+0000",
                    "byline": [
                        "original": "By ERIC LIPTON"
                    ],
                    "uri": "nyt://article/3e8d8d9b-1e68-5419-bb14-0737df4df5de"
        ])
    }

    func testModel() {
        let managedObjectContext = self.createManagedObjectContext()
        Article.insert(new: json, in: managedObjectContext)
        try! managedObjectContext.save()
        let fetchRequest: NSFetchRequest<Article> = Article.fetchRequest()
        let articles = try! managedObjectContext.fetch(fetchRequest)
        XCTAssertTrue(articles[0].headLine == "Crops in 25 States Damaged by Unintended Drift of Weed Killer")
        
    }

    fileprivate func createManagedObjectContext() -> NSManagedObjectContext {
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main])!
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        do {
            try persistentStoreCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
        } catch {
            print("Could not add persistent store")
        }
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
        return managedObjectContext
    }
}
