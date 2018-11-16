//
//  RoundedShadowButton.swift
//  RGB
//
//  Created by Brenno Ribeiro on 9/3/18.
//  Copyright © 2018 Brenno Ribeiro. All rights reserved.
//

import UIKit

class RoundedShadowButton: UIButton {

    override func awakeFromNib() {
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowRadius = 15
        self.layer.shadowOpacity = 0.75
        self.layer.cornerRadius = 3
    }

}
