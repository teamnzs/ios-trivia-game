//
//  ResultsViewController.swift
//  ios-trivia-game
//
//  Created by Savio Tsui on 11/15/16.
//  Copyright © 2016 Team NZS. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        Logger.instance.log(logLevel: .debug, message: "Entered ResultsViewController")
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

    @IBAction func onQuitFromResults(_ sender: UIBarButtonItem) {
        // update user_in_game to remove player from user_in_game
        
        FirebaseClient.instance.quitGame(complete: {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let destination = storyboard.instantiateViewController(withIdentifier: "com.iostriviagame.maintabviewcontroller") as! MainTabViewController
            destination.selectedIndex = 0
            destination.navigationController?.isNavigationBarHidden = true
            self.present(destination, animated: true, completion: nil)
        }, onError: { (error) in })
    }
}
