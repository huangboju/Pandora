//
//  Factories.swift
//  AsyncDisplay
//
//  Created by 伯驹 黄 on 2017/4/20.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

extension NSParagraphStyle {
    static var justifiedParagraphStyle: NSParagraphStyle {
        let paragraphStlye = NSMutableParagraphStyle()
        paragraphStlye.alignment = .justified
        return paragraphStlye
    }
}

extension NSShadow {
    static var titleTextShadow: NSShadow {
        let shadow = NSShadow()
        shadow.shadowColor = UIColor(hue: 0, saturation: 0, brightness: 0, alpha: 0.3)
        shadow.shadowOffset = CGSize(width: 0, height: 2)
        shadow.shadowBlurRadius = 3.0
        return shadow
    }

    static var descriptionTextShadow: NSShadow {
        let shadow = NSShadow()
        shadow.shadowColor = UIColor(white: 0, alpha: 0.3)
        shadow.shadowOffset = CGSize(width: 0, height: 1)
        shadow.shadowBlurRadius = 3.0
        
        return shadow
    }
}

extension NSAttributedString {
    convenience init(forTitleText text: String) {

        let titleAttributes: [String: Any] = [
            NSFontAttributeName: UIFont(name: "AvenirNext-Heavy", size: 30)!,
            NSForegroundColorAttributeName: UIColor.white,
            NSShadowAttributeName: NSShadow.titleTextShadow,
            NSParagraphStyleAttributeName: NSParagraphStyle.justifiedParagraphStyle
        ]
        self.init(string: text, attributes: titleAttributes)

    }

    convenience init(forDescription text: String) {
        let descriptionAttributes: [String: Any] = [
            NSFontAttributeName: UIFont(name: "AvenirNext-Medium", size: 16)!,
            NSForegroundColorAttributeName: UIColor.white,
            NSBackgroundColorAttributeName: UIColor.clear,
            NSShadowAttributeName: NSShadow.descriptionTextShadow, NSParagraphStyleAttributeName: NSParagraphStyle.justifiedParagraphStyle
        ]

        self.init(string: text, attributes: descriptionAttributes)
    }
}
