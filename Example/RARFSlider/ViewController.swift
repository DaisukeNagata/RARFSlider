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

        let imagePickerModel = RARFImagePickerModel()
        imagePickerModel.mediaSegue(vc: self, bool: true)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)

        //DESIGNSET
        guard let url = url else  { return }
        sliderView.removeFromSuperview()
        sliderView = RARFSliderView(frame: CGRect(x: 0, y: 100, width: view.frame.width, height: view.frame.height))
        view.addSubview(sliderView)
        sliderView.vc = self
        sliderView.slider.isHidden = false
        sliderView.borderWidth = 1; sliderView.borderColor = .red; sliderView.topDownWhide = 4; sliderView.sideWhide = 8
        sliderView.url = url; sliderView.aVPlayerModel.video(url: url)
        sliderView.preView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 100)
        sliderView.setVideoModel.setURL(url: url, sliderView: sliderView, heightY: 0, height: 100)
    }
}
