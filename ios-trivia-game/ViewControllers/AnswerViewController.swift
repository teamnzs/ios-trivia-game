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
    
    var question: TriviaQuestion?
    var roomId: String?
    
    fileprivate var answers: [Answer]? = []
    fileprivate var timerCount = 60
    fileprivate var countdownTimer = Timer()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionLabel.text = question?.question
        
        answerTableView.delegate = self
        answerTableView.dataSource = self
        answerTableView.estimatedRowHeight = 100
        answerTableView.rowHeight = UITableViewAutomaticDimension
        
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
        timerButton.title = ""
        
        FirebaseClient.instance.getAnswersBy(roomId: roomId!, questionId: (question?.id)!, complete: { (answers) in
            for answerDict in answers {
                let answer = Answer(dictionary: answerDict as! NSDictionary)
                self.answers?.append(answer)
                
                Logger.instance.log(logLevel: .info, message: "Adding \(answer.getJson())")
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
    
    @IBAction func onQuitFromAnswer(_ sender: UIBarButtonItem) {
        // update user_in_game to remove player from user_in_game

        FirebaseClient.instance.quitGame(complete: {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let destination = storyboard.instantiateViewController(withIdentifier: Constants.MAIN_TAB_VIEW_CONTROLLER) as! MainTabViewController
            destination.selectedIndex = 0
            destination.navigationController?.isNavigationBarHidden = true
            self.present(destination, animated: true, completion: nil)
        }, onError: { (error) in })
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
    
    @IBAction func onSubmit(_ sender: UIButton) {
        countdownTimer.invalidate()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nav = segue.destination as? UINavigationController
        
        if (nav?.topViewController is ResultsViewController) {
            var answer : Answer!
            if (answerTableView.indexPathForSelectedRow == nil) {
                answer = Answer(userId: (User.currentUser?.uid)!, answerText: "", questionId: (question?.id)!, roomId: roomId!)
            }
            else {
                let selectedAnswer = answers?[(answerTableView.indexPathForSelectedRow?.row)!]
                answer = Answer(userId: (User.currentUser?.uid)!, answerText: (selectedAnswer?.answerText)!, questionId: (question?.id)!, roomId: roomId!)
            }
            FirebaseClient.instance.postAnswer(answer: answer!, complete: {(error, ref) in
                if (error != nil) {
                    Logger.instance.log(logLevel: .error, message: "Error posting Answer: \(answer)")
                }
                else {
                    Logger.instance.log(logLevel: .info, message: "Success posting Answer: \(answer)")
                }
            })
        }
    }
}

extension AnswerViewController: UITableViewDelegate {
}

extension AnswerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.answers!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.ANSWER_TABLE_VIEW_CELL, for: indexPath) as! AnswerTableViewCell
        cell.answer = self.answers?[indexPath.row]
        return cell
    }
}
