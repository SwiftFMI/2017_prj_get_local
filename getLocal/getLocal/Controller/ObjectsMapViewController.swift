//
//  ObjectsMapViewController
//  getLocal
//
//  Created by Emil Iliev on 1/14/18.
//  Copyright © 2018 Petar Ivanov. All rights reserved.
//

import UIKit
import MapKit
import FirebaseDatabase
import FirebaseStorage

class ObjectsMapViewController: UIViewController {


		// MARK: - IBOutlets
		@IBOutlet var mapView: MKMapView!
	
		// MARK: - Properties
		var objects = [Object]()
		var ref: DatabaseReference!
		private var databaseHandle: DatabaseHandle!
	    var storageRef: StorageReference!
		var selectedObject : Object!

		var coordinates: [[Double]]!
		var titles: [String]!
		var workHours: [String]!
		var imageUrls: [String]!
		var objectIds: [String]!
		var locationManager = CLLocationManager()

		override func viewDidLoad() {
			super.viewDidLoad()
			

			mapView.delegate = self
			mapView.showsUserLocation = true;
			ref = Database.database().reference()
			storageRef = Storage.storage().reference()
			
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
			
			locationManager.delegate = self
			locationManager.desiredAccuracy = kCLLocationAccuracyBest
			locationManager.requestWhenInUseAuthorization()
			locationManager.startUpdatingLocation()
			startObservingDatabase()
		}

		func startObservingDatabase () {
			self.showWaitOverlay()
			databaseHandle = ref.child("objects").observe(.value, with: { (snapshot) in
				var newObjects = [Object]()
				
				for objectSnapShot in snapshot.children {
					let object = Object(snapshot: objectSnapShot as! DataSnapshot)
					newObjects.append(object)
				}
				
				self.objects = newObjects
				
                for object in self.objects {
                    print("Loaded object with name: \(object.title!), latitude: \(object.latitude!) and longitude: \(object.longitude!), cattegory: \(object.category!), imageUrl: \(object.imageUrl!), description: \(object.description!), workTime: \(object.workTime!), uid: \(object.uid!)")
                }
				
				self.loadMapData()
				
			})
		}
	
		func loadMapData() {
            coordinates = []
            titles = []
            workHours = []
            imageUrls = []
            objectIds = []

            for object in objects {
                coordinates.append([object.latitude!, object.longitude!])
                titles.append(object.title!)
                workHours.append(object.workTime!)
                imageUrls.append(object.imageUrl!)
                objectIds.append(object.uid!)
            }

            for i in 0...objects.count-1 {
                let coordinate = coordinates[i]
                let point = ObjectAnnotation(coordinate: CLLocationCoordinate2D(latitude: coordinate[0] , longitude: coordinate[1] ))
                point.imageUrl = imageUrls[i]
                point.name = titles[i]
                point.workTime = workHours[i]
                point.objectId = objectIds[i]
                self.mapView.addAnnotation(point)
            }

            let region = MKCoordinateRegion(center: mapView.userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
            self.mapView.setRegion(region, animated: false)
            self.removeAllOverlays()
		}
	
		@objc func gotoDetailsScreen() {
			let objectDetailsStoryboard = UIStoryboard.init(name: "ObjectDetail", bundle: Bundle.main)
			let detailsVC = objectDetailsStoryboard.instantiateViewController(withIdentifier: StoryboardIDS.objectDetailsVC.rawValue) as! ObjectDetailsViewController
			detailsVC.object = selectedObject
			self.navigationController?.pushViewController(detailsVC, animated: true)
		}
	
    deinit {
        if ref != nil {
            ref.child("objects").removeObserver(withHandle: databaseHandle)
        }
    }
}


// MARK: - MKMapViewDelegate
extension ObjectsMapViewController: MKMapViewDelegate {
	
		func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
			if annotation is MKUserLocation {
				return nil
			}
			var annotationView = self.mapView.dequeueReusableAnnotationView(withIdentifier: "Pin")
			if annotationView == nil {
				annotationView = AnnotationView(annotation: annotation, reuseIdentifier: "Pin")
				annotationView?.canShowCallout = false
			} else {
				annotationView?.annotation = annotation
			}
			annotationView?.image = #imageLiteral(resourceName: "pin")
			return annotationView
		}
	
		func mapView(_ mapView: MKMapView,
								 didSelect view: MKAnnotationView) {

			if view.annotation is MKUserLocation {
				// Don't proceed with custom callout
				return
			}

			let objectAnnotation = view.annotation as! ObjectAnnotation
			let views = Bundle.main.loadNibNamed("CustomCalloutView", owner: nil, options: nil)
			let calloutView = views?[0] as! CustomCalloutView
			let tap = UITapGestureRecognizer(target: self, action: #selector(gotoDetailsScreen))
			calloutView.addGestureRecognizer(tap)
			calloutView.isUserInteractionEnabled = true
			calloutView.pinTitleLabel.text = objectAnnotation.name
			calloutView.pinWorkTimeLabel.text = "Work time: \(objectAnnotation.workTime!)"
			
			selectedObject = objects.first(where: { $0.uid == objectAnnotation.objectId })
			
			// Setting cached image from url
			if objectAnnotation.downloadImageUrl != nil {
				calloutView.pinImageView.loadImageUsingCacheWithUrlString(objectAnnotation.downloadImageUrl)
			} else {
				storageRef.child(objectAnnotation.objectId).child(objectAnnotation.imageUrl).getMetadata(completion: { metadata, error in
					if let error = error {
						print(error.localizedDescription)
					}
					if let metadata = metadata {
						let url = metadata.downloadURL()
						objectAnnotation.downloadImageUrl = url?.absoluteString
						calloutView.pinImageView.loadImageUsingCacheWithUrlString((url?.absoluteString)!)
					}
				})
			}

			calloutView.center = CGPoint(x: view.bounds.size.width / 2, y: -calloutView.bounds.size.height*0.52)
			view.addSubview(calloutView)
			mapView.setCenter((view.annotation?.coordinate)!, animated: true)
		}
	
		func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
			if view.isKind(of: AnnotationView.self) {
				for subview in view.subviews {
					subview.removeFromSuperview()
				}
			}
		}

	
}

// MARK: - CLLocationManagerDelegate
extension ObjectsMapViewController: CLLocationManagerDelegate {
	
		func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
			let region = MKCoordinateRegion(center: mapView.userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
			self.mapView.setRegion(region, animated: false)
			locationManager.stopUpdatingLocation()
		}
}

