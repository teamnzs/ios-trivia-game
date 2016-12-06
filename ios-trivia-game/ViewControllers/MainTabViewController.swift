//
//  MainTabViewController.swift
//  ios-trivia-game
//
//  Created by Savio Tsui on 11/15/16.
//  Copyright © 2016 Team NZS. All rights reserved.
//

import UIKit

class MainTabViewController: UITabBarController {
    var notificationLabel: UILabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = true
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.gray], for:.normal)
        
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor(hexString: Constants.TRIVIA_RED) ?? UIColor.blue], for:.selected)
        
        
        notificationLabel = UILabel(frame: CGRect(x: 0, y: 30, width: self.view.bounds.width, height: 30))
        notificationLabel.backgroundColor = UIColor(hexString: Constants.TRIVIA_BLUE)
        notificationLabel.text = "You've been invited to a new game!"
        notificationLabel.textColor = UIColor.white
        notificationLabel.textAlignment = .center
        notificationLabel.alpha = 0.0
        self.view.addSubview(notificationLabel)
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
            if let _ = snapshot.value as? NSDictionary {
                UIView.animate(withDuration: 1.0, animations: {() in
                    self.notificationLabel.alpha = 1.0
                })
                UIView.animate(withDuration: 0.5, delay: 5.0, options: .curveEaseIn, animations: {() in
                    self.notificationLabel.alpha = 0.0
                }, completion: nil)
            }
        }, onError: { (error) in })
    }
}
