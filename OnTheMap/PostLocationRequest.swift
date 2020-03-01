//
//  PostLocationRequest.swift
//  OnTheMap
//
//  Created by Shin Negishi on 2/22/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation

struct PostLocationRequest: Codable {
    let firstName: String
    let lastName: String
    let latitude: Double
    let longitude: Double
    let mapString: String
    let mediaURL: String
    let uniqueKey: String
}
