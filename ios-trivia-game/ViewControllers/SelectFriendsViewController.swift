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
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var seletedFriendsLabel: UILabel!
    
    var numOfPlayers: Int?
    var isPublic: Bool?
    var nameOfGameroom: String?
    
    var friends = [Friend]()
    var filteredFriendsList = [Friend]()
    var currentSelectedCount:Int = 1
    var isFromUserEvent:Bool = true
    var selectedFriends = Set<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupSearchBar()
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
    
    func setupSearchBar() {
        searchBar.delegate = self
        searchBar.sizeToFit()
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
        _ = request?.start(completionHandler: { (_, result: Any?, error: Error?) in
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
    
    func updateListWithKeyword(keyword: String) {
        filteredFriendsList.removeAll()
        for friend in friends {
            if (friend.name?.lowercased().range(of: keyword.lowercased())) != nil {
                filteredFriendsList.append(friend)
            }
        }
        tableView.reloadData()
    }
}

extension SelectFriendsViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchBar.text != nil) {
            updateListWithKeyword(keyword: searchBar.text!)
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false;
        searchBar.text = ""
        searchBar.resignFirstResponder()
        tableView.reloadData()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text != nil {
            updateListWithKeyword(keyword: searchBar.text!)
        }
        searchBar.endEditing(true)
    }
}

extension SelectFriendsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.searchBar.text != nil && (self.searchBar.text?.characters.count)! > 0 {
            return self.filteredFriendsList.count
        } else {
            return self.friends.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "com.iostriviagame.selecfriendstableviewcell", for: indexPath) as! SelectFriendsTableViewCell
        if self.searchBar.text != nil && (self.searchBar.text?.characters.count)! > 0 {
            cell.friend = self.filteredFriendsList[indexPath.row]
            cell.onSwitch.isOn = self.filteredFriendsList[indexPath.row].isSelected ?? false
        } else {
            cell.friend = self.friends[indexPath.row]
            cell.onSwitch.isOn = self.friends[indexPath.row].isSelected ?? false
        }
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
                if self.searchBar.text != nil && (self.searchBar.text?.characters.count)! > 0 {
                    self.filteredFriendsList[indexPath.row].isSelected = value
                } else {
                    self.friends[indexPath.row].isSelected = value
                }
                if value {
                    currentSelectedCount += 1
                    selectedFriends.insert(selectFriendsTableViewCell.friend.id!)
                } else {
                    currentSelectedCount -= 1
                    selectedFriends.remove(selectFriendsTableViewCell.friend.id!)
                }
        
                if self.searchBar.text != nil && (self.searchBar.text?.characters.count)! > 0 {
                    updateSelectedFriendsLabel(isSelected: value, name: filteredFriendsList[indexPath.row].name!)
                } else {
                    updateSelectedFriendsLabel(isSelected: value, name: friends[indexPath.row].name!)
                }
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
