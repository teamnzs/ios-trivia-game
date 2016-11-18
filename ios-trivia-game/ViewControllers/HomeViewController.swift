//
//  HomeViewController.swift
//  ios-trivia-game
//
//  Created by Savio Tsui on 11/15/16.
//  Copyright © 2016 Team NZS. All rights reserved.
//

import UIKit
import FirebaseDatabase
import MBProgressHUD

class HomeViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    let refreshControl = UIRefreshControl()
    
    var gameRooms: [GameRoom]? = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        
        tableView.insertSubview(refreshControl, at: 0)
        
        //loadMoreGameRooms()
        
        let ref = FIRDatabase.database().reference()
        ref.child("questions").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            
            let value = snapshot.value as? NSArray
            print(value)
        }) { (error) in
            Logger.instance.log(logLevel: .error, message: error.localizedDescription)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logoutTapped(_ sender: UIBarButtonItem) {
        User.currentUser?.logout()
    }
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
    }
    
    func loadMoreGameRooms() {
        MBProgressHUD.showAdded(to: self.tableView, animated: true)
        let ref = FIRDatabase.database().reference()
        ref.child(Constants.GAME_ROOM_TABLE_NAME).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            
            let value = snapshot.value as? NSArray
            for room in value! {
                let gameRoom = GameRoom(dictionary: room as! NSDictionary)
                if gameRoom.state != GameRoom.State.end {
                    self.gameRooms?.append(gameRoom)
                }
                Logger.instance.log(logLevel: .info, message: "\(gameRoom.getJson())")

            }
            
            self.tableView.reloadData()
            MBProgressHUD.hide(for: self.tableView, animated: true)
        }) { (error) in
            Logger.instance.log(logLevel: .error, message: error.localizedDescription)
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

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.gameRooms!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "com.iostriviagame.hometableviewcell", for: indexPath) as! HomeTableViewCell
        cell.gameRoomInfo = self.gameRooms?[indexPath.row]
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // prepare for segue
        print ("Selected \(indexPath.row)")
        print ("Segue should happen here, perhaps ask the user if he really wants to join?")
    }
}

extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Calculate the position of one screen length before the bottom of the results
        let scrollViewContentHeight = tableView.contentSize.height
        let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
        
        // When the user has scrolled past the threshold, start requesting
        if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
            
            // Code to load more results
            //loadMoreGameRooms()
        }
    }
}
