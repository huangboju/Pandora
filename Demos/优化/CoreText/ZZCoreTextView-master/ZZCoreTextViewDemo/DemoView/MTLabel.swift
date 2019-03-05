//
//  MTLabel.swift
//  ZZCoreTextView
//
//  Created by 伯驹 黄 on 2017/3/30.
//  Copyright © 2017年 dz. All rights reserved.
//

import UIKit

class MTLabel: UIView {

    /// Default 16 systemFont
    var topFont = UIFont.systemFont(ofSize: 16)

    /// Default 16 systemFont
    var bottomFont = UIFont.systemFont(ofSize: 16)

    /// Default UIColor.darkText
    var topColor = UIColor.red

    /// Default UIColor.darkText
    var bottomColor = UIColor.blue

    /// Default 15
    var lineSpacing: CGFloat = 15

    var textAliment: NSTextAlignment = .center

    var topText = ""
    var bottomText = ""

    init(frame: CGRect, aliment: NSTextAlignment) {
        super.init(frame: frame)
        backgroundColor = .clear
        textAliment = aliment
    }

    func setContent(_ content: (String, String)) {
        topText = content.0
        bottomText = content.1
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        guard !topText.isEmpty && !bottomText.isEmpty else {
            return
        }
        // 1 获取上下文
        guard let context = UIGraphicsGetCurrentContext() else { return }
        // 转换坐标
        context.convertFrameWithY(bounds.height)
        // 绘制区域
        let path = UIBezierPath(rect: bounds)

        let attrString = topText + "\n" + bottomText
        let mutableAttrStr = NSMutableAttributedString(string: attrString)

        let topRange = NSRange(location: 0, length: topText.length)

        mutableAttrStr.addAttributes([
            NSAttributedString.Key.font: topFont,
            NSAttributedString.Key.foregroundColor: topColor
            ], range: topRange)

        let bottomRange = NSRange(location: topText.length + 1, length: bottomText.length)
        mutableAttrStr.addAttributes([
            NSAttributedString.Key.font: bottomFont,
            NSAttributedString.Key.foregroundColor: bottomColor
            ], range: bottomRange)

        // http://www.jianshu.com/p/ab6d3cc13c56


        // 添加对齐方式
        var alignment: CTTextAlignment = .right

        let settings = [
            CTParagraphStyleSetting(spec: .lineSpacingAdjustment, valueSize: MemoryLayout<CGFloat>.size, value: &lineSpacing),
            CTParagraphStyleSetting(spec: .alignment, valueSize: MemoryLayout.size(ofValue: alignment), value: &alignment)
        ]
        let style = CTParagraphStyleCreate(settings, settings.count)

        let attributes: [NSAttributedString.Key : Any] = [kCTParagraphStyleAttributeName as NSAttributedString.Key: style]
        mutableAttrStr.addAttributes(attributes, range: NSRange(location: 0, length: mutableAttrStr.length))


        // 5 设置frame
        let framesetter = CTFramesetterCreateWithAttributedString(mutableAttrStr)
        let frame = CTFramesetterCreateFrame(framesetter, CFRange(location: 0, length: mutableAttrStr.length), path.cgPath, nil)

        // 6 取出CTLine 准备一行一行绘制
        let lines = CTFrameGetLines(frame)
        let lineCount = CFArrayGetCount(lines)
        var lineOrigins: [CGPoint] = Array(repeating: .zero, count: lineCount)

        // 把frame里每一行的初始坐标写到数组里，注意CoreText的坐标是左下角为原点
        CTFrameGetLineOrigins(frame, CFRange(location: 0, length: 0), &lineOrigins)
        let px = 1 / UIScreen.main.scale
        for i in 0 ..< lineCount {

            let lineRef = unsafeBitCast(CFArrayGetValueAtIndex(lines, i), to: CTLine.self)

            var lineAscent: CGFloat = 0
            var lineDescent: CGFloat = 0
            var leading: CGFloat = 0
            // 该函数除了会设置好ascent,descent,leading之外，还会返回这行的宽度
            let width = CTLineGetTypographicBounds(lineRef, &lineAscent, &lineDescent, &leading)

            var lineOrigin = lineOrigins[i]

            // 与UIView坐标系保持一致
            lineOrigin.y += bounds.height - path.bounds.height

            switch textAliment {
            case .left:
                lineOrigin.x = px
            case .right:
                lineOrigin.x = abs(bounds.width - CGFloat(width)) - px + 3.333984375 * CGFloat(1 - i) // "\n"导致的误差
            case .center:
                lineOrigin.x = abs((bounds.width - CGFloat(width)) / 2)
            default:
                print("⚠️ textAliment does not exist")
                break
            }
            // 绘制
            context.textPosition = lineOrigin
            CTLineDraw(lineRef, context)
        }
    }
    
