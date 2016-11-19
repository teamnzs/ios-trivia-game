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

    @IBOutlet weak var contentViewCenterY: NSLayoutConstraint!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    fileprivate var user: User!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // self.contentViewCenterY.constant += self.view.bounds.height
        self.contentView.center.x += self.contentView.frame.width
        self.contentView.layoutIfNeeded()
        self.profileImageView.alpha = 0.0
        
        UIView.animate(withDuration: 0.6, animations: {
            // self.contentViewCenterY.constant -= self.view.bounds.height
            
            self.contentView.center.x -= self.contentView.frame.width
            self.profileImageView.alpha = 1
            self.contentView.layoutIfNeeded()
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.user = User.currentUser
        
        self.profileImageView.clipsToBounds = true
        self.profileImageView.setImageWith(URL(string: self.user.photoUrl!)!)
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2;
        
        self.nicknameLabel.text = "somenickname"
        self.nameLabel.text = self.user.name!
        self.emailLabel.text = self.user.email!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension UIImage {
    
    func circularImage(size: CGSize?) -> UIImage {
        let newSize = size ?? self.size
        
        let minEdge = min(newSize.height, newSize.width)
        let size = CGSize(width: minEdge, height: minEdge)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()
        
        self.draw(in: CGRect(origin: CGPoint.zero, size: size), blendMode: .copy, alpha: 1.0)
        
        context!.setBlendMode(.copy)
        context!.setFillColor(UIColor.clear.cgColor)
        
        let rectPath = UIBezierPath(rect: CGRect(origin: CGPoint.zero, size: size))
        let circlePath = UIBezierPath(ovalIn: CGRect(origin: CGPoint.zero, size: size))
        rectPath.append(circlePath)
        rectPath.usesEvenOddFillRule = true
        rectPath.fill()
        
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return result!
    }
    
}
