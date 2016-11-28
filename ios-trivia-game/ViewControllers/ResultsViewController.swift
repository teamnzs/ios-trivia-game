//
//  ResultsViewController.swift
//  ios-trivia-game
//
//  Created by Savio Tsui on 11/15/16.
//  Copyright © 2016 Team NZS. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController {
    
    fileprivate let CORRECT_ANSWERS = 0
    fileprivate let WRONG_ANSWERS = 1
    fileprivate let NO_ANSWERS = 2

    @IBOutlet weak var timerButton: UIBarButtonItem!
    @IBOutlet weak var resultsTitleLabel: UILabel!
    @IBOutlet weak var resultsTableView: UITableView!
    @IBOutlet weak var nextQuestionButton: UIButton!
    @IBOutlet weak var maxScoreLabel: UILabel!
    
    var roomId: String?
    var question: TriviaQuestion?
    fileprivate var gameRoom: GameRoom?
    fileprivate var results: [[ScoredAnswer]]? = [[], [], []]
    fileprivate var resultsHeaders: [String] = ["Correct", "Incorrect", "No Answer"]
    
    fileprivate var timerCount = 30
    fileprivate var countdownTimer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.resultsTableView.delegate = self
        self.resultsTableView.dataSource = self
        self.resultsTableView.estimatedRowHeight = 100
        self.resultsTableView.rowHeight = UITableViewAutomaticDimension
        
        self.countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
        self.timerButton.title = ""
        
        self.maxScoreLabel.text = "Max Score: \(self.question!.value!) pts"
        
        // populating the gameRoom Object
        FirebaseClient.instance.getGameBy(roomId: roomId!, complete: { (snapshot) in
            if let data = snapshot.value as? NSDictionary {
                self.gameRoom = GameRoom(dictionary: data[data.allKeys.first as! String] as! NSDictionary)
                
                self.resultsTitleLabel.text = "Results: Round \(self.gameRoom!.current_question!) of \(self.gameRoom!.max_num_of_questions)"
                
                if (self.gameRoom?.current_question == self.gameRoom?.max_num_of_questions) {
                    self.nextQuestionButton.isHidden = true
                }
            }
        }) { (error) in
        }
        
        // get the scored answers and populate it into the results view table
        FirebaseClient.instance.getScoredAnswersBy(roomId: roomId!, questionId: (question?.id)!, complete: { (scoredAnswersData) in
            let orderedScoredAnswersData = scoredAnswersData.sorted { self.sortScoredAnswersByScore(value0: $0 as! NSDictionary, value1: $1 as! NSDictionary) }
            for scoredAnswerData in (orderedScoredAnswersData as NSArray) {
                let scoredAnswer = ScoredAnswer(dictionary: scoredAnswerData as! NSDictionary)
                self.appendResult(scoredAnswer: scoredAnswer)
                Logger.instance.log(logLevel: .debug, message: "Appended \(scoredAnswer.getJson())")
            }
            
            self.resultsTableView.reloadData()
        }, onError: { (error) in
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // update user_in_game to remove player from user_in_game
    @IBAction func onQuitFromResults(_ sender: UIBarButtonItem) {
        countdownTimer.invalidate()
        Utilities.quitGame(controller: self)
    }
    
    @objc fileprivate func updateCounter() {
        timerCount -=  1
        timerButton.title = ""
        
        if (timerCount > 0) {
            timerButton.title = "\(timerCount)s"
        }
        else {
            countdownTimer.invalidate()
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let destinationIdentifier: String
            let destination: UIViewController
            if (self.gameRoom?.current_question == self.gameRoom?.max_num_of_questions) {
                destinationIdentifier = Constants.FINAL_SCORE_NAVIGATION_VIEW_CONTROLLER
                destination = storyboard.instantiateViewController(withIdentifier: destinationIdentifier)
                let finalScoreNavigationController = destination as! UINavigationController
                let finalScoreViewController = finalScoreNavigationController.topViewController as! FinalScoreViewController
                finalScoreViewController.roomId = self.roomId
            }
            else {
                destinationIdentifier = Constants.QUESTION_NAVIGATION_VIEW_CONTROLLER
                destination = storyboard.instantiateViewController(withIdentifier: destinationIdentifier)
                let questionNavigationController = destination as! UINavigationController
                let questionViewController = questionNavigationController.topViewController as! QuestionViewController
                questionViewController.roomId = self.roomId
            }
            
            self.present(destination, animated: true, completion: nil)
        }
    }
    
    fileprivate func sortScoredAnswersByScore(value0: NSDictionary, value1: NSDictionary) -> Bool {
        return (value0["score"] as! Int) > (value1["score"] as! Int)
    }
    
    fileprivate func appendResult(scoredAnswer: ScoredAnswer) {
        if (scoredAnswer.score > 0) {
            self.results?[self.CORRECT_ANSWERS].append(scoredAnswer)
        }
        else if (scoredAnswer.answerText == "") {
            self.results?[self.NO_ANSWERS].append(scoredAnswer)
        }
        else {
            self.results?[self.WRONG_ANSWERS].append(scoredAnswer)
        }
    }
}

extension ResultsViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results![section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.RESULT_TABLE_VIEW_CELL, for: indexPath) as! ResultTableViewCell
        cell.scoredAnswer = (results?[indexPath.section][indexPath.row])! as ScoredAnswer
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return (results?.count)!
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return resultsHeaders[section]
    }
}
