//
//  Utilities.swift
//  ios-trivia-game
//
//  Created by Savio Tsui on 11/21/16.
//  Copyright © 2016 Team NZS. All rights reserved.
//

import Foundation
import UIKit

class Utilities {
    static func quitGame(controller: UIViewController) {
        FirebaseClient.instance.quitGame(complete: {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let destination = storyboard.instantiateViewController(withIdentifier: Constants.MAIN_TAB_VIEW_CONTROLLER) as! MainTabViewController
            destination.selectedIndex = 0
            destination.navigationController?.isNavigationBarHidden = true
            controller.present(destination, animated: true, completion: nil)
        }, onError: { (error) in })
    }
}
