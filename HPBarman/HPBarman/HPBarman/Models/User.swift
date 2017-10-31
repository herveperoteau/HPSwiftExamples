//
//  User.swift
//  HPBarman
//
//  Created by Hervé Péroteau on 18/07/2017.
//  Copyright © 2017 Herve Peroteau. All rights reserved.
//

import Foundation

import Firebase

struct SpotUser : CustomStringConvertible {
    
    var description: String {
        var result = "(uid:\(uid), providerID:\(providerID)"
        if let email = email {
            result += ", email:\(email)"
        }
        if let displayName = displayName {
            result += ", displayName:\(displayName)"
        }
        if let photoURL = photoURL {
            result += ", photoURL:\(photoURL)"
        }
        if let phoneNumber = phoneNumber {
            result += ", phoneNumber:\(phoneNumber)"
        }
        return result
    }
    
    let uid: String
    let providerID: String
    let email: String?
    let displayName: String?
    let photoURL: URL?
    let phoneNumber: String?
    
    init(authData: User) {
        uid = authData.uid
        providerID = authData.providerID
        email = authData.email
        displayName = authData.displayName
        photoURL = authData.photoURL
        phoneNumber = authData.phoneNumber
    }
}
