//
//  SplashViewController.swift
//  ios-trivia-game
//
//  Created by Nari Shin on 12/5/16.
//  Copyright © 2016 Team NZS. All rights reserved.
//

import Foundation
import UIKit

class SplashViewController: UIViewController {
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor(hexString: Constants.TRIVIA_NAVY)
        
        if (User.currentUser != nil) {
            print("logged in")
            DispatchQueue.main.async {
                [unowned self] in
                self.performSegue(withIdentifier: Constants.SPLASH_TO_MAIN_SEGUE, sender: nil)
            }
        } else {
            print("not logged in")
            DispatchQueue.main.async {
                [unowned self] in
                self.performSegue(withIdentifier: Constants.SPLASH_TO_LOGIN_SEGUE, sender: nil)
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
