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
    static func quitGame(controller: UIViewController, roomId: String?, hasJoined: Bool = true) {
        
        if (roomId != nil && hasJoined) {
            
            FirebaseClient.instance.getGameBy(roomId: roomId!, complete: { (snapshot) in
                if let data = snapshot.value as? NSDictionary {
                    if data.count > 0 {
                        let gameRoom = GameRoom(dictionary: data[data.allKeys.first as! String] as! NSDictionary)
                        
                        // decrement player count
                        if (gameRoom.current_num_players > 0) {
                            FirebaseClient.instance.updatePlayerCount(roomId: roomId!, change: -1)
                        }
                        else {
                            // remove game if no one is in game
                            FirebaseClient.instance.removeGame(roomId: roomId!, complete: { }, onError: { (error) in })
                        }
                    }
                }
            }, onError: { (_) in })
        }
        
        FirebaseClient.instance.quitGame(complete: {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let destination = storyboard.instantiateViewController(withIdentifier: Constants.MAIN_TAB_VIEW_CONTROLLER) as! MainTabViewController
            destination.selectedIndex = 0
            destination.navigationController?.isNavigationBarHidden = true
            controller.present(destination, animated: true, completion: nil)
        }, onError: { (error) in })
    }
 
    static func convertToDate(dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZZZ"
        let date = dateFormatter.date(from: dateString)
        return date!
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
