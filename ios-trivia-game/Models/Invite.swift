//
//  Invite.swift
//  ios-trivia-game
//
//  Created by Savio Tsui on 11/28/16.
//  Copyright © 2016 Team NZS. All rights reserved.
//

import Foundation

class Invite: NSObject {
    var roomId: String?
    var userId: String?
    var hostId: String?
    
    init(dictionary: NSDictionary) {
        self.userId = dictionary["user_id"] as? String
        self.hostId = dictionary["host_id"] as? String
        self.roomId = dictionary["room_id"] as? String
    }
    
    init(roomId: String, userId: String, hostId: String) {
        self.roomId = roomId
        self.hostId = hostId
        self.userId = userId
    }
    
    func getJson() -> [String: Any] {
        return [
            "user_id": self.userId as Any,
            "host_id": self.hostId as Any,
            "room_id": self.roomId as Any
        ]
    }
}
