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
            print("Presenting the main tab view controller")
            controller.present(destination, animated: true, completion: nil)
        }, onError: { (error) in })
    }

    static func convertToDate(dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZZZ"
        let date = dateFormatter.date(from: dateString)
        return date!
    }
    
    /**
     * Gets an alert controller containing the alert message.
     * Use it like:
     **/
    static func getAlertControllerWith(alertMessage: String, title: String = "OK", completionHandler: @escaping (UIAlertAction) -> ())-> UIAlertController {
        let alertController = UIAlertController(title: "Error", message: alertMessage, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: title, style: .cancel, handler: completionHandler)
        alertController.addAction(cancelAction)
        return alertController
    }
    
    static func generateRandomQuestionNumbers(numOfQuestions: Int, listOfSampleNumbers: [Int]) -> [Int] {
        let max = listOfSampleNumbers.count
        if (max < numOfQuestions) {
            // Invalid input
            return [0]
        }
        
        let totalCount: Int = numOfQuestions //Any number you asssign
        var randomNumArray: [Int] = []
        var i = 0
        while randomNumArray.count < totalCount {
            i += 1
            let rand = Int(arc4random_uniform(UInt32(max)))
            for _ in 0..<totalCount {
                if !randomNumArray.contains(rand){
                    randomNumArray.append(rand)
                }
            }
        }
        
        return randomNumArray
    }
}

extension UIColor {
    public convenience init?(hexString: String) {
        let r, g, b, a: CGFloat
        
        if hexString.hasPrefix("#") {
            let start = hexString.index(hexString.startIndex, offsetBy: 1)
            let hexColor = hexString.substring(from: start)
            
            if hexColor.characters.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    a = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    r = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    g = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    b = CGFloat(hexNumber & 0x000000ff) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        
        return nil
    }
}
