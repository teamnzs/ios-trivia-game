//
//  InviteTableViewCell.swift
//  ios-trivia-game
//
//  Created by Savio Tsui on 11/28/16.
//  Copyright © 2016 Team NZS. All rights reserved.
//

import UIKit

class InviteTableViewCell: UITableViewCell {

    @IBOutlet weak var gameRoomLabel: UILabel!
    @IBOutlet weak var hostNameLabel: UILabel!
    @IBOutlet weak var playerCountLabel: UILabel!
    
    var invite: Invite! {
        didSet {
            FirebaseClient.instance.getUser(userId: invite.hostId!, complete: { (snapshot) in
                if let data = snapshot.value as? NSDictionary {
                    let hostUser = User(dictionary: data)
                    self.hostNameLabel.text = hostUser.name
                }
            }, onError: { (error) in })
            
            FirebaseClient.instance.getGameBy(roomId: invite.roomId!, complete: { (snapshot) in
                if let data = snapshot.value as? NSDictionary {
                    if data.count > 0 {
                        let gameRoom = GameRoom(dictionary: data[data.allKeys.first as! String] as! NSDictionary)
                        self.gameRoomLabel.text = gameRoom.name
                        self.playerCountLabel.text = "\(gameRoom.current_num_players) / \(gameRoom.max_num_of_people) players joined"
                    }
                }
            }, onError: { (error) in })
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
