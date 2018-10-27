//
//  ZZUtil.swift
//  ZZCoreTextView
//
//  Created by duzhe on 16/6/29.
//  Copyright © 2016年 dz. All rights reserved.
//

import Foundation
import CoreText

public struct ZZUtil {

    /**
     创建属性字

     - parameter text:       文字
     - parameter styleModel: 风格

     - returns: 属性字
     */
    public static func createAttributedStringWithText(_ text: String, styleModel: ZZStyleModel) -> NSMutableAttributedString {

        let font = styleModel.font
        let fontSpace = styleModel.fontSpace
        var lineSpace = styleModel.lineSpace

        let attrString = NSMutableAttributedString(string: text)
        // 设置字体
        let fontRef = CTFontCreateWithName(font.fontName as CFString, font.pointSize, nil)
        attrString.addAttribute(kCTFontAttributeName as String, value: fontRef, range: attrString.range)

        // 设置字体颜色
        attrString.addAttribute(kCTForegroundColorAttributeName as String, value: styleModel.textColor, range: attrString.range)

        // 设置字距
        attrString.addAttribute(kCTKernAttributeName as String, value: fontSpace, range: attrString.range)

        // 添加换行模式
        var lineBreakModel: CTLineBreakMode = .byCharWrapping
        let lineBreakStyle = CTParagraphStyleSetting(spec: .lineBreakMode, valueSize: MemoryLayout<CTLineBreakMode>.size, value: &lineBreakModel)

        // 行距
        let lineSpaceStyle = CTParagraphStyleSetting(spec: .lineSpacingAdjustment, valueSize: MemoryLayout<CGFloat>.size, value: &lineSpace)

        let settings = [lineBreakStyle, lineSpaceStyle]
        let style = CTParagraphStyleCreate(settings, settings.count)

        let attributes = [kCTParagraphStyleAttributeName as String: style]
        attrString.addAttributes(attributes, range: attrString.range)

        return attrString
    }

    /**
     根据文本得到行高

     - parameter text:       文本
     - parameter rectSize:   CGSize
     - parameter styleModel: 样式

     - returns: 高度
     */
    public static func getRowHeightWithText(_ text: String?, rectSize: CGSize, styleModel: ZZStyleModel) -> CGFloat {
        guard let text = text else { fatalError("文字不能为空") }
        // 获得属性字
        let attrString = createAttributedStringWithText(text, styleModel: styleModel)
        let textRun = ZZTextRun(styleModel: styleModel)
        textRun.runsWithAttrString(attrString)

        let viewRect = CGRect(origin: .zero, size: rectSize)

        // 创建一个用来描画文字的路径，其区域为当前视图的bounds CGPath
        let pathRef = CGMutablePath()
        pathRef.addRect(viewRect)
        let framesetterRef = CTFramesetterCreateWithAttributedString(attrString as CFAttributedString)

        // 创建由framesetter管理的frame 是描画文字的一个视图范围 CTFrame
        let frameRef = CTFramesetterCreateFrame(framesetterRef, CFRangeMake(0, 0), pathRef, nil)

        let lines = CTFrameGetLines(frameRef)
        let lineCount = CFArrayGetCount(lines)

        var frameHeight: CGFloat = 0
        print("linecount = \(lineCount) ==== height = \(styleModel.font.lineHeight)")
        if styleModel.numberOfLines < 0 {
            frameHeight = CGFloat(lineCount) * (styleModel.font.lineHeight + styleModel.lineSpace) + styleModel.lineSpace
        } else {
            frameHeight = CGFloat(styleModel.numberOfLines) * (styleModel.font.lineHeight + styleModel.lineSpace) + styleModel.lineSpace
        }

        // 四舍五入函数，否则可能会出现一条黑线
        return CGFloat(roundf(Float(frameHeight)))
    }

