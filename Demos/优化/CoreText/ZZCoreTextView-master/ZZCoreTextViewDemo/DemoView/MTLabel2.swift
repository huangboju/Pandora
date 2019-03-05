//
//  MTLabel2.swift
//  ZZCoreTextView
//
//  Created by 伯驹 黄 on 2017/4/24.
//  Copyright © 2017年 dz. All rights reserved.
//

import UIKit

// 行间距没有完成
class MTLabel2: UIView {
    override class var layerClass: AnyClass {
        return CATextLayer.self
    }

    private var textLayer: CATextLayer? {
        return layer as? CATextLayer
    }

    /// Default 14 systemFont
    var topFont = UIFont.systemFont(ofSize: 14)
    
    /// Default 14 systemFont
    var bottomFont = UIFont.systemFont(ofSize: 14)
    
    /// Default UIColor.darkText
    var topColor = UIColor.red
    
    /// Default UIColor.darkText
    var bottomColor = UIColor.blue
    
    /// Default 15
    var lineSpacing: CGFloat = 15
    
    var textAlignment: NSTextAlignment = .center
    
    private(set) var topText = ""
    private(set) var bottomText = ""

    convenience init(alignment: NSTextAlignment = .center) {
        self.init(frame: .zero, alignment: alignment)
    }

    init(frame: CGRect, alignment: NSTextAlignment = .center) {
        super.init(frame: frame)
        backgroundColor = .clear
        textAlignment = alignment
    }
    
    func setContent(_ content: (String, String)) {
        topText = content.0
        bottomText = content.1
        setTextLayer()
    }

    private func setTextLayer() {
        textLayer?.contentsScale = UIScreen.main.scale
        let style = NSMutableParagraphStyle() // 用来设置段落样式
        style.lineSpacing = 10 // 行间距

        let topAttr = NSMutableAttributedString(string: topText + "\n" + bottomText)
        topAttr.addAttributes([
            NSAttributedString.Key.font: topFont,
            NSAttributedString.Key.foregroundColor: topColor,
            ], range: NSRange(location: 0, length: topText.length))

        topAttr.addAttributes([
            NSAttributedString.Key.font: bottomFont,
            NSAttributedString.Key.foregroundColor: bottomColor,
            ], range: NSRange(location: topText.length + 1, length: bottomText.length))

        topAttr.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: NSRange(location: 0, length: (topText + "\n" + bottomText).length))


        textLayer?.alignmentMode = alignmentMode
        textLayer?.string = topAttr
    }

    var alignmentMode: CATextLayerAlignmentMode {
        switch textAlignment {
        case .left:
            return CATextLayerAlignmentMode.left
        case .center:
            return CATextLayerAlignmentMode.center
        case .right:
            return CATextLayerAlignmentMode.right
        default:
            print("textAlignment do not exist")
            break
        }
        return CATextLayerAlignmentMode.left
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
