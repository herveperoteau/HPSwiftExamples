//
//  AddSpotViewController.swift
//  HPBarman
//
//  Created by Hervé Péroteau on 18/07/2017.
//  Copyright © 2017 Herve Peroteau. All rights reserved.
//

import UIKit
import Firebase

class AddSpotViewController: BaseViewController {

    @IBOutlet weak var tf_spotName: UITextField!
    @IBOutlet weak var lb_status: UILabel!
    
    
    
    override func setup() {
        super.setup()
        lb_status.text = nil
    }
    
    @IBAction func createSpot() {
        
        guard let spotName = tf_spotName.text else {
            return
        }
        
        print("createSpot \(spotName)...")
        
        let spot = Spot(name: spotName)
        
        
    }
}
