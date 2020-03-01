//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Jason on 3/23/15.
//  Copyright (c) 2015 Udacity. All rights reserved.
//

import UIKit
import MapKit

/**
* This view controller demonstrates the objects involved in displaying pins on a map.
*
* The map is a MKMapView.
* The pins are represented by MKPointAnnotation instances.
*
* The view controller conforms to the MKMapViewDelegate so that it can receive a method 
* invocation when a pin annotation is tapped. It accomplishes this using two delegate 
* methods: one to put a small "info" button on the right side of each pin, and one to
* respond when the "info" button is tapped.
*/

class MapViewController: UIViewController {
    
    // MARK: - Properties
    
    var locations = [StudentInformation]()//[[String : Any]]

    // MARK: - IBOutlets
    
    // The map. See the setup in the Storyboard file. Note particularly that the view controller
    // is set up as the map view's delegate.
    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if SubmitLocationViewController.isSubmitted {
            SubmitLocationViewController.isSubmitted = false
            displayMyLocation()
        } else {
            updateStudentLocations()
        }
    }
    
    // MARK: - Logout
    
    @IBAction func logoutTapped(_ sender: UIButton) {
        OnTheMapClient.logout(completion: self.handleLogoutResponse(success:error:))
    }

    func handleLogoutResponse(success: Bool, error: Error?) {
        if success {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - Display My Location after submitting
    
    func displayMyLocation() {
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2DMake(LocationModel.myLocation!.latitude, LocationModel.myLocation!.longitude)
        annotation.title = LocationModel.myLocation!.firstName + " " + LocationModel.myLocation!.lastName
        annotation.subtitle = LocationModel.myLocation!.mediaURL
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotation(annotation)
    }
    
    // MARK: - Retrieve Student Locations Data
    
    @IBAction func updateStudentLocations() {
        OnTheMapClient.getStudentLocations(uniqueKey: "", completion: self.handleStudentLocationsResponse(locations:error:))
    }
    
    func handleStudentLocationsResponse(locations: [StudentInformation], error: Error?) {
        LocationModel.locations = locations
        
        // We will create an MKPointAnnotation for each dictionary in "locations". The
        // point annotations will be stored in this array, and then provided to the map view.
        var annotations = [MKPointAnnotation]()
        
        // The "locations" array is loaded with the sample data below. We are using the dictionaries
        // to create map annotations. This would be more stylish if the dictionaries were being
        // used to create custom structs. Perhaps StudentLocation structs.
        
        for dictionary in LocationModel.locations {
            
            // Notice that the float values are being used to create CLLocationDegree values.
            // This is a version of the Double type.
            let lat = CLLocationDegrees(dictionary.latitude )
            let long = CLLocationDegrees(dictionary.longitude )
            
            // The lat and long are used to create a CLLocationCoordinates2D instance.
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let first = dictionary.firstName
            let last = dictionary.lastName
            let mediaURL = dictionary.mediaURL
            
            // Here we create the annotation and set its coordiate, title, and subtitle properties
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            
            // Finally we place the annotation in an array of annotations.
            annotations.append(annotation)
        }
        
        // When the array is complete, we add the annotations to the map.
        self.mapView.removeAnnotations(self.mapView.annotations)
        self.mapView.addAnnotations(annotations)
    }
    
    // MARK: - Check if my location has already been registered.
    @IBAction func existsMyLocation() {
        OnTheMapClient.getStudentLocations(uniqueKey: OnTheMapClient.Auth.userId, completion: self.handleGetStudentLocations(locations:error:))
    }
    
    func handleGetStudentLocations(locations: [StudentInformation], error: Error?) {
        if locations.count >= 1 {
            LocationModel.existsMyLocation = true
            let message = "You Have Already Posted a Student Location. Would you Like to Overwrite Your Current Location ?"
            let alertVC = UIAlertController(title: "", message: message, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "Overwrite", style: .default, handler: { (alertAction) in
                self.performSegue(withIdentifier: "InputLocationIdentifier", sender: self)
            }))
            alertVC.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            self.show(alertVC, sender: nil)
        } else {
           self.performSegue(withIdentifier: "InputLocationIdentifier", sender: self)
        }
    }
}
    
extension MapViewController: MKMapViewDelegate {

    // MARK: - MKMapViewDelegate

    // Here we create a view with a "right callout accessory view". You might choose to look into other
    // decoration alternatives. Notice the similarity between this method and the cellForRowAtIndexPath
    // method in TableViewDataSource.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }

    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.openURL(URL(string: toOpen)!)
            }
        }
    }
}
