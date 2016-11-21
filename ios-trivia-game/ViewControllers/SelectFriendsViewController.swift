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
    var friends = [Friend]()
    var selectedFriends = [Bool]()
    
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
            print("result : \(result)")
            let data = result as! NSDictionary
            let dictionaries = data["data"] as! [NSDictionary]
            self.friends = Friend.FriendsWithArray(dictionaries: dictionaries)
            for friend in self.friends {
                print("url : \(friend.pictureUrl)")
            }
            self.tableView.reloadData()
        })
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
        cell.delegate = self
        return cell
    }
}

extension SelectFriendsViewController: SelectFriendsTableViewCellDelegate {
    
    func selectFriendsTableViewCell(selectFriendsTableViewCell: SelectFriendsTableViewCell, didChangeValue value: Bool) {
        let indexPath = tableView.indexPath(for: selectFriendsTableViewCell)!
        self.friends[indexPath.row].isSelected = value
        
        updateSelectedFriendsLabel(isSelected: value, name: friends[indexPath.row].name!)
    }
    
    func updateSelectedFriendsLabel(isSelected: Bool, name: String) {
        
        if isSelected {
            self.seletedFriendsLabel.text = seletedFriendsLabel.text! + " \(name)"
        }
        
        // TODO: Should handle the removing case.
    }
}
