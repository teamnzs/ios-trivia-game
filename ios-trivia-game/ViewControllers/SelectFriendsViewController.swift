//
//  SelectFriendsViewController.swift
//  ios-trivia-game
//
//  Created by Savio Tsui on 11/15/16.
//  Copyright © 2016 Team NZS. All rights reserved.
//

import UIKit

class SelectFriendsViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var selectedFriendNamesLabel: UILabel!
    @IBOutlet weak var selectedFriendsLabel: UILabel!
    
    var numOfPlayers: Int?
    var isPublic: Bool?
    var nameOfGameroom: String?
    
    fileprivate let REGISTERED = 0
    fileprivate let UNREGISTERED = 1
    fileprivate let friendCategories = ["Registered", "Unregistered"]
    var friends: [[Friend]] = [[], []]
    var filteredFriendsList: [[Friend]] = [[], []]
    var currentSelectedCount:Int = 1
    var isFromUserEvent:Bool = true
    var selectedFriends: [String: String] = [:]
    
    internal let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.selectedFriendNamesLabel.textColor = UIColor(hexString: Constants.TRIVIA_RED)
        
        setupSearchBar()
        setupTableView()
        loadFriendsList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onBackClicked(_ sender: Any) {
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
        _ = FacebookClient.instance.getCurrentUserTaggableFriends(complete: { (_, result: Any?, error: Error?) in
            if error != nil {
                let errorMessage = error?.localizedDescription
                print("error: \(errorMessage)")
            }
            let data = result as! NSDictionary
            let dictionaries = data["data"] as! [NSDictionary]
            self.friends[self.UNREGISTERED] = Friend.FriendsWithArray(dictionaries: dictionaries)
            self.tableView.reloadData()
        })
        
        _ = FacebookClient.instance.getCurrentUserFriends(complete: { (_, result: Any?, error: Error?) in
            if error != nil {
                let errorMessage = error?.localizedDescription
                print("error: \(errorMessage)")
            }
            let data = result as! NSDictionary
            let dictionaries = data["data"] as! [NSDictionary]
            self.friends[self.REGISTERED] = Friend.FriendsWithArray(dictionaries: dictionaries)
            self.tableView.reloadData()
        })
    }

    @IBAction func onGameOptionsClicked(_ sender: Any) {
        let gameOptionsViewController = self.mainStoryboard.instantiateViewController(withIdentifier: Constants.GAME_OPTIONS_VIEW_CONTROLLER) as! GameOptionsViewController
        gameOptionsViewController.numOfPlayers = self.numOfPlayers
        gameOptionsViewController.isPublic = self.isPublic
        gameOptionsViewController.nameOfGameroom = self.nameOfGameroom
        gameOptionsViewController.selectedFriends = Array(self.selectedFriends.keys)
        self.navigationController?.pushViewController(gameOptionsViewController, animated: true)
    }
    
    func updateListWithKeyword(keyword: String) {
        var index = 0
        for friendList in friends {
            filteredFriendsList[index].removeAll()
            for friend in friendList {
                if (friend.name?.lowercased().range(of: keyword.lowercased())) != nil {
                    filteredFriendsList[index].append(friend)
                }
            }
            index = index + 1
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
            return self.filteredFriendsList[section].count
        } else {
            return self.friends[section].count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.SELECT_FRIENDS_TABLE_VIEW_CELL, for: indexPath) as! SelectFriendsTableViewCell
        if self.searchBar.text != nil && (self.searchBar.text?.characters.count)! > 0 {
            cell.friend = self.filteredFriendsList[indexPath.section][indexPath.row]
            cell.onSwitch.isOn = self.filteredFriendsList[indexPath.section][indexPath.row].isSelected ?? false
        } else {
            cell.friend = self.friends[indexPath.section][indexPath.row]
            cell.onSwitch.isOn = self.friends[indexPath.section][indexPath.row].isSelected ?? false
        }
        cell.delegate = self
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.friends.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return friendCategories[section]
    }
}

extension SelectFriendsViewController: SelectFriendsTableViewCellDelegate {
    
    func selectFriendsTableViewCell(selectFriendsTableViewCell: SelectFriendsTableViewCell, didChangeValue value: Bool) {
        let indexPath = tableView.indexPath(for: selectFriendsTableViewCell)!
        
        selectFriendsTableViewCell.selectionStyle = .none
        
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
                    self.filteredFriendsList[indexPath.section][indexPath.row].isSelected = value
                } else {
                    self.friends[indexPath.section][indexPath.row].isSelected = value
                }
                
                if value {
                    currentSelectedCount += 1
                    selectedFriends[selectFriendsTableViewCell.friend.id!] = selectFriendsTableViewCell.friend.name!
                } else {
                    currentSelectedCount -= 1
                    selectedFriends.removeValue(forKey: selectFriendsTableViewCell.friend.id!)
                }
                
                let names = Array(selectedFriends.values)
                self.selectedFriendNamesLabel.text = names.joined(separator: ", ")
            } else {
                isFromUserEvent = true
            }
        }
    }
}
