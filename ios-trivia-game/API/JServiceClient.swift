//
//  JServiceClient.swift
//  ios-trivia-game
//
//  Created by Savio Tsui on 11/10/16.
//  Copyright © 2016 Team NZS. All rights reserved.
//

import Foundation
import Alamofire

// API Documentation: http://jservice.io/
class JServiceClient {
    fileprivate static let jServiceApiUrl = "http://jservice.io/api/"
    
    static let instance = JServiceClient()
    
    private init() {}
    
    fileprivate func afRequest(api: String, method: HTTPMethod = .get, parameters: Parameters, success: @escaping (Any?) -> (), failure: @escaping (Error?) -> ()) {
        Alamofire.request(api, method: method, parameters: parameters)
            .validate()
            .responseJSON { response in
                Logger.instance.log(logLevel: .debug, message: response.request!)  // original URL request
                Logger.instance.log(logLevel: .debug, message: response.response!) // HTTP URL response
                Logger.instance.log(logLevel: .debug, message: response.data!)     // server data
                Logger.instance.log(logLevel: .debug, message: response.result)   // result of response serialization
                
                switch response.result {
                case .success:
                    success(response.result.value)
                case .failure(let error):
                    failure(error)
                }
        }
    }
    
    // http://jservice.io/api/categories?count=100&offset=100
    func categories(count: Int = 10, offset: Int = 0, success: @escaping (Any?) -> (), failure: @escaping (Error?) -> ()) {
        let parameters: Parameters = ["count": String(count)]
        
        // response.result.value is an NSArray
        afRequest(api: "\(JServiceClient.jServiceApiUrl)categories", parameters: parameters, success: success, failure: failure)
    }
    
    // http://jservice.io/api/category?id=11496
    func category(id: Int, success: @escaping (Any?) -> (), failure: @escaping (Error?) -> ()) {
        let parameters: Parameters = ["id": String(id)]
        
        // response.result.value is an NSDictionary
        afRequest(api: "\(JServiceClient.jServiceApiUrl)category", parameters: parameters, success: success, failure: failure)
    }
    
    // http://jservice.io/api/random?count=10
    func random(count: Int, success: @escaping (Any?) -> (), failure: @escaping (Error?) -> ()) {
        let parameters: Parameters = ["count": String(count)]
        
        // response.result.value is an NSArray
        afRequest(api: "\(JServiceClient.jServiceApiUrl)random", parameters: parameters, success: success, failure: failure)
    }
    
    // http://jservice.io/api/clues?category=136&offset=200
    // always returns all clues, offset reindexes the clues based on the offset.  It isn't a circular reindexing.
    func clues(value: Int? = nil, categoryId: Int, offset: Int = 0, success: @escaping (Any?) -> (), failure: @escaping (Error?) -> ()) {
        var parameters: Parameters = [
            "category": String(categoryId),
            "offset": String(offset)
        ]
        
        if (value != nil) {
            parameters["value"] = String(describing: value)
        }
        
        // response.result.value is an NSArray
        afRequest(api: "\(JServiceClient.jServiceApiUrl)clues", parameters: parameters, success: success, failure: failure)
    }
    
    let popularCategories: [String: String] =
        [
            "306" : "Potpourriiii",
            "136" : "Stupid Answers",
            "42" : "Sports",
            "780" : "American History",
            "21" : "Animals",
            "105" : "3 Letter Words",
            "25" : "Science",
            "103" : "Transportation",
            "7" : "U.S. Cities",
            "442" : "People",
            "67" : "Television",
            "227" : "Hodgepodge",
            "109" : "State Capitals",
            "114" : "History",
            "31" : "The Bible",
            "176" : "Business &amp; Industry",
            "582" : "U.S. Geography",
            "1114" : "Annual Events",
            "508" : "Common Bonds",
            "49" : "Food",
            "561" : "Rhyme Time",
            "223" : "Word Origins",
            "770" : "Pop Music",
            "622" : "Holidays &amp; Observances",
            "313" : "Americana",
            "253" : "Food &amp; Drink",
            "420" : "Weights &amp; Measures",
            "83" : "Potent Potables",
            "184" : "Musical Instruments",
            "211" : "Bodies Of Water",
            "51" : "4 Letter Words",
            "539" : "Museums",
            "267" : "Nature",
            "357" : "Organizations",
            "530" : "World History",
            "369" : "Travel &amp; Tourism",
            "672" : "Colleges &amp; Universities",
            "793" : "Nonfiction",
            "78" : "World Capitals",
            "574" : "Literature",
            "777" : "Fruits &amp; Vegetables",
            "680" : "Mythology",
            "50" : "U.S. History",
            "99" : "Religion",
            "309" : "The Movies",
            "41" : "First Ladies",
            "26" : "Fashion",
            "249" : "Homophones",
            "1420" : "Quotations",
            "218" : "Science &amp; Nature",
            "1145" : "Foreign Words &amp; Phrases",
            "1079" : "Around The World",
            "139" : "5 Letter Words",
            "89" : "Double Talk",
            "17" : "U.S. States",
            "197" : "Books &amp; Authors",
            "37" : "Nursery Rhymes",
            "2537" : "Brand Names",
            "705" : "Familiar Phrases",
            "1800" : "Before &amp; After",
            "897" : "Body Language",
            "1195" : "Number, Please",
            "128" : "The Old Testament"
    ]
}
