//
//  MTLabel.swift
//  ZZCoreTextView
//
//  Created by 伯驹 黄 on 2017/3/30.
//  Copyright © 2017年 dz. All rights reserved.
//

import UIKit

class MTLabel1: UIView {
    
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
    
    init(frame: CGRect, aliment: NSTextAlignment = .center) {
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
        let topText = "10.0%"
        let topRect = CGRect(x: 20, y: 20, width: 280, height: 200)
        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.left
        (topText as NSString).draw(in: topRect, withAttributes: [
            NSFontAttributeName: topFont,
            NSForegroundColorAttributeName: topColor
            ])

        let bottomText = "预期年化"
        let bottomRect = CGRect(x: 20, y: 50, width: 280, height: 200)
        (bottomText as NSString).draw(in: bottomRect, withAttributes: [
            NSFontAttributeName: bottomFont,
            NSForegroundColorAttributeName: bottomColor
            ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
