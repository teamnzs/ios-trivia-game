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

//    struct MyProfileRequest: GraphRequestProtocol {
//        struct Response: GraphResponseProtocol {
//            init(rawResponse: Any?) {
//                // Decode JSON from rawResponse into other properties here.
//            }
//        }
//        
//        var graphPath = "/me/friends"
//        var parameters: [String : Any]? = ["fields": "id, name"]
//        var accessToken = AccessToken.current
//        var httpMethod: GraphRequestHTTPMethod = .GET
//        var apiVersion: GraphAPIVersion = .defaultVersion
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        print("access token : \(AccessToken.current)")
        
        
        let params = ["fields": "id, first_name, last_name, middle_name, name, email, picture"]
        let request = FBSDKGraphRequest(graphPath: "me/taggable_friends", parameters: params)
        request?.start(completionHandler: { (connection: FBSDKGraphRequestConnection?, result: Any?, error: Error?) in
            if error != nil {
                let errorMessage = error?.localizedDescription
                print("error: \(errorMessage)")
            }
//            else if result.isKindOfClass(NSDictionary){
//                /* Handle response */
//            }
            print("result : \(result)")
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onBackClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        _ = self.navigationController?.popViewController(animated: true)
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
