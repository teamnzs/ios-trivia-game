//
//  ViewController.swift
//  ios-trivia-game
//
//  Created by Savio Tsui on 11/8/16.
//  Copyright © 2016 Team NZS. All rights reserved.
//

import Foundation
import UIKit
//import FBSDKLoginKit
import FirebaseAuth
import FirebaseDatabase
import FacebookCore
import FacebookLogin

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        testJService()
        
        //testFbLogin()
        initFBLogin()
        
        // The right way is to use FIRAuth
        if (User.currentUser != nil) {
            // This user is signed in
            
            Logger.instance.log(logLevel: .info, message: "The user is signed in!")
            let ref = FIRDatabase.database().reference()
            ref.child(Constants.GAME_ROOM_TABLE_NAME).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let value = snapshot.value as? NSDictionary
                
                // gives all the rooms
                for (roomId, roomInfo) in value! {
                    let gameRoom = GameRoom(dictionary: roomInfo as! NSDictionary)
                    Logger.instance.log(logLevel: .info, message: "RoomId: \(roomId) \(gameRoom.getJson())")
                }
            }) { (error) in
                Logger.instance.log(logLevel: .error, message: error.localizedDescription)
            }
            
        } else {
            Logger.instance.log(logLevel: .info, message: "The user is not signed in!")
        }
        
    }
    
//    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
//        Logger.instance.log(logLevel: .info, message: "Did log out")
//    }
//    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
//        Logger.instance.log(logLevel: .info, message: "Successfully login! \(result)")
//        Logger.instance.log(logLevel: .info, message: result.token.tokenString)
//        
//        User.loginWithFb(fbAccessToken: result.token.tokenString, completion: {(success: FIRUser?, error: Error?) -> Void in
//            if (error == nil) {
//                Logger.instance.log(logLevel: .info, message: "Successfully logged in! \(success)")
//                Logger.instance.log(logLevel: .info, message: success.debugDescription)
//                User.currentUser = User.convertFirUserToUser(firUser: success!)
//                Logger.instance.log(logLevel: .info, message: User.currentUser?.getJson() as Any)
//                NotificationCenter.default.post(name: NSNotification.Name(rawValue: userDidLoginNotification), object: nil)
//            }
//        })
//    }



    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func testFbLogin() {
//        let login = FBSDKLoginButton()
//        view.addSubview(login)
//        login.center = view.center
//        login.delegate = self
//    }

    func testJService() {
        JServiceClient.instance.categories(success: { (response) in
            Logger.instance.log(logLevel: .info, message: "success categories")
        }, failure: { (error) in
            Logger.instance.log(logLevel: .error, message: error.debugDescription)
        })
        
        JServiceClient.instance.category(id: 11496, success: { (response) in
            Logger.instance.log(logLevel: .info, message: "success category")
        }, failure: { (error) in
            Logger.instance.log(logLevel: .error, message: error.debugDescription)
        })
        
        JServiceClient.instance.clues(categoryId: 136, offset: 200, success: { (response) in
            Logger.instance.log(logLevel: .info, message: "success clues")
        }, failure: { (error) in
            Logger.instance.log(logLevel: .error, message: error.debugDescription)
        })
        
        JServiceClient.instance.random(count: 10, success: { (response) in
            Logger.instance.log(logLevel: .info, message: "success random")
        }, failure: { (error) in
            Logger.instance.log(logLevel: .error, message: error.debugDescription)
        })
    }
    
    func initFBLogin() {
        let myLoginButton = UIButton(type: .custom)
        myLoginButton.backgroundColor = UIColor.darkGray
        myLoginButton.frame = CGRect(x: 0, y: 0, width: 180, height: 40);
        myLoginButton.center = view.center;
        myLoginButton.setTitle("My Login Button", for: .normal)
        
        // Handle clicks on the button
        myLoginButton.addTarget(self, action: #selector(self.loginButtonClicked), for: .touchUpInside)
        
        // Add the button to the view
        view.addSubview(myLoginButton)
    }
    
    @objc func loginButtonClicked() {
        let loginManager = LoginManager()
        loginManager.logIn(_:  [ .publicProfile, .userFriends, .email ], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print("Login failed!")
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                print("Logged in!")
                print(accessToken.authenticationToken)
            }
        }
    }
}

