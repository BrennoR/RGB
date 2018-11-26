//
//  RGBValues.swift
//  RGB
//
//  Created by Brenno Ribeiro on 11/26/18.
//  Copyright © 2018 Brenno Ribeiro. All rights reserved.
//

import Foundation

struct RGBValues {
    
    private(set) public var red: Float
    private(set) public var green: Float
    private(set) public var blue: Float
    private(set) public var rh: [Float]
    private(set) public var gh: [Float]
    private(set) public var bh: [Float]
    private(set) public var ih: [Float]
    
    init(red: Float, green: Float, blue: Float, rh: [Float], gh: [Float], bh: [Float], ih: [Float]) {
        self.red = red
        self.green = green
        self.blue = blue
        self.rh = rh
        self.gh = gh
        self.bh = bh
        self.ih = ih
    }
    
}
