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
    
    fileprivate var timerCount = 60
    fileprivate var countdownTimer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onFinish(_ sender: UIButton) {
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
            Utilities.quitGame(controller: self)
        }
    }
}
