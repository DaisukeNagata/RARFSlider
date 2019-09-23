//
//  RARFMutableComposition.swift
//  RARFSlider
//
//  Created by 永田大祐 on 2019/03/31.
//  Copyright © 2019 永田大祐. All rights reserved.
//

import Foundation
import Photos
import MediaPlayer
import MobileCoreServices

@available(iOS 13.0, *)
final class RARFMutableComposition: NSObject {

    private var vc = UIViewController()
    private var alert = RARFAlertObject()
    private var mixComposition = AVMutableComposition()


    func aVAssetMerge(vc: UIViewController, title: String,  startAVAsset: AVAsset, startDuration: CMTime, endDuration: CMTime) {
        self.vc = vc
        guard let firstTrack = mixComposition.addMutableTrack(withMediaType: .video,
                                                              preferredTrackID: Int32(kCMPersistentTrackID_Invalid)) else { return }
        do {
            try firstTrack.insertTimeRange(CMTimeRangeMake(start: startDuration, duration: endDuration),
                                           of: startAVAsset.tracks(withMediaType: .video)[0],
                                           at: CMTime.zero)
        } catch let error { print(error,"error") }

        let mainInstruction = AVMutableVideoCompositionInstruction()
        mainInstruction.timeRange = CMTimeRangeMake(start: CMTime.zero, duration: CMTimeAdd (startDuration, endDuration))

        let firstInstruction = videoCompositionInstruction(firstTrack, asset: startAVAsset)
        firstInstruction.setOpacity(0.0, at: endDuration)
        mainInstruction.layerInstructions = [firstInstruction]

        mainCompositions(title: title, mainInstruction: mainInstruction)
    }

    func aVAssetMerge(vc: UIViewController, title: String, aVAsset: AVAsset, aVAssetSecound:AVAsset, startDuration: CMTime, endDuration: CMTime) {
        self.vc = vc
        guard let firstTrack = mixComposition.addMutableTrack(withMediaType: .video,
                                                              preferredTrackID: Int32(kCMPersistentTrackID_Invalid)) else { return }
        do {
            try firstTrack.insertTimeRange(CMTimeRangeMake(start: CMTime.zero, duration: endDuration),
                                           of: aVAsset.tracks(withMediaType: .video)[0],
                                           at: CMTime.zero)
        } catch let error { print(error,"error"); return }

        guard let secondTrack = mixComposition.addMutableTrack(withMediaType: .video,
                                                               preferredTrackID: Int32(kCMPersistentTrackID_Invalid)) else { return }
        guard aVAssetSecound.tracks(withMediaType: .video).count != 0 else {
            alert.alertSave(views: vc)
            return
        }

        do {
            try secondTrack.insertTimeRange(CMTimeRangeMake(start: CMTime.zero, duration: endDuration),
                                            of: aVAssetSecound.tracks(withMediaType: .video)[0],
                                            at: aVAssetSecound.duration)
        } catch let error { print(error,"error"); return }

        let mainInstruction = AVMutableVideoCompositionInstruction()
        mainInstruction.timeRange = CMTimeRangeMake(start: CMTime.zero, duration: CMTimeAdd (aVAsset.duration, aVAssetSecound.duration))

        let firstInstruction = videoCompositionInstruction(firstTrack, asset: aVAsset)
        firstInstruction.setOpacity(0.0, at: endDuration)

        let secondInstruction = videoCompositionInstruction(secondTrack, asset: aVAssetSecound)
        mainInstruction.layerInstructions = [firstInstruction,secondInstruction]

        mainCompositions(title: title, mainInstruction: mainInstruction)
    }

    func aVAssetInsideOut(vc: UIViewController, title: String, aVAsset: AVAsset, startDuration: CMTime, endDuration: CMTime, totalDuration: CMTime) {
        self.vc = vc
        guard let firstTrack = mixComposition.addMutableTrack(withMediaType: .video,
                                                              preferredTrackID: Int32(kCMPersistentTrackID_Invalid)) else { return }

        do {
            try firstTrack.insertTimeRange(CMTimeRangeMake(start: CMTime.zero, duration: startDuration),
                                           of: aVAsset.tracks(withMediaType: .video)[0],
                                           at: CMTime.zero)
        } catch let error { print(error,"error"); return }

        guard let secondTrack = mixComposition.addMutableTrack(withMediaType: .video,
                                                               preferredTrackID: Int32(kCMPersistentTrackID_Invalid)) else { return }

        let total = totalDuration - (endDuration - startDuration)
        do {
            try secondTrack.insertTimeRange(CMTimeRangeMake(start: endDuration-startDuration, duration: total),
                                            of: aVAsset.tracks(withMediaType: .video)[0],
                                            at: CMTime.zero)
        } catch let error { print(error,"error"); return }

        let mainInstruction = AVMutableVideoCompositionInstruction()
        mainInstruction.timeRange = CMTimeRangeMake(start: CMTime.zero, duration: total)

        let firstInstruction = videoCompositionInstruction(firstTrack, asset: aVAsset)
        firstInstruction.setOpacity(0.0, at: startDuration)

        let secondInstruction = videoCompositionInstruction(secondTrack, asset: aVAsset)

        mainInstruction.layerInstructions = [firstInstruction,secondInstruction]

        mainCompositions(title: title, mainInstruction: mainInstruction)
    }

