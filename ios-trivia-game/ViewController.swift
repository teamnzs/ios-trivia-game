//
//  ViewController.swift
//  ios-trivia-game
//
//  Created by Savio Tsui on 11/8/16.
//  Copyright © 2016 Team NZS. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        testJService()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func testJService() {
        JServiceClient.instance.categories(success: { (response) in
            Logger.instance.log(logLevel: .info, message: "success categories")
        }, failure: { (error) in
            print(error.debugDescription)
        })
        
        JServiceClient.instance.category(id: 11496, success: { (response) in
            Logger.instance.log(logLevel: .info, message: "success category")
        }, failure: { (error) in
            print(error.debugDescription)
        })
        
        JServiceClient.instance.clues(categoryId: 136, offset: 200, success: { (response) in
            Logger.instance.log(logLevel: .info, message: "success clues")
        }, failure: { (error) in
            print(error.debugDescription)
        })
        
        JServiceClient.instance.random(count: 10, success: { (response) in
            Logger.instance.log(logLevel: .info, message: "success random")
        }, failure: { (error) in
            print(error.debugDescription)
        })
    }
}

