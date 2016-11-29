//
//  SelectFriendsTableViewCell.swift
//  ios-trivia-game
//
//  Created by Nari Shin on 11/19/16.
//  Copyright © 2016 Team NZS. All rights reserved.
//

import UIKit

@objc protocol SelectFriendsTableViewCellDelegate {
    @objc optional func selectFriendsTableViewCell(selectFriendsTableViewCell: SelectFriendsTableViewCell, didChangeValue value: Bool)
}

class SelectFriendsTableViewCell: UITableViewCell {

    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var onSwitch: UISwitch!
    
    weak var delegate: SelectFriendsTableViewCellDelegate?
    
    var friend: Friend! {
        didSet {
            self.name.text = friend.name
            if let imageUrl = friend.pictureUrl {
                self.profilePicture.clipsToBounds = true
                self.profilePicture.setImageWith(URL(string: imageUrl)!)
                self.profilePicture.layer.cornerRadius = self.profilePicture.frame.size.width / 2;
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        onSwitch.addTarget(self, action: #selector(SelectFriendsTableViewCell.onSwitchChanged), for: UIControlEvents.valueChanged)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func onSwitchChanged(_ sender: Any) {
        delegate?.selectFriendsTableViewCell?(selectFriendsTableViewCell: self, didChangeValue: onSwitch.isOn)
    }
}
