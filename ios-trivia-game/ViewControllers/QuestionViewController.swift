//
//  QuestionViewController.swift
//  ios-trivia-game
//
//  Created by Savio Tsui on 11/15/16.
//  Copyright © 2016 Team NZS. All rights reserved.
//

import UIKit

class QuestionViewController: UIViewController {

    var roomId: String?

    @IBOutlet weak var questionNumber: UILabel!
    @IBOutlet weak var questionTitle: UILabel!
    @IBOutlet weak var answerField: UITextField!
    @IBOutlet weak var timer: UIBarButtonItem!
    @IBOutlet weak var submitButton: UIButton!
    
    fileprivate var countdownTimer = Timer()
    fileprivate var timerCount = 60

    var question: TriviaQuestion?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        submitButton.backgroundColor = UIColor(hexString: Constants.TRIVIA_RED)
        submitButton.tintColor = UIColor.white

        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
        timer.title = ""

        submitButton.backgroundColor = UIColor(hexString: Constants.TRIVIA_RED)
        submitButton.tintColor = UIColor.white

        FirebaseClient.instance.getGameBy(roomId: roomId!, complete: {(snapshot) in
            let value = snapshot.value
            let gameRoom = GameRoom(dictionary: value as! NSDictionary)
            
            // get the current question
            let curQuestionIndex = gameRoom.current_question
            let questions = gameRoom.questions
            let maxQuestions = gameRoom.max_num_of_questions
            
            self.questionNumber.text = "Question \(curQuestionIndex! + 1)/\(maxQuestions)"
            
            
            if (curQuestionIndex! >= questions.count) {
                // prevent index-out-of-bound error
                return
            }
            
            let curQuestionId = questions[curQuestionIndex!]
            
            FirebaseClient.instance.getQuestionBy(questionId: curQuestionId, complete: { (snapshot) in
                if let questionDict = snapshot.value as? NSDictionary {
                    let question = questionDict.value(forKey: "\(curQuestionId)") as? NSDictionary
                    self.question = TriviaQuestion(dictionary: question!)
                }
                
                self.questionTitle.text = self.question?.question
                
            }, onError: { (error) in
                print ("Error ")
            })
            
        }, onError: {(error) in
            print("error \(error)")
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nav = segue.destination as? UINavigationController
        
        if (nav?.topViewController is AnswerViewController) {
            let destination = nav?.topViewController as! AnswerViewController
            destination.question = question
            destination.roomId = self.roomId

            
            print ("Preparing for segue: \(self.roomId)")
            // @Nari or @Zhia: Feel free to remove the hardcoded values when you get to this
            destination.roomId = (self.roomId)!
        }
    }

    @IBAction func onAnswerSubmit(_ sender: UIButton) {
        // Temporary to demonstrate AnswerViewController
        // @Nari or @Zhia: Feel free to remove the hardcoded values when you get to this
        let answerText = self.answerField.text
        
        if (answerText == "") {
            let alertController = Utilities.getAlertControllerWith(alertMessage: "Oops! You need to submit something!", title: "OK", completionHandler: { (action) in
                // do something after the user pressed OK?
            })
            self.present(alertController, animated: true, completion: nil)
        } else {
            sender.isEnabled = false
            sender.backgroundColor = UIColor.lightGray
            sender.setTitle("Submitted", for: .normal)
            
            submitAnswer()
        }
    }
    
    /** PRIVATE HELPER FUNCTIONS **/
    @objc fileprivate func submitAnswer() {
        self.answerField.isEnabled = false
        
        let answerText = self.answerField.text
        let roomId = self.roomId!
        let answer = Answer(userId: (User.currentUser?.uid)!, answerText: answerText!, questionId: (self.question?.id)!, roomId: roomId)
        
        FirebaseClient.instance.postAnswer(answer: answer, complete: { (error, ref) in
            if (error == nil) {
                Logger.instance.log(logLevel: .debug, message: "Succesfully stored the answer!")
            } else {
                Logger.instance.log(logLevel: .error, message: "Oops, couldn't store the answer \(error?.localizedDescription)")
            }
        })
    }
    
    @objc fileprivate func updateCounter() {
        timerCount -=  1
        
        timer.title = ""
        if (timerCount > 0) {
            // update UI
            self.timer.title = "\(self.timerCount)s"
        }
        else {
            // time is up. if button hasn't been pressed, then submit whatever's in the text field
            if (self.submitButton.isEnabled) {
                submitAnswer()
            }
                
            countdownTimer.invalidate()
        
            FirebaseClient.instance.incrementGameRoomCurQuestion(gameRoomId: self.roomId!, complete: { (snapshot) in
                Logger.instance.log(logLevel: .debug, message: "Updated current question number: \(snapshot.value)")
            }, onError: { (error) in
                Logger.instance.log(logLevel: .error, message: "Current question cannot be incremented: \(error?.localizedDescription)")
            })
            
            performSegue(withIdentifier: Constants.QUESTION_TO_ANSWER_SEGUE, sender: nil)
        }
    }
}
