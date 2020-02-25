//
//  SubmitLocationViewController.swift
//  OnTheMap
//
//  Created by Shin Negishi on 2/24/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import UIKit
import MapKit

class SubmitLocationViewController: UIViewController {
    
    // MARK: - Properties
    
    var location = ""
    var latitude = 0.0
    var longitude = 0.0
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        searchLocation()
        OnTheMapClient.getStudentData(completion: {(data, error) in
            print(String(reflecting: data))
        })
    }
    
    // MARK: - Search location
    
    func searchLocation() {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = location
        let localSearch = MKLocalSearch(request: request)
        localSearch.start(completionHandler: self.handleSearchResult(result:error:))
    }
    
    func handleSearchResult(result: MKLocalSearch.Response?, error: Error?) {
        for placemark in (result?.mapItems)! {
            if(error == nil) {
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2DMake(placemark.placemark.coordinate.latitude, placemark.placemark.coordinate.longitude)
                annotation.title = placemark.placemark.name
                annotation.subtitle = placemark.placemark.title
                self.mapView.addAnnotation(annotation)
                self.latitude = placemark.placemark.coordinate.latitude
                self.longitude = placemark.placemark.coordinate.longitude
            } else {
                print(error)
            }
        }
    }
    
    @IBAction func submitLoction() {
        OnTheMapClient.postStudentLocation(firstName: "S", lastName: "N", latitude: latitude, longitude: longitude, mapString: location, mediaURL: linkTextField.text!, completion: self.handlePostLocationResponse(success:error:))
    }
    
    func handlePostLocationResponse(success: Bool, error: Error?) {
        if success {
            print("success")
        } else {
            print(error)
        }
    }
    
    // MARK: - Update my location
    
    func updateStudentLocation() {
        
    }
    
    @IBAction func cancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
}
