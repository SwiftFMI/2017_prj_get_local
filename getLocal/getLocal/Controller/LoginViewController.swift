//
//  ViewController.swift
//  getLocal
//
//  Created by Petar Ivanov on 12/26/17.
//  Copyright © 2017 Petar Ivanov. All rights reserved.
//

import UIKit
import FirebaseAuth
import FacebookLogin
import FBSDKLoginKit
import SwiftOverlays

class LoginViewController: UIViewController {
	
    override func viewDidLoad() {
        super.viewDidLoad()
				//creating button
				let loginButton = FBSDKLoginButton()
				loginButton.delegate = self
				loginButton.center = view.center
			
				//adding it to view
				view.addSubview(loginButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
}

// MARK: - FBSDKLoginButtonDelegate
extension LoginViewController: FBSDKLoginButtonDelegate {
	
		func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
			self.showWaitOverlay()
			if let error = error {
				self.removeAllOverlays()
				print(error.localizedDescription)
				return
			}
			if let current = FBSDKAccessToken.current() {
				let token = current.tokenString
				let credential = FacebookAuthProvider.credential(withAccessToken: token!)
				Auth.auth().signIn(with: credential) { (user, error) in
					if let error = error {
						self.removeAllOverlays()
						print("Error: \(error.localizedDescription)")
						return
					}
					self.removeAllOverlays()
					print("User is signed in successfully")
					// User is signed in
					let mainVC = self.storyboard?.instantiateViewController(withIdentifier: StoryboardIDS.mainVC.rawValue)
					self.present(mainVC!, animated: true, completion: nil)
				}
			} else {
				self.removeAllOverlays()
			}
		}
	
		func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
			print("User sign out")
		}
	
}

