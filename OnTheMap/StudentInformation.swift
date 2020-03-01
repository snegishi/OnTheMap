//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Shin Negishi on 2/22/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation

struct StudentInformation: Codable {
    let createdAt: String
    let firstName: String
    let lastName: String
    var latitude: Double
    var longitude: Double
    var mapString: String
    var mediaURL: String
    let objectId: String
    let uniqueKey: String
    var updatedAt: String
}



