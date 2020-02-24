//
//  LoginRequest.swift
//  OnTheMap
//
//  Created by Shin Negishi on 2/17/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation

struct Udacity: Codable {
    let username: String
    let password: String
}

struct LoginRequest: Codable {
    let udacity: Udacity
}
