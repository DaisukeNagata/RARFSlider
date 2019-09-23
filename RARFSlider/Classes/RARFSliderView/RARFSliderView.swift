//
//  RARFSliderView.swift
//  RARFSlider
//
//  Created by 永田大祐 on 2019/02/28.
//  Copyright © 2019 永田大祐. All rights reserved.
//

import UIKit
import AVFoundation


@available(iOS 13.0, *)
public final class RARFSliderView: UIView, UIGestureRecognizerDelegate {

    @IBOutlet public weak var rARFSlider: UISlider?

    @IBOutlet public weak var rARFTimeLabel: UILabel?
    @IBOutlet public weak var rARFDurationLabel: UILabel?

    @IBOutlet public weak var rARFPicBt: UIButton?
    @IBOutlet public weak var rARFTrimButton: UIButton?
    @IBOutlet public weak var rARFMergeButton: UIButton?
    @IBOutlet public weak var rARFInsideTrimButton: UIButton?

    @IBOutlet public weak var rARFPreView: RARFPreView?
    @IBOutlet public weak var rARFLargePreView: UIImageView?
    @IBOutlet public weak var rARFThumnaiIImageView: UIImageView?

    public var rARFUrl: URL?
    public var rARFVc: UIViewController?
    public var rARFOpacity: Float = 0.0
    public var rARFSideWhide: CGFloat = 0.0
    public var rARFBorderWidth: CGFloat = 0.0
    public var rARFTopDownWhide: CGFloat = 0.0
    public var rARFBorderColor: UIColor = .white
    public var rARFAVPlayerModel = RARFAVPlayerModel()
    public var rARFSetVideoModel = RARFMaskVideoModel()

    private var endValue: Float?
    private var startValue: Float?
    private var nowTime = CGFloat()
    private var currentValue = Float()
    private var alert = RARFAlertObject()
    private var rARFDef = RARFUserDefaults()
    private var cALayerView = RARFCALayerView()
    private var lineDashView = RARFLineDashView()
    private var gestureObject = RARFGestureObject()
    private var touchFlag = TouchFlag.touchSideLeft
    private var mutableComposition = RARFMutableComposition()


