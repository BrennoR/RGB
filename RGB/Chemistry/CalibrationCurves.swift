//
//  CalibrationCurves.swift
//  RGB
//
//  Created by Brenno Ribeiro on 11/1/18.
//  Copyright © 2018 Brenno Ribeiro. All rights reserved.
//

import Foundation

func phosphateLvl(blue: Float) -> Int {
    let plvl = Int((0.012 * blue * blue) - (5.6 * blue) + 660)
    return plvl
}

func nitrateLvl(red: Float) -> Int {
    let nlvl = Int((0.012 * red * red) - (5.6 * red) + 660)
    return nlvl
}

func pHLvl(green: Float) -> Int {
    let phlvl = Int((0.012 * green * green) - (5.6 * green) + 660)
    return phlvl
}
