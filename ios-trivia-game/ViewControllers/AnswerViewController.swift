//
//  AnswerViewController.swift
//  ios-trivia-game
//
//  Created by Savio Tsui on 11/15/16.
//  Copyright © 2016 Team NZS. All rights reserved.
//

import UIKit

class AnswerViewController: UIViewController {
    
    @IBOutlet weak var timerButton: UIBarButtonItem!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerTableView: UITableView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var lastQuestionButton: UIButton!
    
    var question: TriviaQuestion?
    var roomId: String?
    
    fileprivate var answers: [Answer]? = []
    fileprivate let MAX_COUNTDOWN = 60
    fileprivate var timerCount = 60
    fileprivate var countdownTimer = Timer()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        submitButton.tintColor = UIColor(hexString: Constants.TRIVIA_RED)
        lastQuestionButton.tintColor = UIColor(hexString: Constants.TRIVIA_RED)
        questionLabel.text = question?.question
        
        answerTableView.delegate = self
        answerTableView.dataSource = self
        answerTableView.estimatedRowHeight = 100
        answerTableView.rowHeight = UITableViewAutomaticDimension
        
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
        timerButton.title = ""
        
        print ("Answer VC room ID: \(roomId)")
        
        FirebaseClient.instance.getAnswersBy(roomId: roomId!, questionId: (question?.id)!, complete: { (answers) in
            for answerDict in answers {
                let answer = Answer(dictionary: answerDict as! NSDictionary)
                self.answers?.append(answer)
                
                Logger.instance.log(logLevel: .info, message: "Adding \(answer.getJson())")
            }
            
            // add the correct answer
            let correctAnswer = self.question?.answer ?? ""
            if (correctAnswer != "") {
                let answer = Answer(userId: (User.currentUser?.firebaseId)!, answerText: correctAnswer, questionId: (self.question?.id)!, roomId: self.roomId!)
                let randomIndex = Int(arc4random_uniform(UInt32((self.answers?.count)! - 1)))
                print ("Random index \(randomIndex)")
                self.answers?.insert(answer, at: randomIndex)
            }
            
            self.answerTableView.reloadData()
            
        }, onError: { (error) in
            Logger.instance.log(logLevel: .error, message: "Could not find answers for roomId=\(self.roomId!), questionId=\((self.question?.id)!)")
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nav = segue.destination as? UINavigationController
        
        if let resultsViewController = nav?.topViewController as? ResultsViewController {
          
            if (self.submitButton.isEnabled) {
                print("Submit button is still enabled")
                submitAnswer()
            }
            
            resultsViewController.roomId = self.roomId
            resultsViewController.question = self.question
        }
        else if let finalScoreViewController = nav?.topViewController as? FinalScoreViewController {
            countdownTimer.invalidate()
            
            finalScoreViewController.roomId = self.roomId
        }
    }
    
    @IBAction func onQuitFromAnswer(_ sender: UIBarButtonItem) {
        // update user_in_game to remove player from user_in_game
        countdownTimer.invalidate()
        Utilities.quitGame(controller: self)
    }
    
    @IBAction func onSubmit(_ sender: UIButton) {
        sender.isEnabled = false
        self.answerTableView.isScrollEnabled = false
        self.answerTableView.allowsSelection = false
        sender.setTitle("Submitted", for: .normal)
        submitAnswer()
    }
    
    @objc fileprivate func submitAnswer() {
        let answerText = (answerTableView.indexPathForSelectedRow == nil) ? "" : answers?[(answerTableView.indexPathForSelectedRow?.row)!].answerText
        let answer = Answer(userId: (User.currentUser?.uid)!, answerText: answerText!, questionId: (question?.id!)!, roomId: roomId!)
        let score = calculateScore(answer: answer)
        let scoredAnswer = ScoredAnswer(score: score, answer: answer)
        
        FirebaseClient.instance.postScoredAnswer(scoredAnswer: scoredAnswer, complete: {(error, ref) in
            if (error == nil) {
                Logger.instance.log(logLevel: .info, message: "Success posting Scored Answer: \(scoredAnswer)")
            }
            else {
                Logger.instance.log(logLevel: .error, message: "Error posting Scored Answer: \(scoredAnswer)")
            }
        })
    }
    
    @objc fileprivate func updateCounter() {
        timerCount -=  1
        
        timerButton.title = ""
        if (timerCount > 0) {
            // update UI
            timerButton.title = "\(timerCount)s"
        }
        else {
            // time is up. execute submission code
            countdownTimer.invalidate()
            performSegue(withIdentifier: Constants.ANSWER_TO_RESULTS_SEGUE, sender: nil)
        }
    }
    
    fileprivate func calculateScore(answer: Answer) -> Int {
        if (question?.answer == answer.answerText) {
            return Int(Float(timerCount) / Float(MAX_COUNTDOWN) * Float((question?.value)!))
        }
        
        return 0
    }
}

extension AnswerViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.answers!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.ANSWER_TABLE_VIEW_CELL, for: indexPath) as! AnswerTableViewCell
        cell.answer = self.answers?[indexPath.row]
        return cell
    }
}
