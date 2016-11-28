//
//  CreateGameViewController.swift
//  ios-trivia-game
//
//  Created by Savio Tsui on 11/15/16.
//  Copyright © 2016 Team NZS. All rights reserved.
//

import UIKit

class CreateGameViewController: UIViewController {

    @IBOutlet weak var numberOfPlayersPicker: UIPickerView!
    
    @IBOutlet weak var isPublicSwitch: UISwitch!
    @IBOutlet weak var nameOfGameroomTextField: UITextField!
    
    
    var numOfPlayersPickerData: [String] = [String]()
    // Pass these data to SelectFriendsViewController
    var numOfPlayers: Int?
    var isPublic: Bool?
    var nameOfGameroom: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupPickerData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupPickerData() {
        self.numberOfPlayersPicker.delegate = self
        self.numberOfPlayersPicker.dataSource = self
        self.numOfPlayersPickerData = ["1", "2", "3", "4", "5"]
    }
    
    func setupSwitch() {
        self.isPublicSwitch.addTarget(self, action: #selector(CreateGameViewController.switchIsChanged(_:)), for: UIControlEvents.valueChanged)
    }
    
    func switchIsChanged(_: UISwitch) {
        isPublic = self.isPublicSwitch.isOn
    }
    
    @IBAction func selectFriendsClicked(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let selectFriendsViewController = storyboard.instantiateViewController(withIdentifier: Constants.SELECT_FRIENDS_VIEW_CONTROLLER) as! SelectFriendsViewController
        selectFriendsViewController.numOfPlayers = self.numOfPlayers
        selectFriendsViewController.isPublic = self.isPublic
        selectFriendsViewController.nameOfGameroom = self.nameOfGameroom
        self.navigationController?.pushViewController(selectFriendsViewController, animated: true)
    }
    
    @IBAction func onGameNameChanged(_ sender: Any) {
        self.nameOfGameroom = nameOfGameroomTextField.text
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

extension CreateGameViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    // The number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return numOfPlayersPickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        numOfPlayers = row + 1
        return numOfPlayersPickerData[row]
    }
}


