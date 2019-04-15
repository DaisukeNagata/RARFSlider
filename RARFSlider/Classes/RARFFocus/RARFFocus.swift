//
//  RARFCALayerView.swift
//  RARFSlider
//
//  Created by 永田大祐 on 2018/06/30.
//  Copyright © 2018年 永田大祐. All rights reserved.
//

import UIKit

final class RARFCALayerView: UIView {

    var path =  UIBezierPath()
    let maskLayer = CAShapeLayer()
    let hollowTargetLayer = CALayer()

    private let girdRightOutView = UIView()
    private let girdRightInView = UIView()
    private let girdLeftOutView = UIView()
    private let girdLeftInView = UIView()
    private let girdTopOutView = UIView()
    private let girdBottomOutView = UIView()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.addSubview(girdRightOutView)
        self.addSubview(girdRightInView)
        self.addSubview(girdLeftOutView)
        self.addSubview(girdLeftInView)
        self.addSubview(girdTopOutView)
        self.addSubview(girdBottomOutView)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func tori(views: UIView,sideWhide: CGFloat, topDownWhide: CGFloat,borderWidth: CGFloat,borderColor: UIColor ){
        views.layer.borderWidth = borderWidth
        views.layer.borderColor = borderColor.cgColor
        hollowTargetLayer.bounds = UIScreen.main.bounds
        hollowTargetLayer.frame.size.height = views.frame.height
        hollowTargetLayer.position = CGPoint(
            x: hollowTargetLayer.frame.width / 2.0,
            y: (hollowTargetLayer.bounds.height) / 2.0
        )

        hollowTargetLayer.backgroundColor = UIColor.black.cgColor
        hollowTargetLayer.opacity = 0.7

        maskLayer.bounds = hollowTargetLayer.bounds

        path =  UIBezierPath.init(rect: views.frame)
        path.append(UIBezierPath(rect: maskLayer.bounds))

        maskLayer.fillColor = UIColor.black.cgColor
        maskLayer.path = path.cgPath
        maskLayer.position = CGPoint(
            x: hollowTargetLayer.bounds.width / 2.0,
            y: (hollowTargetLayer.bounds.height / 2.0)
        )

        maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
        hollowTargetLayer.mask = maskLayer

        girdRightInView.backgroundColor = UIColor.red
        girdRightInView.frame = CGRect(x: views.frame.origin.x - sideWhide/2, y: views.frame.origin.y, width: sideWhide, height: views.frame.height)

        girdRightOutView.backgroundColor = UIColor.red
        girdRightOutView.frame = CGRect(x: views.frame.origin.x + sideWhide/2, y: views.frame.origin.y, width: sideWhide, height: views.frame.height)

        girdLeftInView.backgroundColor = UIColor.red
        girdLeftInView.frame = CGRect(x: views.frame.width + views.frame.origin.x - sideWhide/2, y: views.frame.origin.y, width: sideWhide, height: views.frame.height)

        girdLeftOutView.backgroundColor = UIColor.red
        girdLeftOutView.frame = CGRect(x: views.frame.width + views.frame.origin.x + sideWhide/2, y: views.frame.origin.y, width: sideWhide, height: views.frame.height)

        girdTopOutView.backgroundColor = UIColor.red
        girdTopOutView.frame = CGRect(x: views.frame.origin.x - sideWhide/2, y: views.frame.origin.y - topDownWhide/2, width: views.frame.width + sideWhide*2, height: topDownWhide)

        girdBottomOutView.backgroundColor = UIColor.red
        girdBottomOutView.frame = CGRect(x: views.frame.origin.x - sideWhide/2, y: views.frame.height, width: views.frame.width + sideWhide*2, height: topDownWhide)
    }
}
