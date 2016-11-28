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
    
    fileprivate var timerCount = 30
    fileprivate var countdownTimer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc fileprivate func updateCounter() {
        timerCount -=  1
        countdownLabel.text = ""
        
        
        if (timerCount > 0) {
            countdownLabel.text = "\(timerCount)sec"
        }
        else {
            countdownTimer.invalidate()
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let destinationIdentifier = Constants.MAIN_TAB_VIEW_CONTROLLER
            
            let destination = storyboard.instantiateViewController(withIdentifier: destinationIdentifier)
            self.present(destination, animated: true, completion: nil)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
