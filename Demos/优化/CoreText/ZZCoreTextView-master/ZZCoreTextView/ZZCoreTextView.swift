//
//  ZZCoreTextView.swift
//  ZZCoreTextView
//
//  Created by duzhe on 16/6/29.
//  Copyright © 2016年 dz. All rights reserved.
//

import UIKit

@IBDesignable
open class ZZCoreTextView: UIView {

    /// 文本
    @IBInspectable open var text: String = "" {
        didSet {
            self.setNeedsDisplay()
        }
    }

    fileprivate var fromNib = false
    fileprivate var urlTap: ((_ url: URL?) -> Void)?
    fileprivate var telTap: ((_ str: String) -> Void)?
    fileprivate var atTap: ((_ str: String) -> Void)?
    fileprivate var keyRect: [NSValue: String] = [:]
    fileprivate var keyAttributeArr: [String: String] = [:]
    fileprivate var keyDatas: [String] = []
    open var styleModel: ZZStyleModel
    fileprivate var firstRect = CGRect.zero
    fileprivate var selfHeight: CGFloat = 0

    fileprivate var currentRect: [CGRect] = []

    public override init(frame: CGRect) {
        styleModel = ZZStyleModel()
        super.init(frame: frame)
    }

    public required init?(coder aDecoder: NSCoder) {
        styleModel = ZZStyleModel()
        super.init(coder: aDecoder)
    }

    open override func awakeFromNib() {
        styleModel = ZZStyleModel()
        fromNib = true
        super.awakeFromNib()
    }

    open func handleUrlTap(_ urlTap: ((_ url: URL?) -> Void)?) {
        self.urlTap = urlTap
    }

    open func handleTelTap(_ telTap: ((_ str: String) -> Void)?) {
        self.telTap = telTap
    }

    open func handleAtTap(_ atTap: ((_ str: String) -> Void)?) {
        self.atTap = atTap
    }

    open override var intrinsicContentSize: CGSize {
        selfHeight = ZZUtil.getRowHeightWithText(text, rectSize: CGSize(width: self.bounds.width, height: 10000), styleModel: styleModel)
        return CGSize(width: UIView.noIntrinsicMetric, height: selfHeight)
    }

    open override func layoutSubviews() {
        // 通知系统改变 内建大小
        if fromNib {
            invalidateIntrinsicContentSize()
        }
        super.layoutSubviews()
    }

