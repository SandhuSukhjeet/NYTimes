//
//  Request.swift
//  NYTimes
//
//  Created by sukhjeet singh sandhu on 20/11/17.
//  Copyright © 2017 sukhjeet singh sandhu. All rights reserved.
//

import Foundation

struct Request {

    fileprivate let apiKey = "68608ce548c54a7e81b23e968ee6247e"
    fileprivate lazy var month: String = {
        let dateFormat = "MM"
        return convertStringFromDate(having: dateFormat)
    }()

    fileprivate lazy var year: String = {
        let dateFormat = "YYYY"
        return convertStringFromDate(having: dateFormat)
    }()

    lazy var url: URL = {
        let urlString = "http://api.nytimes.com/svc/archive/v1/\(self.year)/\(self.month).json?api-key=\(self.apiKey)"
        let url = URL(string: urlString)
        return url!
    }()

    fileprivate func convertStringFromDate(having dateFormat: String) -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: date)
    }
}
