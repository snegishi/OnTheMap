//
//  InputLocationViewController.swift
//  OnTheMap
//
//  Created by Shin Negishi on 3/8/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import UIKit
import MapKit

class InputLocationViewController: UIViewController {
    
    // MARK: - Properties
    
    var location = ""
    var latitude = 0.0
    var longitude = 0.0
    var mediaURL = ""

    // MARK: - IBOutlets
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBAction func findLocation() {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = locationTextField.text!
        let localSearch = MKLocalSearch(request: request)
        DispatchQueue.main.async {
            self.setGeocodingIn(true)
        }
        localSearch.start(completionHandler: handleSearchResult(result:error:))
    }
        
    func handleSearchResult(result: MKLocalSearch.Response?, error: Error?) {
        DispatchQueue.main.async {
            self.setGeocodingIn(false)
        }
        if error == nil {
            for placemark in (result?.mapItems)! {
                latitude = placemark.placemark.coordinate.latitude
                longitude = placemark.placemark.coordinate.longitude
            }
            location = locationTextField.text!
            mediaURL = linkTextField.text!
            performSegue(withIdentifier: "SubmitLocationIdentifier", sender: self)
        } else {
            showFailure(title: "Post Failed", message: error?.localizedDescription ?? "")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let submitLocationVC = segue.destination as! SubmitLocationViewController
        submitLocationVC.location = location
        submitLocationVC.latitude = latitude
        submitLocationVC.longitude = longitude
        submitLocationVC.mediaURL = mediaURL
    }

    func setGeocodingIn(_ geocodingIn: Bool) {
        geocodingIn ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    }
    
    // MARK: - Cancel
    
    @IBAction func cancel() {
        dismiss(animated: true, completion: nil)
    }
}
