//
//  Context.swift
//  HPBarman
//
//  Created by Hervé Péroteau on 18/07/2017.
//  Copyright © 2017 Herve Peroteau. All rights reserved.
//

import Foundation

struct Context {
    static var user: SpotUser? {
        didSet {
            if let user = user {
                print("Context setUser:\(user)")
            }
            else {
                print("Context setUser: DISCONNECT")
            }
        }
    }
}
