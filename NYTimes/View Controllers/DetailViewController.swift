//
//  DetailViewController.swift
//  NYTimes
//
//  Created by sukhjeet singh sandhu on 21/11/17.
//  Copyright © 2017 sukhjeet singh sandhu. All rights reserved.
//

import UIKit
import SDWebImage

class DetailViewController: UIViewController {

    var article: Article!

    @IBOutlet weak var snippetLabel: UILabel!
    @IBOutlet weak var publisherNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var headlineLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Detail"
        self.configureViewController()
    }

    fileprivate func configureViewController() {
        self.headlineLabel.text = article.headLine
        var completeUrlString = ""
        if UIDevice.current.userInterfaceIdiom == .phone {
            if let urlString = article.mainImageUrl {
                completeUrlString = "http://www.nytimes.com/\(urlString)"
            }
        } else {
            if let urlString = article.largeImageUrl {
                completeUrlString = "http://www.nytimes.com/\(urlString)"
            }
        }
        self.detailImageView.image = #imageLiteral(resourceName: "placeholder")
        if !completeUrlString.isEmpty {
            if let downloadedImage = SDImageCache.shared().imageFromCache(forKey: completeUrlString) {
                self.detailImageView.image = downloadedImage
            }
        }
        self.snippetLabel.text = article.snippet
        self.publisherNameLabel.text = article.publishedBy
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.timeZone = TimeZone(abbreviation: "\(String(describing: NSTimeZone.local.abbreviation()))")
        let dateString = dateFormatter.string(from: article.publishedDate! as Date)
        if let index = dateString.range(of: "T")?.lowerBound {
            let substring = dateString[..<index]
            let date = String(substring)
            self.dateLabel.text = date
        }
    }
}
