//
//  CameraViewController.swift
//  getLocal
//
//  Created by Emil Iliev on 1/14/18.
//  Copyright © 2018 Petar Ivanov. All rights reserved.
//

import UIKit
import ARCL
import CoreLocation

class CameraViewController: UIViewController {
	
	  var sceneLocationView = SceneLocationView()
	
	  override func viewDidLoad() {
		super.viewDidLoad()

		sceneLocationView.run()
		view.addSubview(sceneLocationView)
		
		let coordinate = CLLocationCoordinate2D(latitude: 42.679639, longitude: 23.253010)
		let location = CLLocation(coordinate: coordinate, altitude: 300)
		let image = UIImage(named: "pin")!
		
		let annotationNode = LocationAnnotationNode(location: location, image: image)
		sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: annotationNode)
	  }

	  override func viewDidLayoutSubviews() {
		  super.viewDidLayoutSubviews()
		
		  sceneLocationView.frame = view.bounds
		
	  }
	
}
