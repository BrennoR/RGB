//
//  data.swift
//  RGB
//
//  Created by Brenno Ribeiro on 11/15/18.
//  Copyright © 2018 Brenno Ribeiro. All rights reserved.
//

import Foundation

struct RGBData {
    
    private(set) public var date: String
    private(set) public var location: String
    private(set) public var chemical: String
    private(set) public var concentration: Int
    
    init(date: Date, location: String, chemical: String, concentration: Int) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm O"
        dateFormatter.locale = .current
        let formattedDate = dateFormatter.string(from: date)
        self.date = formattedDate
        self.location = location
        self.chemical = chemical
        self.concentration = concentration
    }
    
}