    open override func draw(_ rect: CGRect) {

        super.draw(rect)

        keyRect.removeAll()
        keyAttributeArr.removeAll()
        keyDatas.removeAll()
        //        let isAutoHeight = styleModel.isAutoHeight
        let font = styleModel.font
        //        let numberOfLines = styleModel.numberOfLines
        let lineSpace = styleModel.lineSpace

        let highlightBackgroundRadius = styleModel.highlightBackgroundRadius
        let highlightBackgroundColor = styleModel.highlightBackgroundColor

        let attrString = ZZUtil.createAttributedStringWithText(text, styleModel: styleModel)

        let textRun = ZZTextRun(styleModel: styleModel)
        textRun.runsWithAttrString(attrString)

        // 绘图
        guard let contextRef = UIGraphicsGetCurrentContext() else { return }
        if let color = backgroundColor?.cgColor {
            contextRef.setStrokeColor(color)
        }

        contextRef.textMatrix = .identity
        contextRef.translateBy(x: 0, y: bounds.height)
        contextRef.scaleBy(x: 1.0, y: -1.0)

        let viewRect = CGRect(x: 0, y: 0, width: bounds.width, height: 10000)

        // 创建一个用来描画文字的路径，其区域为当前视图的bounds  CGPath
        let pathRef = CGMutablePath()
        pathRef.addRect(viewRect)

        let framesetterRef = CTFramesetterCreateWithAttributedString(attrString as CFAttributedString)

        // 创建由framesetter管理的frame 是描画文字的一个视图范围 CTFrame
        let frameRef = CTFramesetterCreateFrame(framesetterRef, CFRangeMake(0, 0), pathRef, nil)

        let lines = CTFrameGetLines(frameRef)
        let lineCount = CFArrayGetCount(lines)

        var lineOrigins: [CGPoint] = Array(repeating: .zero, count: lineCount)
        CTFrameGetLineOrigins(frameRef, CFRangeMake(0, 0), &lineOrigins)

        // 绘制高亮区域
        if !currentRect.isEmpty {
            for rect in currentRect {
                let path = UIBezierPath(roundedRect: rect, cornerRadius: highlightBackgroundRadius).cgPath
                contextRef.setFillColor(highlightBackgroundColor.cgColor)
                contextRef.addPath(path)
                contextRef.fillPath()
            }
        }

        // ================================= 分割线 =====================================
        var frameY: CGFloat = 0
        let lineHeight = CGFloat(font.lineHeight + lineSpace)
        var prevImgRect: CGRect = CGRect.zero
        for i in 0 ..< lineCount {

            let lineRef = unsafeBitCast(CFArrayGetValueAtIndex(lines, i), to: CTLine.self)
            // 获得行首的CGPoint
            var lineOrigin = lineOrigins[i]

            frameY = bounds.height - CGFloat(i + 1) * lineHeight - font.descender
            lineOrigin.y = frameY

            contextRef.textPosition = lineOrigin
            CTLineDraw(lineRef, contextRef)

            let runs = CTLineGetGlyphRuns(lineRef)

            for j in 0 ..< CFArrayGetCount(runs) {

                let runRef = unsafeBitCast(CFArrayGetValueAtIndex(runs, j), to: CTRun.self)

                var runAscent: CGFloat = 0
                var runDescent: CGFloat = 0
                var runRect: CGRect = CGRect.zero

                runRect.size.width = CGFloat(CTRunGetTypographicBounds(runRef, CFRangeMake(0, 0), &runAscent, &runDescent, nil))
                runRect = CGRect(x: lineOrigin.x + CTLineGetOffsetForStringIndex(lineRef, CTRunGetStringRange(runRef).location, nil), y: lineOrigin.y, width: runRect.size.width, height: runAscent + runDescent)

                let attributes = CTRunGetAttributes(runRef) as? [String: Any]
                let keyAttribute = attributes?["keyAttribute"] as? String

                if let keyAttribute = keyAttribute {

                    var runAscent: CGFloat = 0
                    var runDescent: CGFloat = 0
                    let runWidth = CGFloat(CTRunGetTypographicBounds(runRef, CFRangeMake(0, 0), &runAscent, &runDescent, nil))
                    let runPointX = runRect.minX + lineOrigin.x
                    let runPointY = lineOrigin.y - styleModel.faceOffset

                    var rect = CGRect.zero

                    if keyAttribute.first == "U" && styleModel.urlShouldInstead {

                        if !keyDatas.contains(keyAttribute) {
                            let img = ZZAssets.hyperlinkImage
                            keyDatas.append(keyAttribute)

                            firstRect = CGRect(x: runPointX, y: runPointY - (lineHeight + styleModel.highlightBackgroundAdjustHeight - lineSpace) / 4 - styleModel.highlightBackgroundOffset, width: runWidth, height: lineHeight + styleModel.highlightBackgroundAdjustHeight)
                            // url

                            prevImgRect = CGRect(x: runPointX + 2, y: lineOrigin.y - ((lineHeight - styleModel.tagImgSize.height) / 4), width: styleModel.tagImgSize.width, height: styleModel.tagImgSize.height)
                            contextRef.draw(img.cgImage!, in: prevImgRect)

                        } else {
                            let tmpRect = CGRect(x: runPointX, y: runPointY - (lineHeight + styleModel.highlightBackgroundAdjustHeight - lineSpace) / 4 - styleModel.highlightBackgroundOffset, width: runWidth, height: lineHeight + styleModel.highlightBackgroundAdjustHeight)
                            if firstRect != CGRect.zero {
                                if abs(tmpRect.origin.y - firstRect.origin.y) > 5 {
                                    // 如果图片恰好没有到行末尾
                                    keyRect[NSValue(cgRect: firstRect)] = keyAttribute
                                    keyRect[NSValue(cgRect: tmpRect)] = keyAttribute
                                } else {
                                    rect = CGRect(x: firstRect.origin.x, y: firstRect.origin.y, width: firstRect.width + runWidth, height: firstRect.height)
                                }
                                firstRect = CGRect.zero
                            } else {
                                rect = tmpRect
                            }
                            keyRect[NSValue(cgRect: rect)] = keyAttribute
                        }

                    } else if keyAttribute.first == "T" || keyAttribute.first == "A" {

                        rect = CGRect(x: runPointX, y: runPointY - (lineHeight + styleModel.highlightBackgroundAdjustHeight - lineSpace) / 4 - styleModel.highlightBackgroundOffset, width: runWidth, height: lineHeight + styleModel.highlightBackgroundAdjustHeight)
                        keyRect[NSValue(cgRect: rect)] = keyAttribute
                    } else {
                        // 不修改文字的 url
                        rect = CGRect(x: runPointX, y: runPointY - (lineHeight + styleModel.highlightBackgroundAdjustHeight - lineSpace) / 4 - styleModel.highlightBackgroundOffset, width: runWidth, height: lineHeight + styleModel.highlightBackgroundAdjustHeight)
                        keyRect[NSValue(cgRect: rect)] = keyAttribute
                    }
                }
            }
        }
    }

    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        let touches = touches.first
        guard let location = touches?.location(in: self) else { return }
        let runLocation = CGPoint(x: location.x, y: frame.height - location.y)

