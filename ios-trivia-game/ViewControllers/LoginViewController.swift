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
import FacebookLogin
import MBProgressHUD
import EMPageViewController

class LoginViewController: UIViewController {
    var pageViewController: EMPageViewController?
    
    var greetings: [String] = ["Welcome to Mind Game!", "Pick a Trivia Category, Play with Friends", "Fool your friends with fake answers, Pick the right answer!", "Have Fun!"]
    var greetingColors: [UIColor] = [
        UIColor(hexString: Constants.TRIVIA_BLUE)!,
        UIColor(hexString: Constants.TRIVIA_RED)!,
        UIColor(hexString: Constants.TRIVIA_NAVY)!,
        UIColor(hexString: Constants.TRIVIA_GRAY)!
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Instantiate EMPageViewController and set the data source and delegate to 'self'
        let pageViewController = EMPageViewController()
        
        // Or, for a vertical orientation
        // let pageViewController = EMPageViewController(navigationOrientation: .Vertical)
        pageViewController.dataSource = self
        pageViewController.delegate = self
        
        // Set the initially selected view controller
        // IMPORTANT: If you are using a dataSource, make sure you set it BEFORE calling selectViewController:direction:animated:completion
        let currentViewController = self.viewController(at: 0)!
        pageViewController.selectViewController(currentViewController, direction: .forward, animated: false, completion: nil)
        
        // Add EMPageViewController to the root view controller
        self.addChildViewController(pageViewController)
        self.view.insertSubview(pageViewController.view, at: 0) // Insert the page controller view below the navigation buttons
        pageViewController.didMove(toParentViewController: self)
        
        self.pageViewController = pageViewController

        initFBLogin()
        
        // The right way is to use FIRAuth
        if (User.currentUser != nil) {
            // This user is signed in
            
            Logger.instance.log(logLevel: .info, message: "The user is signed in!")
            
            FirebaseClient.instance.getGameRooms(complete: { (gameDictionary) in
                // gives all the rooms
                for (roomId, roomInfo) in gameDictionary {
                    let gameRoom = GameRoom(dictionary: roomInfo as! NSDictionary)
                    Logger.instance.log(logLevel: .info, message: "RoomId: \(roomId) \(gameRoom.getJson())")
                }
            }) { (error) in
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
        myLoginButton.backgroundColor = UIColor(hexString: Constants.TRIVIA_BLUE)
        myLoginButton.frame = CGRect(x: 0, y: 0, width: 180, height: 40);
        print ()
        myLoginButton.center = CGPoint(x: view.center.x, y: view.bounds.height - (40/2) - 30)
        myLoginButton.setTitle("Login with Facebook", for: .normal)
        
        // Handle clicks on the button
        myLoginButton.addTarget(self, action: #selector(self.loginButtonClicked), for: .touchUpInside)
        
        // Add the button to the view
        view.addSubview(myLoginButton)
    }
    
    @objc func loginButtonClicked() {
        let loginManager = LoginManager()
        loginManager.logIn(_:  [ .publicProfile, .userFriends, .email ], viewController: self) { loginResult in
            let animation = MBProgressHUD.showAdded(to: self.view, animated: true)
            
            switch loginResult {
            case .failed(let error):
                print("Login failed!")
                print(error)
                MBProgressHUD.hide(for: self.view, animated: true)
            case .cancelled:
                print("User cancelled login.")
                MBProgressHUD.hide(for: self.view, animated: true)
            case .success(_, _, let accessToken):
                print("Logged in!")
                animation?.animationType = .zoomIn
                animation?.activityIndicatorColor = UIColor(hexString: Constants.TRIVIA_NAVY)
                animation?.dimBackground = true
                animation?.color = UIColor.white
                animation?.labelText = "Prepare your thinking hats..."
                animation?.labelColor = UIColor.black
                
                // @Zhia : Feel free to grab this authToken for Firebase - Nari
                User.loginWithFb(fbAccessToken: accessToken.authenticationToken, completion: {(firUser, error) in
                    if error != nil {
                        Logger.instance.log(logLevel: .debug, message: "Could not login to Firebase with the fb auth token \(error.debugDescription)")
                        
                        MBProgressHUD.hide(for: self.view, animated: true)
                        return
                    }
                    
                    Logger.instance.log(logLevel: .debug, message: "Successfully logged in to Firebase and set the user")

                    let user = User.convertFirUserToUser(firUser: firUser!)
                    
                    // supplement FIRUser with actual facebook data to create the user
                    _ = FacebookClient.instance.getCurrentUserData(parameters: ["id"], complete: { (_, result: Any?, error: Error?) in
                        if error != nil {
                            Logger.instance.log(logLevel: .error, message: (error?.localizedDescription)!)
                            MBProgressHUD.hide(for: self.view, animated: true)
                            return
                        }
                        
                        let data = result as! NSDictionary
                        user.facebookId = data["id"] as? String
                        user.uid = user.facebookId
                        
                        // check Firebase User table for this user.
                        FirebaseClient.instance.getUser(userId: user.uid!, complete: { (snapshot) in
                            // If they do not exist, create a new one.
                            let value = snapshot.value as? NSDictionary
                            if (value == nil) {
                                FirebaseClient.instance.createUser(user: user, complete: { (_, _) in
                                    
                                    User.currentUser = user
                                    MBProgressHUD.hide(for: self.view, animated: true)
                                    self.performSegue(withIdentifier: Constants.LOGIN_MODAL_SEGUE, sender: self)
                                })
                            }
                            else {
                                // If they do exist update the existing user with the values we received from Facebook
                                FirebaseClient.instance.updateUser(user: user, fromFacebook: true)
                                
                                FirebaseClient.instance.getUser(userId: user.uid!, complete: { (snapshot) in
                                    if let data = snapshot.value as? NSDictionary {
                                        let loggedInUser = User(dictionary: data)
                                        User.currentUser = loggedInUser
                                    }
                                }, onError: { (_) in })
                                
                                MBProgressHUD.hide(for: self.view, animated: true)
                                self.performSegue(withIdentifier: Constants.LOGIN_MODAL_SEGUE, sender: self)
                            }
                        }, onError: { (_) in
                            MBProgressHUD.hide(for: self.view, animated: true)
                            self.performSegue(withIdentifier: Constants.LOGIN_MODAL_SEGUE, sender: self)
                        })
                        
                        Logger.instance.log(logLevel: .debug, message: "Successfully logged in to Firebase and set the user")
                    })
                })
            }
        }
    }
}

extension LoginViewController: EMPageViewControllerDataSource {
    func em_pageViewController(_ pageViewController: EMPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        if let viewControllerIndex = self.index(of: viewController as! TutorialViewController) {
            let beforeViewController = self.viewController(at: viewControllerIndex - 1)
            return beforeViewController
        } else {
            return nil
        }
    }
    
    func em_pageViewController(_ pageViewController: EMPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        if let viewControllerIndex = self.index(of: viewController as! TutorialViewController) {
            let afterViewController = self.viewController(at: viewControllerIndex + 1)
            return afterViewController
        } else {
            return nil
        }
    }
    
    func viewController(at index: Int) -> TutorialViewController? {
        if (self.greetings.count == 0) || (index < 0) || (index >= self.greetings.count) {
            return nil
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: Constants.TUTORIAL_VIEW_CONTROLLER) as! TutorialViewController
        viewController.greeting = self.greetings[index]
        viewController.color = self.greetingColors[index]
        return viewController
    }
    
    func index(of viewController: TutorialViewController) -> Int? {
        if let greeting: String = viewController.greeting {
            return self.greetings.index(of: greeting)
        } else {
            return nil
        }
    }

    
}

extension LoginViewController: EMPageViewControllerDelegate {
    func em_pageViewController(_ pageViewController: EMPageViewController, willStartScrollingFrom startViewController: UIViewController, destinationViewController: UIViewController) {
        
        let startGreetingViewController = startViewController as! TutorialViewController
        let destinationGreetingViewController = destinationViewController as! TutorialViewController
        
        print("Will start scrolling from \(startGreetingViewController.greeting) to \(destinationGreetingViewController.greeting).")
    }
    
    func em_pageViewController(_ pageViewController: EMPageViewController, isScrollingFrom startViewController: UIViewController, destinationViewController: UIViewController, progress: CGFloat) {
        let startGreetingViewController = startViewController as! TutorialViewController
        let destinationGreetingViewController = destinationViewController as! TutorialViewController
        
        // Ease the labels' alphas in and out
        let absoluteProgress = fabs(progress)
        startGreetingViewController.label.alpha = pow(1 - absoluteProgress, 2)
        destinationGreetingViewController.label.alpha = pow(absoluteProgress, 2)
        
        print("Is scrolling from \(startGreetingViewController.greeting) to \(destinationGreetingViewController.greeting) with progress '\(progress)'.")
    }
    
    func em_pageViewController(_ pageViewController: EMPageViewController, didFinishScrollingFrom startViewController: UIViewController?, destinationViewController: UIViewController, transitionSuccessful: Bool) {
        let startViewController = startViewController as! TutorialViewController?
        let destinationViewController = destinationViewController as! TutorialViewController
        
        // If the transition is successful, the new selected view controller is the destination view controller.
        // If it wasn't successful, the selected view controller is the start view controller
        print("Finished scrolling from \(startViewController?.greeting) to \(destinationViewController.greeting). Transition successful? \(transitionSuccessful)")
    }
}
