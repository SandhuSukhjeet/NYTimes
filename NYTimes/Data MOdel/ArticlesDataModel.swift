//
//  ArticlesDataModel.swift
//  NYTimes
//
//  Created by sukhjeet singh sandhu on 20/11/17.
//  Copyright © 2017 sukhjeet singh sandhu. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import Alamofire
import SwiftyJSON

class ArticlesDataModel {

    fileprivate let appdelegate = UIApplication.shared.delegate as! AppDelegate
    var jsonArticles: [JSON] = []
    
    lazy var articlesFetchedResultsController: NSFetchedResultsController<Article> = {
        var fetchedResultsController : NSFetchedResultsController<Article>!
        appdelegate.persistentContainer.viewContext.performAndWait {
            var fetchRequest: NSFetchRequest<Article> = Article.fetchRequest()
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "publishedDate", ascending: false)]
            fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: appdelegate.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        }
        return fetchedResultsController
    }()

    func getArticles(completion: @escaping (String?) -> ()) {
        var request = Request()
        let alamofireRequest = Alamofire.request(request.url)
        alamofireRequest.responseData { (dataResponse) in
            switch dataResponse.result {
            case .success(_):
                self.handle(data: dataResponse.data!, completion: { (error) in
                    if let error = error {
                        completion(error)
                    } else {
                        completion(nil)
                    }
                })
            case .failure(_):
                completion(dataResponse.error?.localizedDescription)
            }
        }
    }

    fileprivate func handle(data: Data, completion: (String?) -> ()) {
        let jsonData = JSON(data: data)
        if let jsonArray = jsonData["response"]["docs"].array {
            self.jsonArticles = jsonArray
            self.createArticleObjects(completion: { (error) in
                if let error = error {
                    completion(error)
                } else {
                    completion(nil)
                }
            })
        } else {
            completion("Errror Occured")
        }
    }

    func createArticleObjects(completion: (String?) -> ()) {
        let managedObjectContext = appdelegate.persistentContainer.viewContext
        var count = 0
        for (index,json) in jsonArticles.enumerated() {
            count += 1
            if count == 20 {
                break
            }
            Article.insert(new: json, in: managedObjectContext)
            jsonArticles.remove(at: index)
        }
        do {
            try managedObjectContext.save()
            completion(nil)
        } catch {
            completion("Error while saving the Data")
        }
    }
}
