//
//  SelectFriendsViewController.swift
//  ios-trivia-game
//
//  Created by Savio Tsui on 11/15/16.
//  Copyright © 2016 Team NZS. All rights reserved.
//

import UIKit
import FacebookCore
import FBSDKLoginKit

class SelectFriendsViewController: UIViewController {
    
    var numOfPlayers: Int?
    var isPublic: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        loadFriendsList()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onBackClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func loadFriendsList() {
        let params = ["fields": "id, first_name, last_name, middle_name, name, email, picture"]
        let request = FBSDKGraphRequest(graphPath: "me/taggable_friends", parameters: params)
        request?.start(completionHandler: { (connection: FBSDKGraphRequestConnection?, result: Any?, error: Error?) in
            if error != nil {
                let errorMessage = error?.localizedDescription
                print("error: \(errorMessage)")
            }
            print("result : \(result)")
            let data = result as! NSDictionary
            let dictionaries = data["data"] as! [NSDictionary]
            let friends = Friend.FriendsWithArray(dictionaries: dictionaries)
            for friend in friends {
                print("name : \(friend.name)")
            }
        })
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
