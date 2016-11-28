//
//  User.swift
//  ios-trivia-game
//
//  Created by Zhia Chong on 11/12/16.
//  Copyright © 2016 Team NZS. All rights reserved.
//

import Foundation
import FirebaseAuth
import Alamofire

var _currentUser: User?
let currentUserKey = "kCurrentUser"
let userDidLoginNotification = "userDidLoginNotification"
let userDidLogoutNotification = "userDidLogoutNotification"

class User: NSObject {
    var name: String?
    var email: String?
    var photoUrl: String?
    var uid: String?
    var score: Int?
    var createdAt: String?
    var isActive: Int?
    var ranking: String?
    var dictionary: NSDictionary?
    
    class func convertFirUserToUser(firUser user: FIRUser) -> User {
        let url = user.photoURL
        let dictionary = [
            "name": user.displayName!,
            "email": user.email ?? "",
            "photo_url": url?.absoluteString ?? "",
            "id": user.uid,
            "score": 0,
            "created_at": String(describing: NSDate()),
            "is_active": 0,
            "ranking": "0"
        ] as NSDictionary
        
        return User(dictionary: dictionary)
    }
    
    class func loginWithFb(fbAccessToken accessToken: String!, completion completionHandler: @escaping (FIRUser?, Error?) -> ()) {
        let credential = FIRFacebookAuthProvider.credential(withAccessToken: accessToken!)
        FIRAuth.auth()?.signIn(with: credential, completion: completionHandler)
    }
    
    init(dictionary: NSDictionary?) {
        if let dictionary = dictionary {
            self.name = dictionary["name"] as? String
            self.email = dictionary["email"] as? String
            self.photoUrl = dictionary["photo_url"] as? String
            self.uid = dictionary["id"] as? String
            self.score = dictionary["score"] as? Int
            self.createdAt = dictionary["created_at"] as? String
            self.isActive = dictionary["is_active"] as? Int
            self.ranking = dictionary["ranking"] as? String
            
            self.dictionary = dictionary
        }
    }
    
    func logout() {
        do {
            try FIRAuth.auth()?.signOut()
            User.currentUser = nil
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: userDidLogoutNotification), object: nil)
        } catch {
            print ("Some error while attempting to log out!")
        }
    }
    
    func getJson() -> [String: AnyObject] {
        return ["name": self.name as AnyObject, "email": self.email as AnyObject, "photoUrl": self.photoUrl as AnyObject, "uid": self.uid as AnyObject]
    }
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let data = UserDefaults.standard.object(forKey: currentUserKey) as? NSData
                if data != nil {
                    do {
                        let dictionary = try JSONSerialization.jsonObject(with: data as! Data, options: JSONSerialization.ReadingOptions.allowFragments)
                        _currentUser = User(dictionary:  dictionary as? NSDictionary)
                    } catch {
                        print ("Error while deserializing the object!" )
                    }
                }
            }
            
            return _currentUser
        }
        set(user) {
            _currentUser = user
            
            if _currentUser != nil {
                do {
                    let data = try JSONSerialization.data(withJSONObject: _currentUser?.getJson() as Any, options: .prettyPrinted)
                    UserDefaults.standard.set(data, forKey: currentUserKey)
                } catch {
                    print ("Error while trying to serialize!")
                }
                
            } else {
                UserDefaults.standard.set(nil, forKey: currentUserKey)
            }
            
            UserDefaults.standard.synchronize()
        }
    }
}
