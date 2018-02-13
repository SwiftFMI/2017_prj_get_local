//
//  ObjectsListViewController.swift
//  getLocal
//
//  Created by Emil Iliev on 1/14/18.
//  Copyright © 2018 Petar Ivanov. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class ObjectsListViewController: UIViewController {
	
		var user: User!
		var objects = [Object]()
		var ref: DatabaseReference!
		private var databaseHandle: DatabaseHandle!
	
		override func viewDidLoad() {
			super.viewDidLoad()
			user = Auth.auth().currentUser
			ref = Database.database().reference()
			//startObservingDatabase()
			// Do any additional setup after loading the view.
		}
	
	
}

