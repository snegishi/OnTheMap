//
//  InputLocationViewController.swift
//  OnTheMap
//
//  Created by Shin Negishi on 2/22/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import UIKit

class InputLocationViewController: UIViewController {
    
    // MARK: - Properties
    
    // MARK: - IBOutlets
    

    
    // MARK: - Life Cycle
    
    
    // MARK: - Add a new location of myself
    func postStudentLocation() {
        OnTheMapClient.postStudentLocation(firstName: "S", lastName: "N", latitude: 135.5196, longitude: 34.6862, mapString: "Osaka", mediaURL: "https://www.kyorikeisan.com/ido-keido-kensaku/idotokeidonorekishi/132.aspx", completion: self.handlePostLocationResponse(success:error:))
    }
    
    func handlePostLocationResponse(success: Bool, error: Error?) {
        if success {
            print("success")
        }
    }
    
    // MARK: - Update my location
    func updateStudentLocation() {
        
    }
    
    
}