    private func mainCompositions(title            : String,
                                  mainInstruction  : AVMutableVideoCompositionInstruction? = nil) {
        guard let main = mainInstruction else { return }

        let mainComposition = AVMutableVideoComposition()
        mainComposition.instructions = [main]
        mainComposition.frameDuration = CMTimeMake(value: 1, timescale: 30)
        mainComposition.renderSize = CGSize(width: ceil(UIScreen.main.bounds.width / 2) * 2, height: ceil(UIScreen.main.bounds.height / 2) * 2)

        aVAssetExportSet(title: title, mainComposition: mainComposition)
    }

    private func aVAssetExportSet(title: String, mainComposition: AVMutableVideoComposition) {

        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short

        let date = dateFormatter.string(from: Date())
        let num = arc4random() % 100000000
        let url = documentDirectory.appendingPathComponent(num.description + "\(date)temp.mov")

        guard let exporter = AVAssetExportSession(asset: mixComposition, presetName: AVAssetExportPresetHEVCHighestQualityWithAlpha) else { return }

        exporter.outputURL = url
        exporter.outputFileType = AVFileType.mov
        exporter.shouldOptimizeForNetworkUse = true
        exporter.videoComposition = mainComposition
        exporter.exportAsynchronously() {
            let rARFDef = RARFUserDefaults()
            rARFDef.saveMethod(url: exporter.outputURL)
            DispatchQueue.main.async {
                self.alert.alertSave(views: self.vc, title: title,exporter: exporter, composition: self)
            }
        }
    }

    func exportDidFinish(_ session: AVAssetExportSession) {

        mixComposition = AVMutableComposition()
        guard session.status == AVAssetExportSession.Status.completed, let outputURL = session.outputURL else { return }
        let saveVideoToPhotos = {
            PHPhotoLibrary.shared().performChanges({ PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: outputURL) }) {
                saved, error in
                if saved == false { self.alert.alertSave(views: self.vc) }
            }
        }

        if PHPhotoLibrary.authorizationStatus() == .authorized {
            PHPhotoLibrary.requestAuthorization({ status in
                if status == .authorized {
                    saveVideoToPhotos()
                }
            })
        } else {
            saveVideoToPhotos()
        }
    }

    private func orientationFromTransform(_ transform: CGAffineTransform) -> (orientation: UIImage.Orientation, isPortrait: Bool) {

        var assetOrientation = UIImage.Orientation.up
        var isPortrait = false
        if transform.a == 0 && transform.b == 1.0 && transform.c == -1.0 && transform.d == 0 {
            assetOrientation = .right
            isPortrait = true
        } else if transform.a == 0 && transform.b == -1.0 && transform.c == 1.0 && transform.d == 0 {
            assetOrientation = .left
            isPortrait = true
        } else if transform.a == 1.0 && transform.b == 0 && transform.c == 0 && transform.d == 1.0 {
            assetOrientation = .up
        } else if transform.a == -1.0 && transform.b == 0 && transform.c == 0 && transform.d == -1.0 {
            assetOrientation = .down
        }
        return (assetOrientation, isPortrait)
    }

    private func videoCompositionInstruction(_ track: AVCompositionTrack, asset: AVAsset) -> AVMutableVideoCompositionLayerInstruction {

        let instruction = AVMutableVideoCompositionLayerInstruction(assetTrack: track)
        let assetTrack = asset.tracks(withMediaType: AVMediaType.video)[0]

        let transform = assetTrack.preferredTransform
        let assetInfo = orientationFromTransform(transform)
        var scaleToFitRatio = UIScreen.main.bounds.width / assetTrack.naturalSize.width

        if assetInfo.isPortrait {
            scaleToFitRatio = UIScreen.main.bounds.width / assetTrack.naturalSize.height
            let scaleFactor = CGAffineTransform(scaleX: scaleToFitRatio, y: scaleToFitRatio)
            instruction.setTransform(assetTrack.preferredTransform.concatenating(scaleFactor), at: CMTime.zero)
        } else {
            var concat = CGAffineTransform()
            let scaleFactor = CGAffineTransform(scaleX: scaleToFitRatio, y: scaleToFitRatio)

            if assetTrack.naturalSize.height > assetTrack.naturalSize.width {
                concat = assetTrack.preferredTransform.concatenating(scaleFactor)
                    .concatenating(CGAffineTransform(translationX: 0, y: 0))
            } else {
                concat = assetTrack.preferredTransform.concatenating(scaleFactor)
                    .concatenating(CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.height/2 - assetTrack.naturalSize.height/3))
            }
        
            if assetInfo.orientation == .down {
                let fixUpsideDown = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
                let windowBounds = UIScreen.main.bounds
                let yFix = assetTrack.naturalSize.height + windowBounds.height
                let centerFix = CGAffineTransform(translationX: assetTrack.naturalSize.width, y: yFix)
                concat = fixUpsideDown.concatenating(centerFix).concatenating(scaleFactor)
            }
            instruction.setTransform(concat, at: CMTime.zero)
        }
        return instruction
    }
}
