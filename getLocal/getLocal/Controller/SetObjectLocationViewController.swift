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
        self.showWaitOverlay()
        view.isUserInteractionEnabled = false
        
        addObjectToDatabase()
        
//        let objectDetailsVC = storyboard?.instantiateViewController(withIdentifier: StoryboardIDS.objectDetailsVC.rawValue)
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
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
//        let location = locations.last! as CLLocation
        let userLocation:CLLocation = locations[0] as CLLocation
        
        // Call stopUpdatingLocation() to stop listening for location updates,
        // otherwise this function will be called every time when user location changes.
        locationManager.stopUpdatingLocation()
        
        let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        objectLocationMapView.setRegion(region, animated: true)
        
        // Drop a pin at user's current location
        newPin.coordinate = CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude);
//        newPin = "Current location"
        objectLocationMapView.addAnnotation(newPin)
    }
    
    // func called when gesture recognizer detects a long press
    @objc func mapLongPress(_ recognizer: UIGestureRecognizer) {
        objectLocationMapView.removeAnnotation(newPin)
        newPin = MKPointAnnotation()
        
        let touchedAt = recognizer.location(in: self.objectLocationMapView) // adds the location on the view it was pressed
        let touchedAtCoordinate : CLLocationCoordinate2D = objectLocationMapView.convert(touchedAt, toCoordinateFrom: self.objectLocationMapView) // will get coordinates
        
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
                    
                    self.removeAllOverlays()
                    self.view.isUserInteractionEnabled = true
                    
                    return
                }

//                if let uploadedImageUrl = metadata?.downloadURL()?.absoluteString {
                if metadata != nil {
                    self.objectImageUrl = "\(imageName).png"
                    
                    self.saveObjectValues()
                    
                    self.removeAllOverlays()
                    self.view.isUserInteractionEnabled = true
                    
                    self.showSuccessfulAlert()
                }
            })
        }
        else {
            self.removeAllOverlays()
            self.view.isUserInteractionEnabled = true
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
    
    
    func showSuccessfulAlert() {
        let alertController = UIAlertController(title: "Success!", message: "You've successfully added an object!", preferredStyle: .alert)
        
        let action1 = UIAlertAction(title: "Okay!", style: .default) { (action:UIAlertAction) in
            self.tabBarController?.selectedIndex = 1
            self.navigationController?.popToRootViewController(animated: true)
        }
        
        alertController.addAction(action1)
 
        self.present(alertController, animated: true, completion: nil)
    }
    
}
