//
//  ZZTextRun.swift
//  ZZCoreTextView
//
//  Created by duzhe on 16/6/29.
//  Copyright © 2016年 dz. All rights reserved.
//

import Foundation

class ZZTextRun {

    fileprivate var regularResults: [NSRange] = []
    var styleModel: ZZStyleModel

    init(styleModel: ZZStyleModel) {
        self.styleModel = styleModel
    }

    func runsWithAttrString(_ attrString: NSMutableAttributedString) {
        regularResults.removeAll()
        ZZUtil.runsURLWithAttrString(attrString, regular: &regularResults, styleModel: styleModel)
        ZZUtil.runsNumberWithAttrString(attrString, regular: &regularResults, styleModel: styleModel)
        ZZUtil.runsSomeoneWithAttrString(attrString, regular: &regularResults, styleModel: styleModel)
    }
}
