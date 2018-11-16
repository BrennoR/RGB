//
//  dataCell.swift
//  RGB
//
//  Created by Brenno Ribeiro on 11/15/18.
//  Copyright © 2018 Brenno Ribeiro. All rights reserved.
//

import UIKit

class dataCell: UITableViewCell {

    @IBOutlet weak var dataLbl: UILabel!
    
    func updateData(data: RGBData) {
        dataLbl.text = ""
    }

}
