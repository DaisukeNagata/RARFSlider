//
//  ViewController.swift
//  RARFSlider
//
//  Created by daisukenagata on 04/08/2019.
//  Copyright (c) 2019 daisukenagata. All rights reserved.
//

import UIKit
import RARFSlider

class ViewController: RARFPickerViewController {

    private var sliderView: RARFSliderView?

    override func viewDidLoad() {
        super.viewDidLoad()

        sliderView = RARFSliderView()
        sliderView?.imagePick(vc: self, callBack: callBack)
    }

    func callBack() {
        sliderView?.removeFromSuperview()
        sliderView = RARFSliderView(frame: view.frame)
        view.addSubview(sliderView ?? RARFSliderView())
        sliderView?.rARFVc = self
        guard let url = url else  { return }
        //DESIGNSET
        sliderView?.rARFOpacity = 0.7
        sliderView?.rARFBorderWidth = 1
        sliderView?.rARFTopDownWhide = 1
        sliderView?.rARFBorderColor = .white
        sliderView?.rARFSetVideoModel.setURL(url: url, sliderView: sliderView ?? RARFSliderView(), height: 100, heightY: 100)
    }
}
