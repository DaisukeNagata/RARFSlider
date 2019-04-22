//
//  RARFSliderView.swift
//  RARFSlider
//
//  Created by 永田大祐 on 2019/02/28.
//  Copyright © 2019 永田大祐. All rights reserved.
//

import UIKit
import AVFoundation

struct CommonStructure { static var swipePanGesture = UIPanGestureRecognizer() }

public final class RARFSliderView: UIView, UIGestureRecognizerDelegate {

    @IBOutlet public var picBt: UIButton!

    @IBOutlet public var slider: UISlider!

    @IBOutlet public var timeLabel: UILabel!
    @IBOutlet public var durationLabel: UILabel!

    @IBOutlet public var trimButton: UIButton!
    @IBOutlet public var mergeButton: UIButton!
    @IBOutlet public var insideTrimButton: UIButton!

    @IBOutlet public var preView: RARFPreView!
    @IBOutlet public var largePreView: UIImageView!
    @IBOutlet public var thumnaiIImageView: UIImageView!

    public var url: URL?
    public var vc: UIViewController?
    public var opacity: Float = 1.0
    public var sideWhide: CGFloat = 1.0
    public var borderWidth: CGFloat = 1.0
    public var topDownWhide: CGFloat = 1.0
    public var borderColor: UIColor = .white
    public var aVPlayerModel = RARFAVPlayerModel()
    public var setVideoModel = RARFMaskVideoModel()

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

