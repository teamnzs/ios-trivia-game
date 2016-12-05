//
//  Invite.swift
//  ios-trivia-game
//
//  Created by Savio Tsui on 11/28/16.
//  Copyright © 2016 Team NZS. All rights reserved.
//

import Foundation

class Invite: NSObject {
    var id: String?
    var roomId: String?
    var guestId: String?
    var hostId: String?
    
    init(id: String, dictionary: NSDictionary) {
        self.id = id
        self.guestId = dictionary["guest_id"] as? String
        self.hostId = dictionary["host_id"] as? String
        self.roomId = dictionary["room_id"] as? String
    }
    
    init(id: String? = "", roomId: String, guestId: String, hostId: String) {
        self.id = id
        self.roomId = roomId
        self.hostId = hostId
        self.guestId = guestId
    }
    
    func getJson() -> [String: Any] {
        return [
            "id": self.id as Any,
            "guest_id": self.guestId as Any,
            "host_id": self.hostId as Any,
            "room_id": self.roomId as Any
        ]
    }
}
