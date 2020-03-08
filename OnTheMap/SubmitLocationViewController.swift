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
    var mediaURL = ""
    
    // MARK: - IBOutles
    @IBOutlet weak var mapView: MKMapView!
        
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        displayMyLocation()
    }
    
    // MARK: - Display My Location after submitting
    
    func displayMyLocation() {
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        annotation.title =  "S N"
        annotation.subtitle = mediaURL
        mapView.addAnnotation(annotation)
    }
            
    // MARK: - Submit Location
    
    @IBAction func submitLocation() {
        if LocationModel.existsMyLocation {
            OnTheMapClient.updateStudentLocation(firstName: "S", lastName: "N", latitude: latitude, longitude: longitude, mapString: location, mediaURL: mediaURL, completion: self.handlePostLocationResponse(success:error:))
        } else {
            OnTheMapClient.postStudentLocation(firstName: "S", lastName: "N", latitude: latitude, longitude: longitude, mapString: location, mediaURL: mediaURL, completion: self.handlePostLocationResponse(success:error:))
        }
    }
    
    func handlePostLocationResponse(success: Bool, error: Error?) {
        if success {
            self.dismiss(animated: true, completion: nil)
        } else {
            showPostFailure(message: error?.localizedDescription ?? "")
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
