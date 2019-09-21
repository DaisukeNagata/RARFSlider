//
//  RARFGestureObject.swift
//  RARFSlider
//
//  Created by 永田大祐 on 2018/06/30.
//  Copyright © 2018年 永田大祐. All rights reserved.
//

import UIKit

enum TouchFlag { case none, touchSideLeft, touchSideRight }

final class RARFGestureObject: UIView {

    var endPoint = CGPoint()
    var endFrame = CGRect()
    var framePoint = CGPoint()


    func cropEdgeForPoint(point: CGPoint, views: UIView) -> TouchFlag {
        //タップした領域を取得
        let frame = views.frame

        var leftRect = frame
        leftRect.size.width = CGFloat(64)
        if leftRect.contains(point) { return TouchFlag.touchSideLeft }

        var rightRect = leftRect
        rightRect.origin.x = frame.maxX - CGFloat(64)
        if rightRect.contains(point) { return TouchFlag.touchSideRight }

        return TouchFlag.none
    }
    //タップされた領域からMaskするViewのサイズ、座標計算
    func updatePoint(point: CGPoint, views: UIView, touchFlag: TouchFlag)  {

        switch touchFlag {
        case .touchSideRight:
            views.frame.origin.x = point.x
            views.frame.size.width = -point.x + endFrame.minX
            break
        case .touchSideLeft:
            views.frame.origin.x =  point.x
            views.frame.size.width =  -point.x + endFrame.maxX
            break
        case .none: break
        }
        let kTOCropViewMinimumBoxSize = 22
        // フォーカスの最小枠と最大枠
        let minSize = CGSize(width: kTOCropViewMinimumBoxSize, height: kTOCropViewMinimumBoxSize)
        let maxSize = CGSize(width: views.frame.maxX, height: views.frame.maxY)

        views.frame.size.width  = max(views.frame.size.width, minSize.width)
        views.frame.size.height  = max(views.frame.size.height, minSize.height)

        views.frame.size.width  = min(views.frame.size.width, maxSize.width)
        views.frame.size.height  = min(views.frame.size.height, maxSize.height)

        views.frame.origin.x  = max(views.frame.origin.x, views.frame.minX)
        views.frame.origin.x = min(views.frame.origin.x, views.frame.maxX - minSize.width)

        views.frame.origin.y  = max(views.frame.origin.y, views.frame.minY)
        views.frame.origin.y  = min(views.frame.origin.y, views.frame.maxY - minSize.height)
    }
}
