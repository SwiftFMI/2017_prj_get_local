//
//  LogoutViewController.swift
//  getLocal
//
//  Created by Emil Iliev on 2/20/18.
//  Copyright © 2018 Petar Ivanov. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit

class LogoutViewController: UIViewController {

    @IBOutlet weak var logoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        logoutButton.setTitle("Hello".localized, for: .normal)
//        Language.shared.currentLanguage
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func handleLogout(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        FBSDKLoginManager().logOut()
    
        performSegue(withIdentifier: "\(SegueIDs.unwindToLogin)", sender: nil)
    }
}
