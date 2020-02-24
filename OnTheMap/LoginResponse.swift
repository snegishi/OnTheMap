//
//  LoginResponse.swift
//  OnTheMap
//
//  Created by Shin Negishi on 2/17/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation

struct Account: Codable {
    let registered: Bool
    let key: String
}

struct Session: Codable {
    let id: String
    let expiration: String
}

struct LoginResponse: Codable {
    let account: Account
    let session: Session
}
