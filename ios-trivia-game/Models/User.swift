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
    var nickname: String?
    var name: String?
    var email: String?
    var photoUrl: String?
    var uid: String?
    var facebookId: String?
    var firebaseId: String?
    var score: Int?
    var createdAt: String?
    var isActive: Int?
    var ranking: String?
    var dictionary: NSDictionary?
    
    class func convertFirUserToUser(firUser user: FIRUser) -> User {
        let url = user.photoURL
        let dictionary = [
            "nickname": "",
            "name": user.displayName!,
            "email": user.email ?? "",
            "photo_url": url?.absoluteString ?? "",
            "facebook_id": "",
            "firebase_id": user.uid,
            "score": 0,
            "created_at": String(describing: NSDate()),
            "is_active": 0,
            "ranking": "0"
        ] as NSDictionary
        
        return User(dictionary: dictionary)
    }
    
    init(dictionary: NSDictionary?) {
        if let dictionary = dictionary {
            self.nickname = dictionary["nickname"] as? String ?? ""
            self.name = dictionary["name"] as? String ?? ""
            self.email = dictionary["email"] as? String ?? ""
            self.photoUrl = dictionary["photo_url"] as? String ?? ""
            self.facebookId = dictionary["facebook_id"] as? String ?? ""
            self.firebaseId = dictionary["firebase_id"] as? String ?? ""
            self.uid =  self.facebookId //User.getSanitizedEmailForId(email: self.email!)
            self.score = dictionary["score"] as? Int ?? 0
            self.createdAt = dictionary["created_at"] as? String ?? String(describing: NSDate())
            self.isActive = dictionary["is_active"] as? Int ?? 0
            self.ranking = dictionary["ranking"] as? String ?? "0"
            self.dictionary = dictionary
        }
    }
    
    func getJson() -> [String: AnyObject] {
        return [
            "nickname": self.nickname as AnyObject,
            "name": self.name as AnyObject,
            "email": self.email as AnyObject,
            "photoUrl": self.photoUrl as AnyObject,
            "facebook_id": self.facebookId as AnyObject,
            "firebase_id": self.firebaseId as AnyObject,
            "score": self.score as AnyObject,
            "created_at": self.createdAt as AnyObject,
            "is_active": self.isActive as AnyObject,
            "ranking": self.ranking as AnyObject,
            "uid": self.uid as AnyObject
        ]
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
    
    class func loginWithFb(fbAccessToken accessToken: String!, completion completionHandler: @escaping (FIRUser?, Error?) -> ()) {
        let credential = FIRFacebookAuthProvider.credential(withAccessToken: accessToken!)
        FIRAuth.auth()?.signIn(with: credential, completion: completionHandler)
    }
    
    static fileprivate func getSanitizedEmailForId(email: String) -> String {
        return email.replacingOccurrences(of: ".", with: "_")
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
