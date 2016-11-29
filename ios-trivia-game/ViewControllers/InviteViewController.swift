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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.inviteTableView.delegate = self
        self.inviteTableView.dataSource = self
        self.inviteTableView.estimatedRowHeight = 100
        self.inviteTableView.rowHeight = UITableViewAutomaticDimension

        FirebaseClient.instance.getInvitesFor(userId: (User.currentUser?.uid)!, complete: { (snapshot) in
            if let data = snapshot.value as? NSDictionary {
                
                for (_, value) in data {
                    let invite = Invite(dictionary: value as! NSDictionary)
                    self.invites.append(invite)
                }
                
                self.inviteTableView.reloadData()
            }
        }, onError: { (error) in })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
}
