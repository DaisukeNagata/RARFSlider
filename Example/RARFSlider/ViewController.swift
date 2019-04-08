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

    var sliderView = RARFSliderView()
    var setVideoModel = RARFMaskVideoModel()


    override func viewDidLoad() {
        super.viewDidLoad()

        let imagePickerModel = RARFImagePickerModel()
        imagePickerModel.mediaSegue(vc: self, bool: true)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)

        if url != nil {
            //DESIGNSET
            guard let url = url else  { return }
            sliderView.removeFromSuperview()
            sliderView = RARFSliderView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
            view.addSubview(sliderView)
            sliderView.vc = self
            sliderView.borderWidth = 1; sliderView.borderColor = .red; sliderView.topDownWhide = 4; sliderView.sideWhide = 8
            sliderView.url = url; sliderView.aVPlayerModel.video(url: url)
            sliderView.slider.isHidden = true
            sliderView.timeLabel.frame = CGRect(x: 0, y: view.frame.height/2-100, width: 200, height: 100)
            sliderView.durationLabel.frame = CGRect(x: 0, y: view.frame.height/2-200, width: 200, height: 100)
            sliderView.preView.frame = CGRect(x: 0, y: 100, width: view.frame.width, height: 100)
            setVideoModel.setURL(url: url, sliderView: sliderView, heightY: 100, height: 100)
        }
    }
}
