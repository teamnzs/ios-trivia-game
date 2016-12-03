//
//  HomeTableViewCell.swift
//  ios-trivia-game
//
//  Created by Zhia Chong on 11/17/16.
//  Copyright © 2016 Team NZS. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    
    var gameRoomInfo: GameRoom! {
        didSet {
            self.gameTitle.text = gameRoomInfo.name.uppercased()
            let curQuestion = gameRoomInfo.current_question 
            let maxQuestions = gameRoomInfo.max_num_of_questions
            let questionsAsked = max(0, curQuestion! - 1)
            self.questionsAsked.text = "\(questionsAsked) / \(maxQuestions) questions asked"
            
            let currentNumPlayers = gameRoomInfo.current_num_players
            self.peopleInGame.text = "\(currentNumPlayers) / \(gameRoomInfo.max_num_of_people) players joined"
        }
    }

    @IBOutlet weak var gameTitle: UILabel!
    @IBOutlet weak var questionsAsked: UILabel!
    @IBOutlet weak var peopleInGame: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