        slider.addTarget(self, action: #selector(onChange(change:)), for: .valueChanged)
        picBt.addTarget(self, action: #selector(pickBt), for: .touchUpInside)

        trimButton.addTarget(self, action: #selector(trimBt), for: .touchUpInside)
        mergeButton.addTarget(self, action: #selector(mergeBt), for: .touchUpInside)
        insideTrimButton.addTarget(self, action: #selector(insideTrimBt), for: .touchUpInside)

        CommonStructure.swipePanGesture = UIPanGestureRecognizer(target: self, action:#selector(panTapped))
        CommonStructure.swipePanGesture.delegate = self
        self.addGestureRecognizer(CommonStructure.swipePanGesture)

        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
        self.addGestureRecognizer(tap)

        preView.backgroundColor = UIColor.clear
        preView.layer.addSublayer(cALayerView.hollowTargetLayer)
        preView.addSubview(cALayerView)
        preView.addSubview(lineDashView)
        
        largePreView.layer.borderWidth = 1
        largePreView.layer.borderColor = UIColor.white.cgColor
        self.sendSubviewToBack(largePreView)

        startValue =  0

        guard rARFDef.loadMethod(st:"pathFileNameSecound") == nil else {
            rARFDef.removeMethod(st:"pathFileNameOne")
            rARFDef.removeMethod(st:"pathFileNameSecound")
            return
        }

        self.cALayerView.tori(views: self.lineDashView,
                              sideWhide: self.sideWhide,
                              topDownWhide: self.topDownWhide,
                              borderWidth: self.borderWidth,
                              borderColor: self.borderColor,
                              opacity: self.opacity)
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        loadNib()
    }

    public func imagePick(vc: UIViewController) {
        let imagePickerModel = RARFImagePickerModel()
        imagePickerModel.mediaSegue(vc: vc, bool: true)
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

    @objc func tapped(sender: UITapGestureRecognizer) {
        if self.durationLabel.alpha == 0 {
            UIView.animate(withDuration: 2.0, delay: 1.0, options: [.curveEaseOut], animations: {
                self.picBt.alpha = 1
                self.slider.alpha = 1
                self.timeLabel.alpha = 1
                self.trimButton.alpha = 1
                self.mergeButton.alpha = 1
                self.durationLabel.alpha = 1
                self.insideTrimButton.alpha = 1
                self.thumnaiIImageView.alpha = 1
            }, completion: nil)
        } else {
            UIView.animate(withDuration: 2.0, delay: 1.0, options: [.curveEaseOut], animations: {
                self.picBt.alpha = 0
                self.slider.alpha = 0
                self.timeLabel.alpha = 0
                self.trimButton.alpha = 0
                self.mergeButton.alpha = 0
                self.durationLabel.alpha = 0
                self.insideTrimButton.alpha = 0
                self.thumnaiIImageView.alpha = 0
            }, completion: nil)
        }
    }

    @objc func panTapped(sender: UIPanGestureRecognizer) {

        let position: CGPoint = sender.location(in: self)
        let value = Float64(position.x) * (self.aVPlayerModel.videoDurationTime() / Float64(self.frame.width))

        self.cALayerView.tori(views: self.lineDashView, sideWhide: self.sideWhide, topDownWhide: self.topDownWhide, borderWidth: self.borderWidth, borderColor: self.borderColor, opacity: self.opacity)

        DispatchQueue.main.async {
            //Gesture
            self.gestureObject.endPoint = self.lineDashView.frame.origin
            self.gestureObject.endFrame = self.lineDashView.frame
            self.touchFlag = self.gestureObject.cropEdgeForPoint(point: self.gestureObject.framePoint, views: self.preView)
            self.gestureObject.updatePoint(point: position, views: self.lineDashView, touchFlag: self.touchFlag)
            self.slider.value = Float(value)
            self.ges(value: Float(value))
        }

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
        case .possible:
            break
        case .began:
            break
        case .changed:
            break
        case .cancelled:
            break
        case .failed:
            break
        @unknown default:
            break
        }
    }

    @objc func pickBt() {
        let imagePickerModel = RARFImagePickerModel()
        guard let vc = vc else { return }

        imagePickerModel.mediaSegue(vc: vc, bool: true)
    }

    // Duration and origin
    @objc func onChange(change: UISlider) { ges(value: change.value) }

    @objc func mergeBt() {
        guard let startValue = startValue, let endValue = endValue, let vc = vc else { return }
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
            let currentTime = aVPlayerModel.videoDurationTime()
            endValue = Float(currentTime)
        }

        guard let urs = url, let startValue = startValue, let endValue = endValue, let vc = vc else { return }

        let avAsset = AVAsset(url: urs)
        let timeSet = endValue - startValue
        let startTime = CMTime(seconds: Float64(startValue), preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        let endTime = CMTime(seconds: Float64(timeSet), preferredTimescale: CMTimeScale(NSEC_PER_SEC))

        mutableComposition.aVAssetMerge(vc: vc, title: "Saved", startAVAsset: avAsset, startDuration: startTime, endDuration: endTime)
    }

    @objc func insideTrimBt() {

        if endValue == nil {
            let currentTime = aVPlayerModel.videoDurationTime()
            endValue = Float(currentTime)
        }

        guard let urs = url, let startValue = startValue, let endValue = endValue, let vc = vc else { return }

        let avAsset = AVAsset(url: urs)
        let currentTime = aVPlayerModel.videoDurationTime()
        let startTime = CMTime(seconds: Float64(startValue), preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        let endDuration = CMTime(seconds: Float64(endValue), preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        let totalTime = CMTime(seconds: Float64(Float(currentTime)), preferredTimescale: CMTimeScale(NSEC_PER_SEC))

        mutableComposition.aVAssetInsideOut(vc: vc, title: "Inside Out", aVAsset: avAsset, startDuration: startTime, endDuration: endDuration, totalDuration: totalTime)
    }

    private func ges(value: Float) {

        let currentTime = aVPlayerModel.videoDurationTime()
        slider.minimumValue = 0
        slider.maximumValue = Float(currentTime)

        let nowTime = aVPlayerModel.currentTime()
        timeLabel.text = nowTime.description

        durationLabel.text = currentTime.description

        let currentValue = Float(UIScreen.main.bounds.width - thumnaiIImageView.frame.width) / Float(currentTime)
        let changeOrigin = currentValue * Float(value)
        aVPlayerModel.videoSeek(change: Float(value))

        thumnaiIImageView.frame.origin.x = CGFloat(changeOrigin)
        thumnaiIImageView.image = aVPlayerModel.videoImageViews(nowTime: nowTime)
        largePreView.image = aVPlayerModel.videoImageViews(nowTime: nowTime)
    }
}
