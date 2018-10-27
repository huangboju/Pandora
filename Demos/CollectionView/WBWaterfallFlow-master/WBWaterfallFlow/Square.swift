//
//  Square.swift
//  WBWaterfallFlow
//
//  Created by caowenbo on 16/2/20.
//  Copyright © 2016年 曹文博. All rights reserved.
//

import UIKit

class Square: NSObject {

    var h: CGFloat = 0
    var w: CGFloat = 0

    init(dic: [String: NSNumber]?) {
        super.init()

        guard dic?.count > 0 else {
            return
        }

        setValuesForKeysWithDictionary(dic!)
    }

    class func squares() -> [Square] {

        let path = NSBundle.mainBundle().pathForResource("1.plist", ofType: nil)!

        let array = NSArray.init(contentsOfFile: path)!

        var arrayM = [Square]()

        for item in array {

            let dic = item as! [String: NSNumber]

            arrayM.append(Square(dic: dic))
        }

        return arrayM
    }
}

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