        currentRect.removeAll()
        var keyAttr = ""
        keyRect.forEach { k, v in
            let rect = k.cgRectValue
            if rect.contains(runLocation) {
                keyAttr = v
            }
        }
        if !keyAttr.isEmpty {
            keyRect.forEach { k, v in
                if v == keyAttr {
                    currentRect.append(k.cgRectValue)
                }
            }
            setNeedsDisplay()
        }
    }

    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        keyRect.removeAll()
        currentRect.removeAll()
        setNeedsDisplay()
    }

    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        let touches = touches.first
        guard let location = touches?.location(in: self) else { return }
        let runLocation = CGPoint(x: location.x, y: frame.size.height - location.y)
        // 遍历 rect
        for (k, v) in keyRect {
            let rect = k.cgRectValue
            guard rect.contains(runLocation) && currentRect.contains(rect) else { continue }
            if v.hasPrefix("U") {
                // url 连接
                guard v.contains("{") else { continue }
                var url = v.split("{")[0].substring(from: 1)
                //                            print(url)
                if !url.hasPrefix("http") {
                    url = "https://\(url)"
                }
                self.urlTap?(URL(string: url))
            } else if v.hasPrefix("T") {
                let tel = v.split("{")[0].substring(from: 1)
                self.telTap?(tel)
            } else if v.hasPrefix("A") {
                let someOne = v.split("{")[0].substring(from: 1)
                self.atTap?(someOne)
            }
            // TODO: - 其他类型
        }
        if !currentRect.isEmpty {
            keyRect.removeAll()
            currentRect.removeAll()
            setNeedsDisplay()
        }
    }
}

extension String {
    /**
     字符串长度
     */
    public var length: Int {
        return self.count
    }

    /**
     是否包含某个字符串

     - parameter s: 字符串

     - returns: bool
     */
    func has(_ s: String) -> Bool {
        return range(of: s) != nil
    }

    /**
     分割字符

     - parameter s: 字符

     - returns: 数组
     */
    func split(_ s: String) -> [String] {
        if s.isEmpty {
            return []
        }
        return components(separatedBy: s)
    }

    /**
     去掉左右空格

     - returns: string
     */
    func trim() -> String {
        return trimmingCharacters(in: CharacterSet.whitespaces)
    }

    /**
     字符串替换

     - parameter old: 旧字符串
     - parameter new: 新字符串

     - returns: 替换后的字符串
     */
    func replace(_ old: String, new: String) -> String {
        return replacingOccurrences(of: old, with: new, options: NSString.CompareOptions.numeric, range: nil)
    }

    /**
     substringFromIndex  int版本

     - parameter index: 开始下标

     - returns: 截取后的字符串
     */
    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return substring(from: fromIndex)
    }

    /**
     substringToIndex int版本

     - parameter index: 介绍下标

     - returns: 截取后的字符串
     */
    func substring(to: Int) -> String {
        return substring(to: index(from: to))
    }

    func index(from: Int) -> Index {
        return index(startIndex, offsetBy: from)
    }

    /**
     substringWithRange int版本

     - parameter start: 开始下标
     - parameter end:   结束下标

     - returns: 截取后的字符串
     */
    func substring(fromIndex: Int, toIndex: Int) -> String {
        let range = NSRange(location: fromIndex, length: toIndex - fromIndex)
        return substr(with: range)
    }

    func substr(with range: NSRange) -> String {
        let start = index(startIndex, offsetBy: range.location)
        let end = index(endIndex, offsetBy: range.location + range.length - count)
        return substring(with: start ..< end)
    }
}

open class ZZAssets: NSObject {

    open class var hyperlinkImage: UIImage {
        return ZZAssets.bundledImage(named: "hyperlink")
    }

    internal class func bundledImage(named name: String) -> UIImage {
        let bundle = Bundle(for: ZZAssets.self)
        let image = UIImage(named: name, in: bundle, compatibleWith: nil)
        if let image = image {
            return image
        }

        return UIImage()
    }
}
