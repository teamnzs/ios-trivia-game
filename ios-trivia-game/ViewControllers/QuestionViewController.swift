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
    var question: TriviaQuestion?
    
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        submitButton.backgroundColor = UIColor(hexString: Constants.TRIVIA_RED)
        submitButton.tintColor = UIColor.white
        
        // @Nari or @Zhia: Feel free to remove the hardcoded values when you get to this
        let questionId = 1944
        FirebaseClient.instance.getQuestionBy(questionId: questionId, complete: { (snapshot) in
            if let questionArray = snapshot.value as? NSArray {
                for questionData in questionArray {
                    if let questionDict = questionData as? NSDictionary {
                        self.question = TriviaQuestion(dictionary: questionDict)
                        break
                    }
                }
            }
            else if let questionDict = snapshot.value as? NSDictionary {
                self.question = TriviaQuestion(dictionary: questionDict[questionDict.allKeys.first!] as! NSDictionary)

            }
        }, onError: { (error) in
            Logger.instance.log(logLevel: .error, message: "Could not find question id = \(questionId)")
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
            destination.roomId = roomId
        }
    }

    @IBAction func onAnswerSubmit(_ sender: UIButton) {
        // Temporary to demonstrate AnswerViewController
        // @Nari or @Zhia: Feel free to remove the hardcoded values when you get to this
    }
}