    public override init(frame: CGRect) {
        super.init(frame: frame)

        loadNib()

        guard
            let rARFPicBt = rARFPicBt,
            let rARFSlider = rARFSlider,
            let rARFPreView = rARFPreView,
            let rARFTrimButton = rARFTrimButton,
            let rARFMergeButton = rARFMergeButton,
            let rARFLargePreView = rARFLargePreView,
            let rARFInsideTrimButton = rARFInsideTrimButton else {
            return
        }
        
        rARFPicBt.addTarget(self, action: #selector(pickBt), for: .touchUpInside)
        rARFTrimButton.addTarget(self, action: #selector(trimBt), for: .touchUpInside)
        rARFMergeButton.addTarget(self, action: #selector(mergeBt), for: .touchUpInside)
        rARFSlider.addTarget(self, action: #selector(onChange(change:)), for: .valueChanged)
        rARFInsideTrimButton.addTarget(self, action: #selector(insideTrimBt), for: .touchUpInside)

        RARFStructure.swipePanGesture = UIPanGestureRecognizer(target: self, action:#selector(panTapped))
        RARFStructure.swipePanGesture.delegate = self
        self.addGestureRecognizer(RARFStructure.swipePanGesture)

        rARFPreView.backgroundColor = UIColor.clear
        rARFPreView.layer.addSublayer(cALayerView.hollowTargetLayer)
        rARFPreView.addSubview(cALayerView)
        rARFPreView.addSubview(lineDashView)

        self.sendSubviewToBack(rARFLargePreView)

        startValue =  0

        guard rARFDef.loadMethod(st:"pathFileNameSecound") == nil else {
            rARFDef.removeMethod(st:"pathFileNameOne")
            rARFDef.removeMethod(st:"pathFileNameSecound")
            return
        }

        self.cALayerView.tori(views: self.lineDashView,
                              sideWhide: self.rARFSideWhide,
                              topDownWhide: self.rARFTopDownWhide,
                              borderWidth: self.rARFBorderWidth,
                              borderColor: self.rARFBorderColor,
                              opacity: self.rARFOpacity)
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        loadNib()
    }

    public func imagePick(vc: UIViewController,callBack: @escaping () -> Void) -> Void {
        let imagePickerModel = RARFImagePickerModel()
        imagePickerModel.mediaSegue(vc: vc, bool: true)
        RARFStructure.callBack = callBack
    }

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let position: CGPoint = touch.location(in: self)
        gestureObject.framePoint = position
        return true
    }

    func loadNib() {
        let bundle = Bundle(for: RARFSliderView.self)
        let view = bundle.loadNibNamed("RARFSliderView", owner: self, options: nil)?.first as! UIView
        view.frame = UIScreen.main.bounds
        self.addSubview(view)
    }

    @objc func panTapped(sender: UIPanGestureRecognizer) {

        guard
            let rARFSlider = rARFSlider,
            let rARFPreView = rARFPreView else {
                return
        }

        let position: CGPoint = sender.location(in: self)
        let value = Float64(position.x) * (self.rARFAVPlayerModel.videoDurationTime() / Float64(self.frame.width))

        switch sender.state {
        case .ended:
            switch self.touchFlag {
            case .touchSideRight:
                self.endValue = Float(value)
                break
            case .touchSideLeft:
                self.startValue = Float(value)
                break
            case .none:
                break
            }
            break
        case .possible   : break
        case .began      : break
        case .changed    : break
        case .cancelled  : break
        case .failed     : break
        @unknown default : break
        }
        DispatchQueue.main.async {
            //Gesture
            self.gestureObject.endPoint = self.lineDashView.frame.origin
            self.gestureObject.endFrame = self.lineDashView.frame
            self.touchFlag = self.gestureObject.cropEdgeForPoint(point: self.gestureObject.framePoint, views: rARFPreView)
            self.gestureObject.updatePoint(point: position, views: self.lineDashView, touchFlag: self.touchFlag)
            rARFSlider.value = Float(value)
            self.ges(value: Float(value))
            self.cALayerView.tori(views: self.lineDashView, sideWhide: self.rARFSideWhide, topDownWhide: self.rARFTopDownWhide, borderWidth: self.rARFBorderWidth, borderColor: self.rARFBorderColor, opacity: self.rARFOpacity)
        }
    }

    @objc func pickBt() {
        let imagePickerModel = RARFImagePickerModel()
        guard let vc = rARFVc else { return }

        imagePickerModel.mediaSegue(vc: vc, bool: true)
    }

    // Duration and origin
    @objc func onChange(change: UISlider) { ges(value: change.value) }

    @objc func mergeBt() {
        guard let startValue = startValue, let endValue = endValue, let vc = rARFVc else { return }
        guard let urlOne = rARFDef.loadMethod(st: "pathFileNameOne") else { alert.alertSave(views: vc); return}
        guard let urlSecound = rARFDef.loadMethod(st: "pathFileNameSecound") else { alert.alertSave(views: vc); return }

        let avAsset = AVAsset(url: urlOne)
        let avAssetSecound = AVAsset(url: urlSecound)
        let timeSet = endValue - startValue
        let startTime = CMTime(seconds: Float64(startValue), preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        let endTime = CMTime(seconds: Float64(timeSet), preferredTimescale: CMTimeScale(NSEC_PER_SEC))

        mutableComposition.aVAssetMerge(vc: vc, title: "Merge", aVAsset: avAsset, aVAssetSecound: avAssetSecound, startDuration: startTime, endDuration: endTime)
    }

    @objc func trimBt() {

        if endValue == nil {
            let currentTime = rARFAVPlayerModel.videoDurationTime()
            endValue = Float(currentTime)
        }

        guard let urs = rARFUrl, let startValue = startValue, let endValue = endValue, let vc = rARFVc else { return }

        let avAsset = AVAsset(url: urs)
        let timeSet = endValue - startValue
        let startTime = CMTime(seconds: Float64(startValue), preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        let endTime = CMTime(seconds: Float64(timeSet), preferredTimescale: CMTimeScale(NSEC_PER_SEC))

        mutableComposition.aVAssetMerge(vc: vc, title: "Saved", startAVAsset: avAsset, startDuration: startTime, endDuration: endTime)
    }

    @objc func insideTrimBt() {

        if endValue == nil {
            let currentTime = rARFAVPlayerModel.videoDurationTime()
            endValue = Float(currentTime)
        }

        guard let urs = rARFUrl, let startValue = startValue, let endValue = endValue, let vc = rARFVc else { return }

        let avAsset = AVAsset(url: urs)
        let currentTime = rARFAVPlayerModel.videoDurationTime()
        let startTime = CMTime(seconds: Float64(startValue), preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        let endTime = CMTime(seconds: Float64(endValue), preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        let totalTime = CMTime(seconds: Float64(currentTime), preferredTimescale: CMTimeScale(NSEC_PER_SEC))

        mutableComposition.aVAssetInsideOut(vc: vc, title: "Inside Out", aVAsset: avAsset, startDuration: startTime, endDuration: endTime, totalDuration: totalTime)
    }

    private func ges(value: Float) {
        guard
            let rARFSlider = rARFSlider,
            let rARFTimeLabel = rARFTimeLabel,
            let rARFLargePreView = rARFLargePreView,
            let rARFDurationLabel = rARFDurationLabel,
            let rARFThumnaiIImageView = rARFThumnaiIImageView else {
                return
        }
        let currentTime = rARFAVPlayerModel.videoDurationTime()
        rARFSlider.minimumValue = 0
        rARFSlider.maximumValue = Float(currentTime)

        let nowTime = rARFAVPlayerModel.currentTime()
        rARFTimeLabel.text = nowTime.description

        rARFDurationLabel.text = currentTime.description

        let currentValue = Float(UIScreen.main.bounds.width - rARFThumnaiIImageView.frame.width) / Float(currentTime)
        let changeOrigin = currentValue * Float(value)
        rARFAVPlayerModel.videoSeek(change: Float(value))

        rARFThumnaiIImageView.frame.origin.x = CGFloat(changeOrigin)
        rARFThumnaiIImageView.image = rARFAVPlayerModel.videoImageViews(nowTime: nowTime)
        rARFLargePreView.image = rARFAVPlayerModel.videoImageViews(nowTime: nowTime)
    }
}
