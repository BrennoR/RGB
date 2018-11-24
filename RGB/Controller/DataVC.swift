//
//  DataVC.swift
//  RGB
//
//  Created by Brenno Ribeiro on 11/14/18.
//  Copyright © 2018 Brenno Ribeiro. All rights reserved.
//

import UIKit
import CoreData

class DataVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // IB Outlets
    @IBOutlet weak var dataTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dataTableView.delegate = self
        dataTableView.dataSource = self
        
        // Storing Core Data
        
    }
    
    @IBAction func backBtnWasPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return dataCell()
    }
    
    

}
