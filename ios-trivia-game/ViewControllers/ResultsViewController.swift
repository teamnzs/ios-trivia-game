//
//  ResultsViewController.swift
//  ios-trivia-game
//
//  Created by Savio Tsui on 11/15/16.
//  Copyright © 2016 Team NZS. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController {

    @IBOutlet weak var timerButton: UIBarButtonItem!
    @IBOutlet weak var resultsTitleLabel: UILabel!
    @IBOutlet weak var resultsTableView: UITableView!
    @IBOutlet weak var nextQuestionButton: UIButton!
    
    var roomId: String?
    var question: TriviaQuestion?
    var gameRoom: GameRoom?
    var results: [Answer]?
    
    fileprivate var timerCount = 60
    fileprivate var countdownTimer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        Logger.instance.log(logLevel: .debug, message: "Entered ResultsViewController")
        
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
        timerButton.title = ""
        
        FirebaseClient.instance.getGameBy(roomId: roomId!, complete: { (snapshot) in
            let data = snapshot.value as? NSDictionary
            
            if ((data?.count)! > 0) {
                self.gameRoom = GameRoom(dictionary: data?[data?.allKeys.first as! String] as! NSDictionary)
            }
            
        }) { (error) in
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
     */
    
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
            // performSegue(withIdentifier: Constants.ANSWER_TO_RESULTS_SEGUE, sender: nil)
        }
    }


    @IBAction func onQuitFromResults(_ sender: UIBarButtonItem) {
        // update user_in_game to remove player from user_in_game
        Utilities.quitGame(controller: self)
    }
}
