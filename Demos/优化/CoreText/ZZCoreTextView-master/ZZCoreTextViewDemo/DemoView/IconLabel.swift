//
//  IconLabel.swift
//  ZZCoreTextView
//
//  Created by 伯驹 黄 on 2017/3/31.
//  Copyright © 2017年 dz. All rights reserved.
//

import UIKit

enum IconPosition {
    case top, left, bottom, right
}

class IconLabel: UIView {

    /// Default UIColor.lightGray
    public var titleColor = UIColor.lightGray

    /// Default 14
    public var titleFont = UIFont.systemFont(ofSize: 14)

    /// Default 8
    public var gap: CGFloat = 8

    public var title: String?

    public var icon: UIImage?

    public var iconPosition: IconPosition = .top

    convenience init(iconPosition: IconPosition = .top) {
        self.init(frame: .zero, iconPosition: iconPosition)
    }

    public init(frame: CGRect, iconPosition: IconPosition = .top) {
        super.init(frame: frame)
        self.iconPosition = iconPosition
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        
        guard let title = title else {
            return
        }

        (title as NSString).draw(in: rect, withAttributes: [
            NSFontAttributeName: titleFont,
            NSForegroundColorAttributeName: titleColor
            ])
    }
}
