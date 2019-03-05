//
//  MTLabel.swift
//  ZZCoreTextView
//
//  Created by 伯驹 黄 on 2017/3/30.
//  Copyright © 2017年 dz. All rights reserved.
//

import UIKit

class MTLabel1: UIView {
    
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
    
    var topText = ""
    var bottomText = ""
    
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
        setNeedsDisplay()
    }

    override func draw(_ rect: CGRect) {

        let topTextSize = topText.size(of: topFont)
        var topRect = CGRect(x: 15, y: 0, width: topTextSize.width, height: topTextSize.height)

        let bottomTextSize = bottomText.size(of: bottomFont)
        var bottomRect = CGRect(x: 15, y: topTextSize.height + lineSpacing, width: bottomTextSize.width, height: bottomTextSize.height)
        switch textAlignment {
        case .left:
            break
        case .center:
            topRect.origin.x = (bounds.width - topTextSize.width) / 2
            bottomRect.origin.x = (bounds.width - bottomTextSize.width) / 2
        case .right:
            topRect.origin.x = bounds.width - 15 - topTextSize.width
            bottomRect.origin.x = bounds.width - 15 - bottomTextSize.width
        default:
            print("textAlignment do not exist")
            break
        }

        (topText as NSString).draw(in: topRect, withAttributes: [
            NSAttributedString.Key.font: topFont,
            NSAttributedString.Key.foregroundColor: topColor
            ])

        (bottomText as NSString).draw(in: bottomRect, withAttributes: [
            NSAttributedString.Key.font: bottomFont,
            NSAttributedString.Key.foregroundColor: bottomColor
            ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension String {
    func size(of font: UIFont) -> CGSize {
        return self.boundingRect(with: CGSize(width: CGFloat.infinity, height: CGFloat.infinity), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil).size
    }
}
