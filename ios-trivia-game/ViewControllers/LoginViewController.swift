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
import MBProgressHUD

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
            let animation = MBProgressHUD.showAdded(to: self.view, animated: true)
            animation?.animationType = .zoomIn
            animation?.activityIndicatorColor = UIColor.black
            animation?.dimBackground = true
            animation?.color = UIColor.white
            animation?.labelText = "Prepare your thinking hats..."
            animation?.labelColor = UIColor.black
            
            switch loginResult {
            case .failed(let error):
                print("Login failed!")
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(_, _, let accessToken):
                print("Logged in!")
                // @Zhia : Feel free to grab this authToken for Firebase - Nari
                User.loginWithFb(fbAccessToken: accessToken.authenticationToken, completion: {(firUser, error) in
                    if error != nil {
                        Logger.instance.log(logLevel: .error, message: "Could not login to Firebase with the fb auth token \(error.debugDescription)")
                        return
                    }
                    
                    let user = User.convertFirUserToUser(firUser: firUser!)
                    User.currentUser = user
                    Logger.instance.log(logLevel: .debug, message: "Successfully logged in to Firebase and set the user")
                    
                    MBProgressHUD.hide(for: self.view, animated: true)
                    self.performSegue(withIdentifier: Constants.LOGIN_MODAL_SEGUE, sender: self)
                })
            }
        }
    }
}

