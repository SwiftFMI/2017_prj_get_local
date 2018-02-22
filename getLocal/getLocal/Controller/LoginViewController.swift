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
	
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        autologin()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func unwindToLogin(segue: UIStoryboardSegue){}
    

    private func autologin() {
        Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
            guard let `self` = self ,let user = user else { return }
            
            guard let mainTab = self.storyboard?.instantiateViewController(withIdentifier: StoryboardIDS.mainVC.rawValue) as? MainTabBarController
                else { fatalError("\(StoryboardIDS.mainVC) doesn't exist!") }
                
            self.present(mainTab, animated: true)
        }
    }
    
    @IBAction func handleLogin () {
        let loginManager = FBSDKLoginManager()
        loginManager.logIn(withReadPermissions: ["public_profile", "email"], from: self) { [weak self] (fbResponse, fbError) in
            guard let `self` = self ,let result = fbResponse else{ return }
            if result.isCancelled { //if user taps DONE
                return
            }
            
            if let current = FBSDKAccessToken.current() {
                let token = current.tokenString
                let credential = FacebookAuthProvider.credential(withAccessToken: token!)
                Auth.auth().signIn(with: credential) { (user, error) in
                    if let error = error {
                        self.removeAllOverlays()
                        print("Error:\(error.localizedDescription)")
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
    }
    
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

