//
//  FinalResultTableViewCell.swift
//  ios-trivia-game
//
//  Created by Savio Tsui on 11/27/16.
//  Copyright © 2016 Team NZS. All rights reserved.
//

import Foundation
import UIKit

class FinalScoreTableViewCell: UITableViewCell {
    
    @IBOutlet weak var playerLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    
    var finalScore: FinalScore! {
        didSet {
            self.pointsLabel.text = String(describing: finalScore.score!)
            self.playerLabel.text = finalScore.user.name
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
