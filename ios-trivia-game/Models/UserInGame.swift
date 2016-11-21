//
//  File.swift
//  ios-trivia-game
//
//  Created by Savio Tsui on 11/20/16.
//  Copyright © 2016 Team NZS. All rights reserved.
//

import Foundation
import FirebaseDatabase

class UserInGame : NSObject {
    var roomId : String?
    var userState: Int?
    var userId: String?
    
    init(dictionary: NSDictionary) {
        self.roomId = (dictionary["room_id"] as? String) ?? ""
        self.userState = (dictionary["user_state"] as? Int) ?? -1
        self.userId = (dictionary["user_id"] as? String) ?? ""
    }
    
    func getJson() -> [String: Any] {
        return [
            "room_id": self.roomId as Any,
            "user_id": self.userId as Any,
            "user_state": self.userState as Any
        ]
    }
}