    var pathSize: CGSize {
        let topTextSize = topText.sizeWithConstrained(fromFont: topFont, lineSpace: 0)
        let bottomTextSize = bottomText.sizeWithConstrained(fromFont: bottomFont, lineSpace: 0)
        let fix = 4 + 1 / UIScreen.main.scale
        return CGSize(width: fix + max(topTextSize.width, bottomTextSize.width).flatSpecificScale, height: (topTextSize.height + bottomTextSize.height + lineSpacing + fix).flatSpecificScale)
    }

    override func sizeToFit() {
        super.sizeToFit()
        var rect = frame
        rect.size = pathSize
        frame = rect
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension String {
    func sizeWithConstrained(to size: CGSize, fromFont font1: UIFont, lineSpace: CGFloat) -> CGSize {
        var minimumLineHeight = font1.pointSize
        var maximumLineHeight = minimumLineHeight
        var linespace = lineSpace
        var lineBreakMode = CTLineBreakMode.byWordWrapping

        //Apply paragraph settings
        var alignment: CTTextAlignment = .left
        let alignmentSetting = [
            CTParagraphStyleSetting(spec: .alignment, valueSize: MemoryLayout.size(ofValue: alignment), value: &alignment),
            CTParagraphStyleSetting(spec: .minimumLineHeight, valueSize: MemoryLayout.size(ofValue: minimumLineHeight), value: &minimumLineHeight),
            CTParagraphStyleSetting(spec: .maximumLineHeight, valueSize: MemoryLayout.size(ofValue: maximumLineHeight), value: &maximumLineHeight),
            CTParagraphStyleSetting(spec: .maximumLineSpacing, valueSize: MemoryLayout.size(ofValue: linespace), value: &linespace),
            CTParagraphStyleSetting(spec: .minimumLineSpacing, valueSize: MemoryLayout.size(ofValue: linespace), value: &linespace),
            CTParagraphStyleSetting(spec: .lineBreakMode, valueSize: MemoryLayout.size(ofValue: 1), value: &lineBreakMode)
        ]

        // 设置文本段落排版格式
        let style = CTParagraphStyleCreate(alignmentSetting, alignmentSetting.count)
        let attributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.font: font1,
            NSAttributedString.Key.paragraphStyle: style
        ]

        let string = NSMutableAttributedString(string: self, attributes: attributes)
        let attributedString = string as CFAttributedString
        let framesetter = CTFramesetterCreateWithAttributedString(attributedString)
        let result = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, string.length), nil, size, nil)
        return result
    }

    func sizeWithConstrained(fromFont font1: UIFont, lineSpace: CGFloat = 0) -> CGSize {
        return sizeWithConstrained(to: CGSize(width: .max, height: .max), fromFont: font1, lineSpace: lineSpace)
    }
}

extension CGFloat {
    /**
     *  基于指定的倍数，对传进来的 floatValue 进行像素取整。若指定倍数为0，则表示以当前设备的屏幕倍数为准。
     *
     *  例如传进来 “2.1”，在 2x 倍数下会返回 2.5（0.5pt 对应 1px），在 3x 倍数下会返回 2.333（0.333pt 对应 1px）。
     */
    var flatSpecificScale: CGFloat {
        let s = UIScreen.main.scale
        return ceil(self * s) / s
    }
}



