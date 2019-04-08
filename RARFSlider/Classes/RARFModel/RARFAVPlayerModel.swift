//
//  RARFAVPlayerModel.swift
//  RARFSlider
//
//  Created by 永田大祐 on 2019/03/10.
//  Copyright © 2019 永田大祐. All rights reserved.
//

import UIKit
import AVFoundation

public final class RARFAVPlayerModel {

    var url: URL?
    var videoPlayer: AVPlayer!
    var playerItem: AVPlayerItem?

    func currentTime() -> Float64 { return CMTimeGetSeconds((videoPlayer.currentItem?.currentTime())!) }

    func videoDurationTime() -> Float64 { return CMTimeGetSeconds((videoPlayer.currentItem?.duration)!) }

    func videoSeek(change: Float) { videoPlayer.seek(to:CMTimeMakeWithSeconds(Float64(change), preferredTimescale: Int32(NSEC_PER_SEC))) }

    public func video(url: URL) {
        self.url = url
        let avAsset = AVURLAsset(url: url, options: nil)
        playerItem = AVPlayerItem(asset: avAsset)
        videoPlayer = AVPlayer(playerItem: playerItem)
    }

    func videoImageViews(nowTime: Float64) -> UIImage {
        let interval = CMTime(seconds: nowTime, preferredTimescale: CMTimeScale(Int32(NSEC_PER_SEC)))
        guard  let url = url else { return UIImage() }
        return  thumbnailFromVideo(videoUrl: url, time: interval)
    }

    private func thumbnailFromVideo(videoUrl: URL, time: CMTime) -> UIImage {
        let asset: AVAsset = AVAsset(url: videoUrl) as AVAsset
        let imgGenerator = AVAssetImageGenerator(asset: asset)
        imgGenerator.appliesPreferredTrackTransform = true
        do{
            let cgImage = try imgGenerator.copyCGImage(at: time, actualTime: nil)
            let uiImage = UIImage(cgImage: cgImage)
            return uiImage
        } catch let error{ print(error,"error") }

        return UIImage()
    }
}
