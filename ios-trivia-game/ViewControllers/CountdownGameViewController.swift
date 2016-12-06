//
//  CountdownGameViewController.swift
//  ios-trivia-game
//
//  Created by Savio Tsui on 11/15/16.
//  Copyright © 2016 Team NZS. All rights reserved.
//

import UIKit

class CountdownGameViewController: UIViewController {

    @IBOutlet weak var countdownLabel: UILabel!
    @IBOutlet weak var clickToJoin: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var roomId: String?
    var timerCount: Int? = Constants.GAME_START_COUNTDOWN
    
    fileprivate var countdownTimer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FirebaseClient.instance.updatePlayerCount(roomId: self.roomId!, change: 1)
        self.countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateCounter), userInfo: nil, repeats: true)
        
        clickToJoin.backgroundColor = UIColor(hexString: Constants.TRIVIA_RED)
        clickToJoin.tintColor = UIColor.white
        cancelButton.tintColor = UIColor(hexString: Constants.TRIVIA_RED)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc fileprivate func updateCounter() {
        timerCount! -=  1
        countdownLabel.text = ""

        if (timerCount! > 0) {
            countdownLabel.text = "\(timerCount!)sec"
        }
        else {
            self.countdownTimer.invalidate()
            
            if (self.clickToJoin.isEnabled) {
                Utilities.quitGame(controller: self, roomId: roomId!, hasJoined: true)
            } else {
                // means has already clicked JOIN
                performSegue(withIdentifier: Constants.COUNTDOWN_TO_QUESTION_SEGUE, sender: nil)
            }
        }
    }
    
    @IBAction func joinButtonTapped(_ sender: UIButton) {
        sender.isEnabled = false
        self.cancelButton.isEnabled = false
        self.clickToJoin.setTitle("Ready", for: .normal)
        
        FirebaseClient.instance.updateUserInGameState(state: 1, roomId: self.roomId!, complete: {(error, ref) in
            if (error == nil) {
                print("Successfully updated user in game state to active")
            }
        })
    }
    
    @IBAction func onCancelJoin(_ sender: UIButton) {
        self.countdownTimer.invalidate()
        
        Utilities.quitGame(controller: self, roomId: roomId!, hasJoined: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nav = segue.destination as? UINavigationController
        print ("My room ID in countdown: \(self.roomId)")
        if let questionViewController = nav?.topViewController as? QuestionViewController {
            questionViewController.roomId = self.roomId
        }
    }
}