    // url
    public static func runsURLWithAttrString(_ attrString: NSMutableAttributedString, regular: inout [NSRange], styleModel: ZZStyleModel) {

        let muStr = attrString.mutableString
        let regulaStr = String(format: "<a href='(((http[s]{1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%@^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%@^&*+?:_/=<>]*)?))'>((?!<\\/a>).)*<\\/a>|(((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%@^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%@^&*+?:_/=<>]*)?))", "%", "%", "%", "%")

        do {
            let regex = try NSRegularExpression(pattern: regulaStr, options: .caseInsensitive)
            let arrayOfAllMatches = regex.matches(in: muStr as String, options: .reportProgress, range: NSMakeRange(0, muStr.length))

            var forIndex = 0
            var startIndex = -1
            for match in arrayOfAllMatches {

                let matchRange = match.range
                if startIndex == -1 {
                    startIndex = matchRange.location
                } else {
                    startIndex = matchRange.location - forIndex
                }
                let substringForMatch = muStr.substring(with: NSMakeRange(startIndex, matchRange.length))

                var replaceStr = ""
                if !styleModel.urlShouldInstead {
                    replaceStr = substringForMatch
                } else {
                    replaceStr = "    \(styleModel.urlInsteadText)"
                }

                attrString.replaceCharacters(in: NSMakeRange(startIndex, matchRange.length), with: replaceStr)

                let range = NSMakeRange(startIndex, replaceStr.characters.count)

                attrString.addAttribute(kCTForegroundColorAttributeName as String, value: styleModel.urlColor.cgColor, range: range)

                if styleModel.urlUnderLine {

                    attrString.addAttribute(kCTUnderlineStyleAttributeName as String, value: NSNumber(value: CTUnderlineStyle.single.rawValue as Int32), range: range)
                }

                let str = String(format: "U%@{%@}", substringForMatch, NSValue(range: range))
                attrString.addAttribute("keyAttribute", value: str, range: range)
                regular.append(range)
                forIndex += substringForMatch.characters.count - replaceStr.characters.count
            }

        } catch let error as NSError {
            print("Error: \(error.localizedDescription)")
        }
    }

    public static func runsNumberWithAttrString(_ attrString: NSMutableAttributedString, regular _: inout [NSRange], styleModel: ZZStyleModel) {
        let muStr = attrString.mutableString
        let regulaStr = "\\d{3}-\\d{8}|\\d{3}-\\d{7}|\\d{4}-\\d{8}|\\d{4}-\\d{7}|1+[358]+\\d{9}|\\d{8}|\\d{7}"

        do {
            let regex = try NSRegularExpression(pattern: regulaStr, options: .caseInsensitive)
            let arrayOfAllMatches = regex.matches(in: muStr as String, options: .reportProgress, range: NSMakeRange(0, muStr.length))

            for match in arrayOfAllMatches {
                let matchRange = match.range
                let substringForMatch = muStr.substring(with: matchRange)
                attrString.addAttribute(kCTForegroundColorAttributeName as String, value: styleModel.numberColor.cgColor, range: matchRange)
                let str = String(format: "T%@{%@}", substringForMatch, NSValue(range: matchRange))
                attrString.addAttribute("keyAttribute", value: str, range: matchRange)
                print(str)
            }

        } catch let error as NSError {
            print("Error: \(error.localizedDescription)")
        }
    }

    public static func runsSomeoneWithAttrString(_ attrString: NSMutableAttributedString, regular _: inout [NSRange], styleModel: ZZStyleModel) {
        let muStr = attrString.mutableString
        let regulaStr = "@[^\\s@]+?\\s{1}"
        do {
            let regex = try NSRegularExpression(pattern: regulaStr, options: .caseInsensitive)
            let arrayOfAllMatches = regex.matches(in: muStr as String, options: .reportProgress, range: NSMakeRange(0, muStr.length))

            for match in arrayOfAllMatches {
                let matchRange = match.range
                let substringForMatch = muStr.substring(with: matchRange)
                attrString.addAttribute(kCTForegroundColorAttributeName as String, value: styleModel.atSomeOneColor.cgColor, range: matchRange)
                let str = String(format: "A%@{%@}", substringForMatch, NSValue(range: matchRange))
                attrString.addAttribute("keyAttribute", value: str, range: matchRange)
            }

        } catch let error as NSError {
            print("Error: \(error.localizedDescription)")
        }
    }
}

extension NSMutableAttributedString {

    var range: NSRange {
        return NSRange(location: 0, length: length)
    }
}
