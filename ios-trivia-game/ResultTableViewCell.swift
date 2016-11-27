//
//  ResultTableViewCell.swift
//  ios-trivia-game
//
//  Created by Savio Tsui on 11/25/16.
//  Copyright © 2016 Team NZS. All rights reserved.
//

import UIKit

class ResultTableViewCell: UITableViewCell {
    
    @IBOutlet weak var playerLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!

    fileprivate var user : User!
    
    var scoredAnswer: ScoredAnswer! {
        didSet {
            FirebaseClient.instance.getUser(userId: scoredAnswer.userId, complete: { (snapshot) in
                if let data = snapshot.value as? NSDictionary {
                    self.user = User(dictionary: data)
                    self.playerLabel.text = self.user.name
                }
            }, onError: { (error) in
            })
            
            self.pointsLabel.text = String(scoredAnswer.score)
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
