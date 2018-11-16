//
//  RoundedShadowView.swift
//  RGB
//
//  Created by Brenno Ribeiro on 9/3/18.
//  Copyright © 2018 Brenno Ribeiro. All rights reserved.
//

import UIKit

class RoundedShadowView: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowRadius = 15
        self.layer.shadowOpacity = 0.75
        self.layer.cornerRadius = 10
    }

}
