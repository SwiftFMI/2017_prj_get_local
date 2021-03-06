//
//  ProfileViewController.swift
//  getLocal
//
//  Created by Emil Iliev on 2/20/18.
//  Copyright © 2018 Petar Ivanov. All rights reserved.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {

    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        user = Auth.auth().currentUser
        activityIndicator.startAnimating()
        self.title = "Profile"
        usernameLabel.text = user?.displayName ?? ""
        emailLabel.text = user?.email ?? ""
        downloadAvatar()
        
        userAvatar.layer.cornerRadius = 100
        userAvatar.layer.masksToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func downloadAvatar() {
        guard let user = user, let photoURL = user.photoURL else { return }
        
        userAvatar.imageFromServerURL(url: photoURL) { [weak self] in
            guard let `self` = self else { return }
            
            self.activityIndicator.stopAnimating()
        }
    }
}

