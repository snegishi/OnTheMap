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
    static var isSubmitted = false
    var location = ""
    var latitude = 0.0
    var longitude = 0.0
    
    // MARK: - IBOutlets
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Search location
    
    func searchLocation() {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = locationTextField.text!
        let localSearch = MKLocalSearch(request: request)
        DispatchQueue.main.async {
            self.setGeocodingIn(true)
        }
        localSearch.start(completionHandler: self.handleSearchResult(result:error:))
    }
    
    func handleSearchResult(result: MKLocalSearch.Response?, error: Error?) {
        DispatchQueue.main.async {
            self.setGeocodingIn(false)
        }
        if error == nil {
            for placemark in (result?.mapItems)! {
//                let annotation = MKPointAnnotation()
//                annotation.coordinate = CLLocationCoordinate2DMake(placemark.placemark.coordinate.latitude, placemark.placemark.coordinate.longitude)
//                annotation.title = placemark.placemark.name
//                annotation.subtitle = placemark.placemark.title
//                self.mapView.addAnnotation(annotation)
                self.latitude = placemark.placemark.coordinate.latitude
                self.longitude = placemark.placemark.coordinate.longitude
            }
        } else {
            showPostFailure(message: error?.localizedDescription ?? "")
        }
    }
    
    // MARK: - Submit Location
    
    @IBAction func submitLoction() {
        searchLocation()
        if LocationModel.existsMyLocation {
            OnTheMapClient.updateStudentLocation(firstName: "S", lastName: "N", latitude: latitude, longitude: longitude, mapString: location, mediaURL: linkTextField.text!, completion: self.handlePostLocationResponse(success:error:))
        } else {
            OnTheMapClient.postStudentLocation(firstName: "S", lastName: "N", latitude: latitude, longitude: longitude, mapString: location, mediaURL: linkTextField.text!, completion: self.handlePostLocationResponse(success:error:))
        }
    }
    
    func handlePostLocationResponse(success: Bool, error: Error?) {
        if success {
            SubmitLocationViewController.isSubmitted = true
            self.dismiss(animated: true, completion: nil)
            print("isSubmitted in SubmitView: \(SubmitLocationViewController.isSubmitted)")
        } else {
            showPostFailure(message: error?.localizedDescription ?? "")
        }
    }
    
    // MARK: - Cancel
    
    @IBAction func cancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setGeocodingIn(_ geocodingIn: Bool) {
        if geocodingIn {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    // MARK: - Error Message
    
    func showPostFailure(message: String) {
        let alertVC = UIAlertController(title: "Post Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
}

extension SubmitLocationViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
