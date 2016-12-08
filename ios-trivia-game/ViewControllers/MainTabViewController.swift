//
//  MainTabViewController.swift
//  ios-trivia-game
//
//  Created by Savio Tsui on 11/15/16.
//  Copyright © 2016 Team NZS. All rights reserved.
//

import UIKit
import SwiftIconFont

class MainTabViewController: UITabBarController {
    var notificationLabel: UILabel = UILabel()

    var itemLabels = ["Home", "Create", "Profile", "Invites"]
    var itemIcons = ["home", "gamepad", "user", "paper-plane"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = true
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.gray], for:.normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor(hexString: Constants.TRIVIA_RED) ?? UIColor.red], for:.selected)
        UITabBar.appearance().tintColor = UIColor(hexString: Constants.TRIVIA_RED)
        
        notificationLabel = UILabel(frame: CGRect(x: 0, y: 35, width: self.view.bounds.width, height: 30))
        notificationLabel.backgroundColor = UIColor(hexString: Constants.TRIVIA_BLUE)
        notificationLabel.text = "You've been invited to a new game!"
        notificationLabel.textColor = UIColor.white
        notificationLabel.textAlignment = .center
        notificationLabel.alpha = 0.0
        self.view.addSubview(notificationLabel)

        let tabItems = self.tabBar.items as [UITabBarItem]!
        
        for index in 0..<itemLabels.count {
            let currentItem = (tabItems?[index])! as UITabBarItem
            currentItem.title = itemLabels[index]
            currentItem.icon(from: .FontAwesome, code: itemIcons[index], imageSize: CGSize(width: 20, height: 20), ofSize: 20)
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MainTabViewController {
    override func viewDidAppear(_ animated: Bool) {
        
        FirebaseClient.instance.getInvitesFor(userId: (User.currentUser?.uid)!, complete: { (snapshot) in
            if let data = snapshot.value as? NSDictionary {
                
                for (key, value) in data {
                    let invite = Invite(id: key as! String, dictionary: value as! NSDictionary)
                    
                    FirebaseClient.instance.getGameBy(roomId: invite.roomId!, complete: { (snapshot) in
                        if let data = snapshot.value as? NSDictionary {
                            if data.count > 0 {
                                let gameRoom = GameRoom(dictionary: data)
                                
                                // only display invites that are not expired
                                let timeIntervalSinceGameCreation = Date().timeIntervalSince(gameRoom.created_time)
                                if (timeIntervalSinceGameCreation > 0 && timeIntervalSinceGameCreation <= Double(Constants.GAME_START_COUNTDOWN)) {
                                   // there's at least a new invite ready for the current user
                                    UIView.animate(withDuration: 1.0, animations: {() in
                                        self.notificationLabel.alpha = 1.0
                                    })
                                    
                                    // automatically disappear after 5 seconds
                                    UIView.animate(withDuration: 0.5, delay: 5.0, options: .curveEaseIn, animations: {() in
                                        self.notificationLabel.alpha = 0.0
                                    }, completion: nil)
                                    
                                }
                                else {
                                    // delete the invite since it's expired
                                    FirebaseClient.instance.removeInvite(inviteId: invite.roomId!, complete: {
                                    }, onError: { (_) in })
                                }
                            }
                        }
                    }, onError: { (_) in })
                }
            }
        }, onError: { (error) in })
    }
}
