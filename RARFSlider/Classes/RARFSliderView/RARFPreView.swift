//
//  RARFPreView.swift
//  RARFSlider
//
//  Created by 永田大祐 on 2019/04/17.
//  Copyright © 2019 永田大祐. All rights reserved.
//

import UIKit

final class RARFPreView: UIView {

    public override init(frame: CGRect) {
        super.init(frame: frame)

        loadNib()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        loadNib()
    }

    func loadNib() {
        let bundle = Bundle(for: RARFPreView.self)
        let view = bundle.loadNibNamed("RARFPreView", owner: self, options: nil)?.first as! UIView
        view.frame = UIScreen.main.bounds
        self.addSubview(view)
    }
}
