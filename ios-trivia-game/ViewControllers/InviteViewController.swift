//
//  InviteViewController.swift
//  ios-trivia-game
//
//  Created by Savio Tsui on 11/28/16.
//  Copyright © 2016 Team NZS. All rights reserved.
//

import UIKit

class InviteViewController: UIViewController {

    @IBOutlet weak var invitesLabel: UILabel!
    @IBOutlet weak var inviteTableView: UITableView!
    
    fileprivate var invites: [Invite] = []
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshInvites), for: UIControlEvents.valueChanged)
        
        return refreshControl
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.invitesLabel.center.x += self.view.bounds.width
        self.inviteTableView.center.x += self.view.bounds.width
        self.inviteTableView.layoutIfNeeded()
        self.inviteTableView.alpha = 0.0
        
        UIView.animate(withDuration: 0.8, animations: {
            self.inviteTableView.center.x -= self.view.bounds.width
            self.inviteTableView.alpha = 1
            self.inviteTableView.layoutIfNeeded()
        })
        
        UIView.animate(withDuration: 0.7, animations: {
            self.invitesLabel.center.x -= self.view.bounds.width
            self.invitesLabel.layoutIfNeeded()
        })
        
        refreshInvites()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.inviteTableView.delegate = self
        self.inviteTableView.dataSource = self
        self.inviteTableView.estimatedRowHeight = 100
        self.inviteTableView.rowHeight = UITableViewAutomaticDimension
        
        self.inviteTableView.addSubview(self.refreshControl)
        refreshInvites()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc fileprivate func refreshInvites() {
        self.invites.removeAll()
        
        FirebaseClient.instance.getInvitesFor(userId: (User.currentUser?.uid)!, complete: { (snapshot) in
            if let data = snapshot.value as? NSDictionary {
                
                for (key, value) in data {
                    let invite = Invite(id: key as! String, dictionary: value as! NSDictionary)
                    
                    FirebaseClient.instance.getGameBy(roomId: invite.roomId!, complete: { (snapshot) in
                        if let data = snapshot.value as? NSDictionary {
                            if data.count > 0 {
                                let gameRoom = GameRoom(dictionary: data)
                                
                                // only display invites that are not expired
                                let timeIntervalSinceGameCreation = Date().timeIntervalSince(gameRoom.created_time)
                                if (timeIntervalSinceGameCreation > 0 && timeIntervalSinceGameCreation <= Double(Constants.GAME_START_COUNTDOWN)) {
                                    self.invites.append(invite)
                                    
                                    self.inviteTableView.reloadData()
                                }
                                else {
                                    // delete the invite since it's expired
                                    FirebaseClient.instance.removeInvite(inviteId: invite.roomId!, complete: {
                                    }, onError: { (_) in })
                                }
                            }
                        }
                    }, onError: { (_) in })
                }
            }
            
            self.refreshControl.endRefreshing()
        }, onError: { (error) in })
    }
}

extension InviteViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return invites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.INVITE_TABLE_VIEW_CELL, for: indexPath) as! InviteTableViewCell
        cell.invite = (invites[indexPath.row]) as Invite
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedInvite = invites[indexPath.row]
        
        // Access the image or the cell at this index path
        FirebaseClient.instance.joinGame(roomId: selectedInvite.roomId!, complete: { (remainingCountdownTime) in
            
            FirebaseClient.instance.removeInvite(inviteId: selectedInvite.id!, complete: { }, onError: { (_) in })
            
            // transition to countdown
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let destination = storyboard.instantiateViewController(withIdentifier: Constants.COUNTDOWN_NAVIGATION_VIEW_CONTROLLER)
            let countdownNavigationController = destination as! UINavigationController
            let countdownGameViewController = countdownNavigationController.topViewController as! CountdownGameViewController

            countdownGameViewController.roomId = selectedInvite.roomId!
            countdownGameViewController.timerCount = remainingCountdownTime
            
            self.present(destination, animated: true, completion: nil)
        }, fail: {
            // do not transition, throw up a popup
            let alertController = UIAlertController(title: "Warning", message:
                "Unable to join this game. Please try another.", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
        })
    }
}
