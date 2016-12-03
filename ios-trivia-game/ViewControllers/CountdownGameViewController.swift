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

        // Do any additional setup after loading the view.
        self.countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
        
        FirebaseClient.instance.updatePlayerCount(roomId: roomId!, change: 1)
        
        clickToJoin.tintColor = UIColor(hexString: Constants.TRIVIA_RED)
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
            Utilities.quitGame(controller: self)
        }
    }
    
    @IBAction func onCancelJoin(_ sender: UIButton) {
        self.countdownTimer.invalidate()
        
        FirebaseClient.instance.updatePlayerCount(roomId: roomId!, change: -1)
        Utilities.quitGame(controller: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nav = segue.destination as? UINavigationController
        
        if let questionViewController = nav?.topViewController as? QuestionViewController {
            questionViewController.roomId = self.roomId
        }
    }
}
