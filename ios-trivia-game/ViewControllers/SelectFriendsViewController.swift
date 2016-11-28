//
//  SelectFriendsViewController.swift
//  ios-trivia-game
//
//  Created by Savio Tsui on 11/15/16.
//  Copyright © 2016 Team NZS. All rights reserved.
//

import UIKit
import FacebookCore
import FBSDKLoginKit

class SelectFriendsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var seletedFriendsLabel: UILabel!
    
    var numOfPlayers: Int?
    var isPublic: Bool?
    var nameOfGameroom: String?
    
    var friends = [Friend]()
    var currentSelectedCount:Int = 1
    var isFromUserEvent:Bool = true
    var selectedFriends = Set<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupTableView()
        loadFriendsList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onBackClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func loadFriendsList() {
        let params = ["fields": "id, first_name, last_name, middle_name, name, email, picture"]
        let request = FBSDKGraphRequest(graphPath: "me/taggable_friends", parameters: params)
        request?.start(completionHandler: { (_, result: Any?, error: Error?) in
            if error != nil {
                let errorMessage = error?.localizedDescription
                print("error: \(errorMessage)")
            }
            let data = result as! NSDictionary
            let dictionaries = data["data"] as! [NSDictionary]
            self.friends = Friend.FriendsWithArray(dictionaries: dictionaries)
            self.tableView.reloadData()
        })
    }

    @IBAction func onGameOptionsClicked(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let gameOptionsViewController = storyboard.instantiateViewController(withIdentifier: Constants.GAME_OPTIONS_VIEW_CONTROLLER) as! GameOptionsViewController
        gameOptionsViewController.numOfPlayers = self.numOfPlayers
        gameOptionsViewController.isPublic = self.isPublic
        gameOptionsViewController.nameOfGameroom = self.nameOfGameroom
        gameOptionsViewController.selectedFriends = self.selectedFriends
        self.navigationController?.pushViewController(gameOptionsViewController, animated: true)
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

extension SelectFriendsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "com.iostriviagame.selecfriendstableviewcell", for: indexPath) as! SelectFriendsTableViewCell
        cell.friend = self.friends[indexPath.row]
        cell.onSwitch.isOn = self.friends[indexPath.row].isSelected ?? false
        cell.delegate = self
        return cell
    }
}

extension SelectFriendsViewController: SelectFriendsTableViewCellDelegate {
    
    func selectFriendsTableViewCell(selectFriendsTableViewCell: SelectFriendsTableViewCell, didChangeValue value: Bool) {
        let indexPath = tableView.indexPath(for: selectFriendsTableViewCell)!
        
        if value && currentSelectedCount >= numOfPlayers! {
            let alertController = UIAlertController(title: "Warning", message:
                "You can invite maximum \(numOfPlayers!-1) people", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
            
            if isFromUserEvent {
                selectFriendsTableViewCell.onSwitch.isOn = false
                isFromUserEvent = false
            }
        } else {
        
            if isFromUserEvent {
                self.friends[indexPath.row].isSelected = value
                if value {
                    currentSelectedCount += 1
                    selectedFriends.insert(selectFriendsTableViewCell.friend.id!)
                } else {
                    currentSelectedCount -= 1
                    selectedFriends.remove(selectFriendsTableViewCell.friend.id!)
                }
        
                updateSelectedFriendsLabel(isSelected: value, name: friends[indexPath.row].name!)
            } else {
                isFromUserEvent = true
            }
        }
    }
    
    func updateSelectedFriendsLabel(isSelected: Bool, name: String) {
        
        if isSelected {
            self.seletedFriendsLabel.text = seletedFriendsLabel.text! + " \(name)"
        }
        
        // TODO: Should handle the removing case.
    }
}
