//
//  ObjectsMapViewController
//  getLocal
//
//  Created by Emil Iliev on 1/14/18.
//  Copyright © 2018 Petar Ivanov. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class ObjectsMapViewController: UIViewController {

		var user: User!
		var objects = [Object]()
		var ref: DatabaseReference!
		private var databaseHandle: DatabaseHandle!
	
		override func viewDidLoad() {
			super.viewDidLoad()
			user = Auth.auth().currentUser
			ref = Database.database().reference()
			
            
            print(user.photoURL)
			// MARK: - Reference for using Firebase Database: https://www.sitepoint.com/creating-a-firebase-backend-for-ios-app/
			// insert hardcoded objexcts to Firebase Database
			/*
			let dbRefId1 = self.ref.child("users").child(self.user.uid).child("objects").childByAutoId()
			dbRefId1.child("title").setValue("Sofia")
			dbRefId1.child("latitude").setValue("42.69")
			dbRefId1.child("longitude").setValue("23.31")
			
			let dbRefId2 = self.ref.child("users").child(self.user.uid).child("objects").childByAutoId()
			dbRefId2.child("title").setValue("London")
			dbRefId2.child("latitude").setValue("51.50")
			dbRefId2.child("longitude").setValue("-0.11")
			*/
			
			startObservingDatabase()
		}

		func startObservingDatabase () {
			databaseHandle = ref.child("objects/").observe(.value, with: { (snapshot) in
				var newObjects = [Object]()
				
				for objectSnapShot in snapshot.children {
					let object = Object(snapshot: objectSnapShot as! DataSnapshot)
					newObjects.append(object)
				}
				
				self.objects = newObjects
				
				for object in self.objects {
					print("Loaded object with name: \(object.title!), latitude: \(object.latitude!) and longitude: \(object.longitude!)")
				}
			})
		}
	
		deinit {
			ref.child("users/\(self.user.uid)/objects").removeObserver(withHandle: databaseHandle)
		}
}
