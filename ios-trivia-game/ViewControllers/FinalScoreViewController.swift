//
//  FinalScoreViewController.swift
//  ios-trivia-game
//
//  Created by Savio Tsui on 11/15/16.
//  Copyright © 2016 Team NZS. All rights reserved.
//

import UIKit

class FinalScoreViewController: UIViewController {
    
    @IBOutlet weak var timerButton: UIBarButtonItem!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var maxScoreLabel: UILabel!
    @IBOutlet weak var finalScoreTable: UITableView!
    
    var roomId: String!
    
    fileprivate var timerCount = Constants.GAME_QUESTION_ANSWER_COUNTDOWN
    fileprivate var countdownTimer = Timer()
    
    fileprivate var finalScores: [FinalScore] = []
    fileprivate var currentUserFinalScore: FinalScore?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        
        
        finishButton.tintColor = UIColor(hexString: Constants.TRIVIA_RED)
        self.countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
        
        self.finalScoreTable.delegate = self
        self.finalScoreTable.dataSource = self
        self.finalScoreTable.estimatedRowHeight = 100
        self.finalScoreTable.rowHeight = UITableViewAutomaticDimension
        
        // given a room id, find all players in the game
        // for each player, create a FinalScore
        FirebaseClient.instance.getUsersInGameBy(roomId: roomId, complete: { (snapshot) in
            if let data = snapshot.value as? NSDictionary {
                for (userId, _) in data {
                    
                    print ("Got users in game: \(userId)")
                    // get each user
                    FirebaseClient.instance.getUser(userId: userId as! String, complete: { (snapshot) in
                        if let data = snapshot.value as? NSDictionary {
                            print("Got user: \(data)")
                            let user = User(dictionary: data)
                            
                            // get each score
                            FirebaseClient.instance.getScoredAnswersBy(roomId: self.roomId, userId: user.uid!, complete: { (scoredAnswersData) in
                                var playerGameScore: Int = 0
                                print("Got my scored answers data: \(scoredAnswersData)")
                                for scoredAnswerData in (scoredAnswersData as NSArray) {
                                    let scoredAnswer = ScoredAnswer(dictionary: scoredAnswerData as! NSDictionary)
                                    playerGameScore += scoredAnswer.score
                                }
                                
                                let finalScore = FinalScore(roomId: self.roomId, user: user, score: playerGameScore)
                                print("got my final score: \(finalScore)")
                                
                                if (finalScore.user.uid! == User.currentUser?.uid!) {
                                    self.currentUserFinalScore = finalScore
                                }
                                
                                self.finalScores.append(finalScore)
                                self.finalScoreTable.reloadData()
                            }, onError: { (error) in
                            })
                        }
                    }, onError: { (error) in })
                }
            }
        }, onError: { (error) in })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onFinish(_ sender: UIButton) {
        print("Finishing the game")
        finishGame()
    }
    
    @objc fileprivate func updateCounter() {
        timerCount -=  1
        timerButton.title = ""
        
        if (timerCount > 0) {
            timerButton.title = "\(timerCount)s"
        }
        else {
            finishGame()
        }
    }
    
    fileprivate func finishGame() {
        countdownTimer.invalidate()
        
        // update current user with added score value
        if self.currentUserFinalScore != nil {
            print("Updated the score")
            FirebaseClient.instance.updateScore(userId: (User.currentUser?.uid)!, addValue: self.currentUserFinalScore!.score!)
        }
        
        // quit game
        Utilities.quitGame(controller: self, roomId: roomId)
    }
}

extension FinalScoreViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return finalScores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.FINAL_SCORE_TABLE_VIEW_CELL, for: indexPath) as! FinalScoreTableViewCell
        cell.finalScore = (finalScores[indexPath.row]) as FinalScore
        return cell
    }
}

