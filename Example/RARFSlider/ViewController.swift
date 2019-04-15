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

        sliderView.imagePick(vc: self)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)

        guard let url = url else  { return }

        sliderView.removeFromSuperview()
        sliderView = RARFSliderView(frame: CGRect(x: 0, y: 100, width: view.frame.width, height: view.frame.height))
        view.addSubview(sliderView)

        sliderView.url = url
        sliderView.vc = self
        //DESIGNSET
        sliderView.borderWidth = 1; sliderView.borderColor = .red; sliderView.topDownWhide = 4; sliderView.sideWhide = 8; sliderView.opacity = 0.7
        sliderView.setVideoModel.setURL(url: url, sliderView: sliderView, heightY: 0, height: 100)
    }
}
