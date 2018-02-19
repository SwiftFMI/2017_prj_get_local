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


class SetObjectLocationViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var objectLocationMapView: MKMapView!
    
    var locationManager =  CLLocationManager()
    let newPin = MKPointAnnotation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // User's location
        
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        if #available(iOS 8.0, *) {
//        locationManager.requestAlwaysAuthorization()
//        } else {
//            // Fallback on earlier versions
//        }
        
//        if CLLocationManager.locationServicesEnabled() {
            //locationManager.startUpdatingHeading()
//            locationManager.startUpdatingLocation()
//        }
        
        // add gesture recognizer
//        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(SetObjectLocationViewController.mapLongPress(_:))) // colon needs to pass through info
//        longPress.minimumPressDuration = 1.5 // in seconds
//        //add gesture recognition
//        objectLocationMapView.addGestureRecognizer(longPress)
    }
    
    // func called when gesture recognizer detects a long press
//    @objc func mapLongPress(_ recognizer: UIGestureRecognizer) {
//        print("A long press has been detected.")
//
//        let touchedAt = recognizer.location(in: self.objectLocationMapView) // adds the location on the view it was pressed
//        let touchedAtCoordinate : CLLocationCoordinate2D = objectLocationMapView.convert(touchedAt, toCoordinateFrom: self.objectLocationMapView) // will get coordinates
//
//        let newPin = MKPointAnnotation()
//        newPin.coordinate = touchedAtCoordinate
//        objectLocationMapView.addAnnotation(newPin)
//    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        determineCurrentLocation()
    }
    
    func determineCurrentLocation()
    {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            //locationManager.startUpdatingHeading()
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        objectLocationMapView.removeAnnotation(newPin)
//
//        let location = locations.last! as CLLocation
//
//        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
//        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
//
//        //set region on the map
//        objectLocationMapView.setRegion(region, animated: true)
//
//        newPin.coordinate = location.coordinate
//        objectLocationMapView.addAnnotation(newPin)
        
        
        let userLocation:CLLocation = locations[0] as CLLocation
        
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        //manager.stopUpdatingLocation()
        
        let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        objectLocationMapView.setRegion(region, animated: true)
        
        // Drop a pin at user's Current Location
        let myAnnotation: MKPointAnnotation = MKPointAnnotation()
        myAnnotation.coordinate = CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude);
        myAnnotation.title = "Current location"
        objectLocationMapView.addAnnotation(myAnnotation)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
