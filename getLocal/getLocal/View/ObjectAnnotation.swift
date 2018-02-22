//
//  StarbucksAnnotation.swift
//  CustomCalloutView
//
//  Created by Latchezar Mladenov on 20/02/18.
//  Copyright © 2018 Petar Ivanov. All rights reserved.
//

import MapKit

class ObjectAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var workTime: String!
    var name: String!
    var imageUrl: String!
	var objectId: String!
	var downloadImageUrl: String!
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}
