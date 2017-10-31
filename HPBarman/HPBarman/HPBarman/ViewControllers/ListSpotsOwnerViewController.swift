//
//  ListSpotsOwnerViewController.swift
//  HPBarman
//
//  Created by Hervé Péroteau on 18/07/2017.
//  Copyright © 2017 Herve Peroteau. All rights reserved.
//

import UIKit

class ListSpotsOwnerViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
    }
}

extension ListSpotsOwnerViewController: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellSpot")
        return cell!
    }
}
