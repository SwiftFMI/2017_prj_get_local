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
    var latitude: Double?
    var longitude: Double?
    var category: String?
    var imageUrl: String?
    var description: String?
    var workTime: String?
    var uid: String?

    init (snapshot: DataSnapshot) {
        ref = snapshot.ref
        uid = snapshot.key
        let data = snapshot.value as! Dictionary<String, Any>
        title = data["title"] as? String
        latitude = data["latitude"] as? Double
        longitude = data["longitude"] as? Double
        category = data["category"] as? String
        imageUrl = data["imageUrl"] as? String
        description = data["description"] as? String
        workTime = data["workTime"] as? String
    }
	
}
