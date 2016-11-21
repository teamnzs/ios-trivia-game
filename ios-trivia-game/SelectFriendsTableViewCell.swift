//
//  SelectFriendsTableViewCell.swift
//  ios-trivia-game
//
//  Created by Nari Shin on 11/19/16.
//  Copyright © 2016 Team NZS. All rights reserved.
//

import UIKit

class SelectFriendsTableViewCell: UITableViewCell {

    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    var friend: Friend! {
        didSet {
            name.text = friend.name
            if let imageUrl = friend.pictureUrl {
                profilePicture.setImageWith(URL(string: imageUrl)!)
            }
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
