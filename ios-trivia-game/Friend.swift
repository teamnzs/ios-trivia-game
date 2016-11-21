//
//  Friend.swift
//  ios-trivia-game
//
//  Created by Nari Shin on 11/20/16.
//  Copyright © 2016 Team NZS. All rights reserved.
//

import Foundation

class Friend: NSObject {
    var id: String?
    var name: String?
    var pictureUrl: String?
    var isSelected: Bool?
    
    init(dictionary: NSDictionary) {
        self.id = dictionary["id"] as? String
        self.name = dictionary["name"] as? String
        
        let picture = dictionary["picture"] as? NSDictionary
        
        if picture != nil {
            let data = picture!["data"] as? NSDictionary
            if data != nil {
                pictureUrl = data!["url"] as? String
            } else {
                pictureUrl = ""
            }
        } else {
            pictureUrl = ""
        }
        
        isSelected = false
    }
    
    class func FriendsWithArray(dictionaries: [NSDictionary]) -> [Friend] {
        var friends = [Friend]()
        
        for dictionary in dictionaries {
            let friend = Friend(dictionary: dictionary)
            friends.append(friend)
        }
        
        return friends
    }
}
