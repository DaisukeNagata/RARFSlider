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

final class RARFMutableComposition: NSObject {

    private var vc = UIViewController()
    private var alert = RARFAlertObject()
    private let mixComposition = AVMutableComposition()

    func aVAssetMerge(vc: UIViewController, title: String,  startAVAsset: AVAsset, startDuration: CMTime, endDuration: CMTime) {
        self.vc = vc
        guard let firstTrack = mixComposition.addMutableTrack(withMediaType: .video,
                                                              preferredTrackID: Int32(kCMPersistentTrackID_Invalid)) else { return }
        do {
            try firstTrack.insertTimeRange(CMTimeRangeMake(start: startDuration, duration: endDuration),
                                           of: startAVAsset.tracks(withMediaType: .video)[0],
                                           at: CMTime.zero)
        } catch let error {
            print("Failed to load first track", error)
            return
        }

        let mainInstruction = AVMutableVideoCompositionInstruction()
        mainInstruction.timeRange = CMTimeRangeMake(start: CMTime.zero, duration: CMTimeAdd (startDuration, endDuration))

        let firstInstruction = videoCompositionInstruction(firstTrack, asset: startAVAsset)
        firstInstruction.setOpacity(0.0, at: endDuration)
        mainInstruction.layerInstructions = [firstInstruction]

        let mainCompositions = AVMutableVideoComposition()
        mainCompositions.instructions = [mainInstruction]
        mainCompositions.frameDuration = CMTimeMake(value: 1, timescale: 30)
        mainCompositions.renderSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)

        aVAssetExportSet(title: title, mainComposition: mainCompositions)
    }

    func aVAssetMerge(views: UIViewController, title: String, aVAsset: AVAsset, aVAssetSecound:AVAsset, startDuration: CMTime, endDuration: CMTime) {
        guard let firstTrack = mixComposition.addMutableTrack(withMediaType: .video,
                                                              preferredTrackID: Int32(kCMPersistentTrackID_Invalid)) else { return }
        do {
            try firstTrack.insertTimeRange(CMTimeRangeMake(start: CMTime.zero, duration: endDuration),
                                           of: aVAsset.tracks(withMediaType: .video)[0],
                                           at: CMTime.zero)
        } catch let error {
            print("Failed to load second track", error)
            return
        }

        guard let secondTrack = mixComposition.addMutableTrack(withMediaType: .video,
                                                               preferredTrackID: Int32(kCMPersistentTrackID_Invalid)) else { return }
        do {
            try secondTrack.insertTimeRange(CMTimeRangeMake(start: CMTime.zero, duration: endDuration),
                                            of: aVAssetSecound.tracks(withMediaType: .video)[0],
                                            at: aVAsset.duration)
        } catch let error {
            print("Failed to load second track", error)
            return
        }

        let mainInstruction = AVMutableVideoCompositionInstruction()
        mainInstruction.timeRange = CMTimeRangeMake(start: CMTime.zero, duration: CMTimeAdd (aVAsset.duration, aVAssetSecound.duration))

        let firstInstruction = videoCompositionInstruction(firstTrack, asset: aVAsset)
        firstInstruction.setOpacity(0.0, at: aVAsset.duration)

        let secondInstruction = videoCompositionInstruction(secondTrack, asset: aVAssetSecound)
        mainInstruction.layerInstructions = [firstInstruction,secondInstruction]

        let mainComposition = AVMutableVideoComposition()
        mainComposition.instructions = [mainInstruction]
        mainComposition.frameDuration = CMTimeMake(value: 1, timescale: 30)
        mainComposition.renderSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)

        aVAssetExportSet(title: title, mainComposition: mainComposition)
    }

    func aVAssetExportSet(title: String, mainComposition: AVMutableVideoComposition) {

        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short

        let date = dateFormatter.string(from: Date())
        let num = arc4random() % 100000000
        let url = documentDirectory.appendingPathComponent(num.description + "\(date)temp.mp4")

        guard let exporter = AVAssetExportSession(asset: mixComposition, presetName: AVAssetExportPresetHighestQuality) else { return }

        exporter.outputURL = url
        exporter.outputFileType = AVFileType.mov
        exporter.shouldOptimizeForNetworkUse = true
        exporter.videoComposition = mainComposition
        exporter.exportAsynchronously() {
            let rARFDef = RARFUserDefaults()
            rARFDef.saveMethod(url: exporter.outputURL)
            self.alert.alertSave(views: self.vc, title: title,exporter: exporter, composition: self, url: url)
        }
    }

    func exportDidFinish(_ session: AVAssetExportSession, url: URL) {
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

    func orientationFromTransform(_ transform: CGAffineTransform) -> (orientation: UIImage.Orientation, isPortrait: Bool) {

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

    func videoCompositionInstruction(_ track: AVCompositionTrack, asset: AVAsset) -> AVMutableVideoCompositionLayerInstruction {

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
            let scaleFactor = CGAffineTransform(scaleX: scaleToFitRatio, y: scaleToFitRatio)
            var concat = assetTrack.preferredTransform.concatenating(scaleFactor)
                .concatenating(CGAffineTransform(translationX: 0, y: 0))
    
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
