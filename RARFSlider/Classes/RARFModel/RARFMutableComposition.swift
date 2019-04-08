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

class RARFMutableComposition: NSObject {

    let mixComposition = AVMutableComposition()
    var vc = UIViewController()

    func aVAssetMerge(startAVAsset: AVAsset, startDuration: CMTime, endDuration: CMTime, vc: UIViewController) {
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

        aVAssetExportSet(mainComposition: mainCompositions)
    }

    func aVAssetExportSet(mainComposition: AVMutableVideoComposition) {

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
            self.alertSave(views: self.vc, exporter: exporter, url: url)
        }
    }

    func exportDidFinish(_ session: AVAssetExportSession, url: URL) {

        guard session.status == AVAssetExportSession.Status.completed, let outputURL = session.outputURL else { return }

        let saveVideoToPhotos = {
            PHPhotoLibrary.shared().performChanges({ PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: outputURL) }) {
                saved, error in
                if saved == true {
                if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
                    let pic = UIImagePickerController()
                    pic.mediaTypes = [kUTTypeMovie as String]
                    pic.allowsEditing = false
                    pic.delegate = (self.vc as! UIImagePickerControllerDelegate & UINavigationControllerDelegate)
                    self.vc.present(pic, animated: true)
                    }
                } else {
                    self.alertSave(views: self.vc)
                }
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

    func alertSave(views: UIViewController ,exporter: AVAssetExportSession ,url: URL) {
        let alertController = UIAlertController(title: NSLocalizedString("Save", comment: ""), message: "", preferredStyle: .alert)
        let stringAttributes: [NSAttributedString.Key : Any] = [
            .foregroundColor : UIColor(red: 0/255, green: 136/255, blue: 83/255, alpha: 1.0),
            .font : UIFont.systemFont(ofSize: 22.0)
        ]
        let string = NSAttributedString(string: alertController.title!, attributes:stringAttributes)
        alertController.setValue(string, forKey: "attributedTitle")
        alertController.view.tintColor = UIColor(red: 0/255, green: 136/255, blue: 83/255, alpha: 1.0)
        let noBt = UIAlertAction(title: "No", style: .default) {
            action in
            alertController.dismiss(animated: true, completion: nil)
        }
        let okBt = UIAlertAction(title: "OK", style: .default) {
            action in
            alertController.dismiss(animated: true, completion: nil)
            DispatchQueue.main.async { self.exportDidFinish(exporter, url: url)}
        }
         alertController.addAction(noBt)
         alertController.addAction(okBt)
         views.present(alertController, animated: true, completion: nil)
    }
    
    func alertSave(views: UIViewController) {
        let alertController = UIAlertController(title: NSLocalizedString("Faled", comment: ""), message: "", preferredStyle: .alert)
        let stringAttributes: [NSAttributedString.Key : Any] = [
            .foregroundColor : UIColor(red: 0/255, green: 136/255, blue: 83/255, alpha: 1.0),
            .font : UIFont.systemFont(ofSize: 22.0)
        ]
        let string = NSAttributedString(string: alertController.title!, attributes:stringAttributes)
        alertController.setValue(string, forKey: "attributedTitle")
        alertController.view.tintColor = UIColor(red: 0/255, green: 136/255, blue: 83/255, alpha: 1.0)
        let okBt = UIAlertAction(title: "OK", style: .default) {
            action in
            alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(okBt)
        views.present(alertController, animated: true, completion: nil)
    }
}
