//
//  Spot.swift
//  HPBarman
//
//  Created by Hervé Péroteau on 18/07/2017.
//  Copyright © 2017 Herve Peroteau. All rights reserved.
//

import Foundation
import Firebase

struct Spot {
    
    let key: String
    let name: String
    let ref: DatabaseReference?
    
    init(name: String, key: String = "") {
        self.key = key
        self.name = name
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        name = snapshotValue["name"] as! String
        ref = snapshot.ref
    }
    
}
