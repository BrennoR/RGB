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
        
        let text = "\(data.date)\nLocation: \(data.location)\n\(data.chemical): \(data.concentration) ppm\nTemp: \(data.temperature) °C   Humidity: \(String(describing: data.humidity)) %"
        
        dataLbl.text = text
        
        switch data.chemical {
        case "Phosphate":
            self.backgroundColor = #colorLiteral(red: 0.3452148438, green: 0.8467610677, blue: 1, alpha: 0.4574593322)
        case "Nitrate":
            self.backgroundColor = #colorLiteral(red: 0.9204101563, green: 0.5655110677, blue: 1, alpha: 0.4574593322)
        case "pH":
            self.backgroundColor = #colorLiteral(red: 0.3894585504, green: 0.8467610677, blue: 0.335015191, alpha: 0.4574593322)
        default:
            self.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        }
        
    }

}
