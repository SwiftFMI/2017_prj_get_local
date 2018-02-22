//
//  ObjectDetailsViewController.swift
//  getLocal
//
//  Created by Emil Iliev on 1/14/18.
//  Copyright © 2018 Petar Ivanov. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

class ObjectDetailsViewController: UIViewController {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var objectImageView: UIImageView!
    @IBOutlet var workingTimeLabel: UILabel!
    @IBOutlet var descriptionText: UITextView!
    @IBOutlet var addToFavourites: UIButton!
    @IBOutlet var removeFromFavourites: UIButton!
    @IBOutlet var loader: UIActivityIndicatorView!
    
    var user: User!
    var userRef: DatabaseReference!
    var storageRef: StorageReference!
    var object: Object!
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = object.title
        workingTimeLabel.text = object.workTime
        descriptionText.text = object.description
        
        user = Auth.auth().currentUser
        
        userRef = Database.database().reference().child("users").child(user.uid)
        storageRef = Storage.storage().reference()
        storageRef.child(object.uid!).child(object.imageUrl!).getData(maxSize: 1024 * 1024) { data, error in
            if let error = error {
                print(error)
            } else {
                self.objectImageView.image = UIImage(data: data!)
                self.loader.stopAnimating()
            }
        }
        
        userRef.child("favourites").observe(.value, with: { (snapshot) in
            let isFavourite = (snapshot.children.allObjects as![DataSnapshot]).map({$0.key}).contains(where: {$0 == self.object.uid})
            self.favouritesButtonState(enabled: !isFavourite)
        })
        
    }
    
    private func favouritesButtonState(enabled: Bool) {
        if enabled {
            addToFavourites.isHidden = false
            removeFromFavourites.isHidden = true
        } else {
            addToFavourites.isHidden = true
            removeFromFavourites.isHidden = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func addToFavourites(_ sender: UIButton) {
        userRef.child("favourites").updateChildValues([AnyHashable(object.uid!) : true])
    }
    
    @IBAction func removeFromFavourites(_ sender: UIButton) {
        userRef.child("favourites").child(object.uid!).removeValue()
    }
    
		@IBAction func pressNavigateButton(_ sender: Any) {
				if (UIApplication.shared.canOpenURL(NSURL(string:"comgooglemaps://")! as URL)) {
                    	if let url = URL(string: "comgooglemaps://?saddr=&daddr=\(object.latitude!),\(object.longitude!)&directionsmode=driving") {
                            print(url)
							UIApplication.shared.open(url, options: [:], completionHandler: nil)
						}
				} else {
						print("Can't use comgooglemaps://")
						if let url = URL(string: "https://itunes.apple.com/us/app/google-maps-navigation-transit/id585027354?mt=8") {
								UIApplication.shared.open(url, options: [:], completionHandler: nil)
						}
				}
		}
}
