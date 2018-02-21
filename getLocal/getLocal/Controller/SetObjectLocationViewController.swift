//
//  SetObjectLocationViewController.swift
//  getLocal
//
//  Created by Petar Ivanov on 2/19/18.
//  Copyright © 2018 Petar Ivanov. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import FirebaseStorage
import FirebaseAuth
import FirebaseDatabase

class SetObjectLocationViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var objectLocationMapView: MKMapView!
    
    @IBAction func pressSubmitObjectButton(_ sender: Any) {
        addObjectToDatabase()
        
//        let objectDetailsVC = storyboard?.instantiateViewController(withIdentifier: StoryboardIDS.objectDetailsVC.rawValue)
        self.tabBarController?.selectedIndex = 1
        navigationController?.popToRootViewController(animated: true)
    }
    
    var ref: DatabaseReference!
    var dbRef: DatabaseReference!
    
    var objectCreatedBy: String!
    
    var locationManager =  CLLocationManager()
    var newPin = MKPointAnnotation()
    
    var objectTitle: String = ""
    var objectCategory: String = ""
    var objectImage: UIImage = UIImage()
    var objectImageUrl: String = ""
    var objectWorkTime: String = ""
    var objectDescription: String = ""
    var objectUid: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Set object's location"
        
        ref = Database.database().reference()
        
        dbRef = self.ref.child("objects").childByAutoId()
        
        objectCreatedBy = Auth.auth().currentUser?.uid
        
        objectLocationMapView.delegate = self
        
        objectLocationMapView.showsUserLocation = false
        
        // User's location
        determineCurrentLocation()
        
        // add gesture recognizer
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(SetObjectLocationViewController.mapLongPress(_:))) // colon needs to pass through info
//        longPress.minimumPressDuration = 1.5 // in seconds
        longPress.numberOfTouchesRequired = 1

        //add gesture recognition
        objectLocationMapView.addGestureRecognizer(longPress)
    }
    
    func determineCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
//        if CLLocationManager.locationServicesEnabled() {
//            locationManager.startUpdatingHeading()
        locationManager.startUpdatingLocation()
//        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        objectLocationMapView.removeAnnotation(newPin)
//
//        let location = locations.last! as CLLocation
//
//        newPin.coordinate = location.coordinate
//        objectLocationMapView.addAnnotation(newPin)
        
        let userLocation:CLLocation = locations[0] as CLLocation
        
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        locationManager.stopUpdatingLocation()
        
        let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        objectLocationMapView.setRegion(region, animated: true)
        
        // Drop a pin at user's Current Location
//        let myAnnotation: MKPointAnnotation = MKPointAnnotation()
        newPin.coordinate = CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude);
//        myAnnotation.title = "Current location"
        objectLocationMapView.addAnnotation(newPin)
    }
    
    // func called when gesture recognizer detects a long press
    @objc func mapLongPress(_ recognizer: UIGestureRecognizer) {
        print("A long press has been detected.")
        
        objectLocationMapView.removeAnnotation(newPin)
        newPin = MKPointAnnotation()
        
        let touchedAt = recognizer.location(in: self.objectLocationMapView) // adds the location on the view it was pressed
        let touchedAtCoordinate : CLLocationCoordinate2D = objectLocationMapView.convert(touchedAt, toCoordinateFrom: self.objectLocationMapView) // will get coordinates
        
//        let newPin = MKPointAnnotation()
        newPin.coordinate = touchedAtCoordinate
        objectLocationMapView.addAnnotation(newPin)
    }
    
    func addObjectToDatabase() {
        
        uploadImage(objectId: dbRef.key)
    }
    
    func uploadImage(objectId: String) {
        let imageName = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child(objectId).child("\(imageName).png")

        if let uploadData = UIImagePNGRepresentation(objectImage) {

            storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in

                if let error = error {
                    print(error)
                    return
                }

                if let uploadedImageUrl = metadata?.downloadURL()?.absoluteString {
                    self.objectImageUrl = uploadedImageUrl
                    
                    self.saveObjectValues()
                }
            })
        }
    }
    
    func saveObjectValues() {
        dbRef.child("title").setValue(objectTitle)
        dbRef.child("latitude").setValue(newPin.coordinate.latitude)
        dbRef.child("longitude").setValue(newPin.coordinate.longitude)
        dbRef.child("category").setValue(objectCategory)
        dbRef.child("imageUrl").setValue(objectImageUrl)
        dbRef.child("workTime").setValue(objectWorkTime)
        dbRef.child("description").setValue(objectDescription)
        dbRef.child("createdBy").setValue(objectCreatedBy)
        dbRef.child("uid").setValue(objectUid)
    }
    
}
