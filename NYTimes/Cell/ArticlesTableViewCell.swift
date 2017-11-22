//
//  ArticlesTableViewCell.swift
//  NYTimes
//
//  Created by sukhjeet singh sandhu on 20/11/17.
//  Copyright © 2017 sukhjeet singh sandhu. All rights reserved.
//

import UIKit
import SDWebImage

class ArticlesTableViewCell: UITableViewCell {

    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var headlineLabel: UILabel!

    func configureCell(with article: Article) {
        self.headlineLabel.text = article.headLine
        self.thumbnailImageView.image = #imageLiteral(resourceName: "placeholder")
        if let urlString = article.imageUrl {
            let completeUrlstring = "http://www.nytimes.com/\(urlString)"
            if let downloadedImage = SDImageCache.shared().imageFromCache(forKey: completeUrlstring) {
                self.thumbnailImageView.image = downloadedImage
            } else {
                self.loadImage(from: completeUrlstring)
                if let mainImageUrl = article.mainImageUrl {
                    let mainUrlString = "http://www.nytimes.com/\(mainImageUrl)"
                    self.loadImage(from: mainUrlString)
                }
                if let largeImageUrl = article.largeImageUrl {
                    let largeUrlString = "http://www.nytimes.com/\(largeImageUrl)"
                    self.loadImage(from: largeUrlString)
                }
                
            }
        }
    }

    fileprivate func loadImage(from imageUrlString: String) {
        let imageUrl = URL(string: imageUrlString)
        
        let downloader = SDWebImageDownloader()
        downloader.downloadImage(with: imageUrl, options: .continueInBackground, progress: nil) { (image, data, error, isSucceeded) in
            if error == nil && image != nil {
                self.thumbnailImageView?.image = image
                SDImageCache.shared().store(image, forKey: imageUrlString, completion: nil)
            } else {
                self.thumbnailImageView.image = #imageLiteral(resourceName: "placeholder")
            }
            self.setNeedsLayout()
        }
    }
}
