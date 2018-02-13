//
//  Object.swift
//  getLocal
//
//  Created by Emil Iliev on 1/14/18.
//  Copyright © 2018 Petar Ivanov. All rights reserved.
//

import Foundation
import FirebaseDatabase

class Object {
	
		var ref: DatabaseReference?
		var title: String?
		var latitude: String?
		var longitude: String?
	
		init (snapshot: DataSnapshot) {
			ref = snapshot.ref
			
			let data = snapshot.value as! Dictionary<String, String>
			title = data["title"]
			latitude = data["latitude"]
			longitude = data["longitude"]
		}
	
}
