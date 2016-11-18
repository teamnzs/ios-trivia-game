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

/**
 * Makes one GET request to fetch all rooms.
 * Has two properties as rooms, one room contains the rooms to show to user.
 * The other has all the rooms available.
 *
 * If we change the table structure, we need to 
 * update loadAllGameRooms
 */

class HomeViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    let refreshControl = UIRefreshControl()
    let ROOMS_TO_SHOW = 20
    
    var gameRooms: [GameRoom]? = []
    var roomsToShow : [GameRoom]? = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupTableview()
        
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        loadNewRooms()
    }
    
    func setupTableview() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logoutTapped(_ sender: UIBarButtonItem) {
        User.currentUser?.logout()
    }
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        loadNewRooms()
        refreshControl.endRefreshing()
    }
    
    func loadNewRooms() {
        loadGameRooms(refresh: true)
    }
    
    func loadGameRooms(refresh:Bool = false) {
        self.gameRooms = []
        let ref = FIRDatabase.database().reference()
        ref.child(Constants.GAME_ROOM_TABLE_NAME).observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value as? NSArray
            
            for room in value! {
                let gameRoom = GameRoom(dictionary: room as! NSDictionary)
                if gameRoom.state != GameRoom.State.end {
                    self.gameRooms?.append(gameRoom)
                }
                Logger.instance.log(logLevel: .info, message: "\(gameRoom.getJson())")
            }
            
            self.getMoreRooms(refresh:refresh)
        }) { (error) in
            Logger.instance.log(logLevel: .error, message: error.localizedDescription)
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.roomsToShow!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "com.iostriviagame.hometableviewcell", for: indexPath) as! HomeTableViewCell
        cell.gameRoomInfo = self.roomsToShow?[indexPath.row]
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
            getMoreRooms()
        }
    }
    
    func getMoreRooms(refresh:Bool = false) {
        if (refresh) {
            self.roomsToShow = []
        }
        
        let roomsSoFar = self.roomsToShow?.count ?? 0
        let allRooms = self.gameRooms?.count ?? 0
        if (roomsSoFar >= allRooms) {
            return
        }
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let roomsToGet = roomsSoFar + ROOMS_TO_SHOW
        let end = roomsToGet < allRooms ? roomsToGet : allRooms - 1
        let slice:[GameRoom] = Array(self.gameRooms![0...end])
        self.roomsToShow = slice
        
        MBProgressHUD.hide(for: self.view, animated: true)
        self.tableView.reloadData()
    }
}
