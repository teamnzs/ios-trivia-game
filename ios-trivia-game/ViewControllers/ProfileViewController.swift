//
//  ProfileViewController.swift
//  ios-trivia-game
//
//  Created by Savio Tsui on 11/15/16.
//  Copyright © 2016 Team NZS. All rights reserved.
//

import UIKit
import AFNetworking

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileLabel: UILabel!
    @IBOutlet weak var contentViewCenterY: NSLayoutConstraint!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var editPhotoButton: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    
    fileprivate var user: User!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.profileLabel.center.x += self.view.bounds.width
        self.contentView.center.x += self.contentView.frame.width
        self.contentView.layoutIfNeeded()
        self.profileImageView.alpha = 0.0
        
        UIView.animate(withDuration: 0.8, animations: {
            self.contentView.center.x -= self.contentView.frame.width
            self.profileImageView.alpha = 1
            self.contentView.layoutIfNeeded()
        })
        
        UIView.animate(withDuration: 0.7, animations: {
            self.profileLabel.center.x -= self.view.bounds.width
            self.profileLabel.layoutIfNeeded()
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.user = User.currentUser
        
        self.profileImageView.clipsToBounds = true
        self.profileImageView.setImageWith(URL(string: self.user.photoUrl!)!)
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2;
        
        self.nameLabel.text = self.user.name!
        self.emailLabel.text = self.user.email!
        editPhotoButton.tintColor = UIColor(hexString: Constants.TRIVIA_RED)
        self.scoreLabel.text = "\(self.user.score!) points"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
