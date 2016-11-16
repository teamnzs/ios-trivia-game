//
//  LoginViewController.swift
//  ios-trivia-game
//
//  Created by Savio Tsui on 11/8/16.
//  Copyright © 2016 Team NZS. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseDatabase
import FacebookCore
import FacebookLogin

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                // @Zhia : Feel free to grab this authToken for Firebase - Nari
                print(accessToken.authenticationToken)
            }
        }
    }
}

