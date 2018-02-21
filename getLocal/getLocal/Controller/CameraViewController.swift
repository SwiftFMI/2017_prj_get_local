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
import FirebaseDatabase


class CameraViewController: UIViewController {
	
	var objects = [Object]()
	var ref: DatabaseReference!
	private var databaseHandle: DatabaseHandle!

	var sceneLocationView = SceneLocationView()

	override func viewDidLoad() {
	  super.viewDidLoad()

	  sceneLocationView.run()
	  view.addSubview(sceneLocationView)
		
	  ref = Database.database().reference()
	  startObservingDatabase()
		self.navigationController?.setNavigationBarHidden(true, animated: false)
	}
	
	override func viewDidLayoutSubviews() {
	  super.viewDidLayoutSubviews()
	  sceneLocationView.frame = view.bounds
	}
	
	func startObservingDatabase () {
	  databaseHandle = ref.child("objects").observe(.value, with: { (snapshot) in
		var newObjects = [Object]()
		for objectSnapShot in snapshot.children {
		  let object = Object(snapshot: objectSnapShot as! DataSnapshot)
		  newObjects.append(object)
		}
		
		self.objects = newObjects
		self.setSceneNodes()
	  })
	}
	
	func setSceneNodes() {
	  for object in objects {
			// 		Bug: - object images are overlapping
			//			if object.category != "restaurant" && object.category != "pharmacy" {
				let coordinate = CLLocationCoordinate2D(latitude: object.latitude!, longitude: object.longitude!)
				let location = CLLocation(coordinate: coordinate, altitude: 280)
				let image = textToImage(drawText: object.title!, inImage: UIImage(named: "callout")!, atPoint: CGPoint(x: 10, y: 20))
				
				let annotationNode = LocationAnnotationNode(location: location, image: image)
				// annotationNode.scaleRelativeToDistance = true
				sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: annotationNode)
			//			}
	  }
	}
	
	// MARK: - Source: https://stackoverflow.com/questions/28906914/how-do-i-add-text-to-an-image-in-ios-swift
	func textToImage(drawText text: String, inImage image: UIImage, atPoint point: CGPoint) -> UIImage {
		let textColor = UIColor.black
		let textFont = UIFont(name: "Helvetica Bold", size: 8)!
		
		let scale = UIScreen.main.scale
		UIGraphicsBeginImageContextWithOptions(image.size, false, scale)
		
		let textFontAttributes = [
			NSAttributedStringKey.font: textFont,
			NSAttributedStringKey.foregroundColor: textColor,
			] as [NSAttributedStringKey : Any]
		image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
		
		let rect = CGRect(origin: point, size: image.size)
		text.draw(in: rect, withAttributes: textFontAttributes)
		
		let newImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		return newImage!
	}
}
