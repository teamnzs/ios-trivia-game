//
//  FacebookClient.swift
//  ios-trivia-game
//
//  Created by Savio Tsui on 12/1/16.
//  Copyright © 2016 Team NZS. All rights reserved.
//

import Foundation
import FBSDKLoginKit

class FacebookClient {
    
    static let instance = FacebookClient()
    
    private init() {}
    
    // gets current user taggable friends
    func getCurrentUserTaggableFriends(parameters: [String]? = ["id", "first_name", "last_name", "middle_name", "name", "email", "picture"], complete: FBSDKCoreKit.FBSDKGraphRequestHandler!) -> FBSDKGraphRequestConnection! {
        let paramString = parameters!.joined(separator: ", ")
        let request = FBSDKGraphRequest(graphPath: "me/taggable_friends", parameters: ["fields": paramString])
        return request?.start(completionHandler: complete)
    }
    
    // gets current user registered friends
    func getCurrentUserFriends(parameters: [String]? = ["id", "first_name", "last_name", "middle_name", "name", "email", "picture"], complete: FBSDKCoreKit.FBSDKGraphRequestHandler!) -> FBSDKGraphRequestConnection! {
        let paramString = parameters!.joined(separator: ", ")
        let request = FBSDKGraphRequest(graphPath: "me/friends", parameters: ["fields": paramString])
        return request?.start(completionHandler: complete)
    }
    
    // gets current user data
    func getCurrentUserData(parameters: [String]? = ["id", "first_name", "last_name", "middle_name", "name", "email", "picture"], complete: FBSDKCoreKit.FBSDKGraphRequestHandler!) -> FBSDKGraphRequestConnection! {
        let paramString = parameters!.joined(separator: ", ")
        let request = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": paramString])
        return request?.start(completionHandler: complete)
    }

}
