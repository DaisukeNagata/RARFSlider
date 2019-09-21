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

    @IBOutlet private var sliderView: RARFSliderView!


    override func viewDidLoad() {
        super.viewDidLoad()

        sliderView.imagePick(vc: self, callBack: callBack)
    }

    func callBack() {
        guard let url = url else  { return }

        sliderView.removeFromSuperview()
        sliderView = RARFSliderView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        view.addSubview(sliderView)

        sliderView.rARFVc = self
        //DESIGNSET
        sliderView.rARFOpacity = 0.7
        sliderView.rARFSideWhide = 1
        sliderView.rARFBorderWidth = 1
        sliderView.rARFTopDownWhide = 1
        sliderView.rARFBorderColor = .white
        sliderView.rARFSetVideoModel.setURL(url: url, sliderView: sliderView, height: 100, heightY: 100)
    }
}
