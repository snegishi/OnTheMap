//
//  Student.swift
//  OnTheMap
//
//  Created by Shin Negishi on 2/24/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation

struct Allowance: Codable {
    let allowedBehaviors: [String]
    
    enum CodingKeys: String, CodingKey {
        case allowedBehaviors = "allowed_behaviors"
    }
}

struct Email: Codable {
    
}

struct EmailPreferences: Codable {
    
}

struct Memberships: Codable {
    
}

struct User: Codable {
    let lastName: String
//    let socialAccounts: [String]
//    let mailingAddress: String?
//    let cohortKeys: [String]
//    let signature: String?
//    let stripeCustomerId: String?
//    let facebookId: String?
//    let sitePreferences: String?
    let firstName: String
//    let jabberId: String?
//    let languages: String?
//    let badges: [String]
//    let externalServicePassword: String?
//    let principals: [String]
//    let enrollments: [String]
//    let email: Email
//    let externalAccounts: [String]
//    let coachingData: String?
//    let tags: [String]
//    let affliateProfiles: [String]
//    let hasPassword: Bool
//    let emailPreferences: EmailPreferences
//    let resume: String?
//    let employerSharing: Bool
//    let memberships: Memberships
//    let zendeskId: String?
//    let googleId: String?
//
//    let bio: String?
//    let registered: Bool
//    let linkedinUrl: String?
//    let image: String?
//    let allowance: Allowance
//    let location: String?
//    let key: String
//    let timezone: String?
//    let imageUrl: String?
//    let nickname: String
//    let websiteUrl: String?
//    let occupation: String?
    
    enum CodingKeys: String, CodingKey {
        case lastName = "last_name"
//        case socialAccounts
//        case mailingAddress
//        case cohortKeys
//        case signature
//        case stripeCustomerId
//        case facebookId
//        case sitePreferences
        case firstName = "first_name"
//        case jabberId
//        case languages
//        case badges
//        case externalServicePassword
//        case principals
//        case enrollments
//        case email
//        case externalAccounts
//        case coachingData
//        case tags
//        case affliateProfiles
//        case hasPassword
//        case emailPreferences
//        case resume
//        case employerSharing
//        case memberships
//        case zendeskId
//        case googleId
//
//
//        case bio
//        case registered = "_registered"
//        case linkedinUrl = "linkedin_url"
//        case image = "_image"
//        case allowance = "guard"
//        case location
//        case key
//        case timezone
//        case imageUrl = "_image_url"
//        case nickname
//        case websiteUrl = "website_url"
//        case occupation
    }
}

struct Student: Codable {
    let user: User
}
