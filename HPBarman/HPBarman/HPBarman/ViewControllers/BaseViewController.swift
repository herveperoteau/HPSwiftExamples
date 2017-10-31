//
//  BaseViewController.swift
//  HPBarman
//
//  Created by Hervé Péroteau on 18/07/2017.
//  Copyright © 2017 Herve Peroteau. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    deinit {
        print("deinit \(self.classForCoder)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {}
}
