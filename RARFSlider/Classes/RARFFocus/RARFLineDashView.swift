//
//  RARFLineDashView.swift
//  RARFSlider
//
//  Created by 永田大祐 on 2018/06/30.
//  Copyright © 2018年 永田大祐. All rights reserved.
//

import UIKit

final class RARFLineDashView: UIView {
    
    var yHeight: CGFloat = 100
    var screenWidth = UIScreen.main.bounds.width

    override init(frame: CGRect) {
        super.init(frame: .zero)

        self.backgroundColor = .clear
        self.frame = CGRect(x: 0, y: 0, width: screenWidth, height: yHeight)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
