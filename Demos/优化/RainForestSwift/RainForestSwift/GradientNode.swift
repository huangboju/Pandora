//
//  GradientNode.swift
//  AsyncDisplay
//
//  Created by 伯驹 黄 on 2017/4/20.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import AsyncDisplayKit

class GradientNode: ASDisplayNode {
    static func draw(rect: CGRect, with parameters: Any, isCancelled:asdisplaynode_iscancelled_block_t, isRasterizing: Bool) {
        guard let myContext = UIGraphicsGetCurrentContext() else { return }
        myContext.saveGState()
        myContext.clip(to: rect)

        let componentCount = 2

        let zero: CGFloat = 0.0
        let one: CGFloat = 1.0
        let locations: [CGFloat] = [zero, one]
        let components: [CGFloat] = [zero, zero, zero, one, zero, zero, zero, zero]

        let myColorSpace = CGColorSpaceCreateDeviceRGB()
        let myGradient = CGGradient(colorSpace: myColorSpace, colorComponents: components, locations: locations, count: componentCount)

        let myStartPoint = CGPoint(x: rect.midX, y: rect.maxY)
        let myEndPoint = CGPoint(x: rect.midX, y: rect.midY)

        myContext.drawLinearGradient(myGradient!, start: myStartPoint, end: myEndPoint, options: .drawsAfterEndLocation)

        myContext.restoreGState()
    }
}
