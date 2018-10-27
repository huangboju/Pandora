//
//  UIColor+Extension.swift
//  JMWaterFlow
//
//  Created by Jimmy on 15/10/11.
//  Copyright © 2015年 Jimmy. All rights reserved.
//

import UIKit

/// 扩展UIColor
extension UIColor {
    /// 随机色
    class func randomColor() -> UIColor {
        return UIColor(red: randomValue(), green: randomValue(), blue: randomValue(), alpha: 0.9)
    }

    /**
     - returns: 随机值
     */
    private class func randomValue() -> CGFloat {
        return CGFloat(arc4random_uniform(256)) / 255
    }
}
