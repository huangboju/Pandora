//
//  CTPicTxtView.swift
//  ZZCoreTextDemo
//  图文混排 demo
//  Created by duzhe on 16/1/29.
//  Copyright © 2016年 dz. All rights reserved.
//

import UIKit

extension CGContext {
    func convertFrameWithY(_ y: CGFloat) {
        textMatrix = .identity
        translateBy(x: 0, y: y)
        scaleBy(x: 1.0, y: -1.0)
    }
}

class CTPicTxtView: UIView {

    var image: UIImage?

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        // 1 获取上下文
        guard let context = UIGraphicsGetCurrentContext() else { return }

        // 2 转换坐标
        context.convertFrameWithY(bounds.height)

        // 3 绘制区域
        let path = UIBezierPath(rect: rect)

        // 4 创建需要绘制的文字
        let attrString = "Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!"

        let mutableAttrStr = NSMutableAttributedString(string: attrString)
        mutableAttrStr.addAttributes([
            NSFontAttributeName: UIFont.systemFont(ofSize: 20),
            NSForegroundColorAttributeName: UIColor.red,
        ], range: NSMakeRange(0, 5))
        mutableAttrStr.addAttributes([
            NSFontAttributeName: UIFont.systemFont(ofSize: 13),
            NSUnderlineStyleAttributeName: 1,
        ], range: NSMakeRange(3, 10))
        let style = NSMutableParagraphStyle() // 用来设置段落样式
        style.lineSpacing = 6 // 行间距
        mutableAttrStr.addAttributes([
            NSParagraphStyleAttributeName: style,
        ], range: NSMakeRange(0, mutableAttrStr.length))

        // 5 为图片设置CTRunDelegate, delegate决定留给图片的空间大小
        var imageName = "mc"

        var imageCallback = CTRunDelegateCallbacks(version: kCTRunDelegateVersion1, dealloc: { _ in

        }, getAscent: { (_) -> CGFloat in

            //                let imageName = "mc"
            //                refCon.initialize()
            //                let image = UIImage(named: imageName)
            100 // 返回高度
        }, getDescent: { (_) -> CGFloat in

            50 // 返回底部距离
        }) { (_) -> CGFloat in

            //                let imageName = String("mc")
            //                let image = UIImage(named: imageName)
            return 100 // 返回宽度
        }

        let runDelegate = CTRunDelegateCreate(&imageCallback, &imageName)
        let imgString = NSMutableAttributedString(string: " ") // 空格用于给图片留位置
        imgString.addAttribute(kCTRunDelegateAttributeName as String, value: runDelegate!, range: NSMakeRange(0, 1)) // rundelegate  占一个位置
        imgString.addAttribute("imageName", value: imageName, range: NSMakeRange(0, 1)) // 添加属性，在CTRun中可以识别出这个字符是图片
        mutableAttrStr.insert(imgString, at: 15)

        // 网络图片相关
        var imageCallback1 = CTRunDelegateCallbacks(version: kCTRunDelegateVersion1, dealloc: { _ in

        }, getAscent: { (_) -> CGFloat in

            70 // 返回高度
        }, getDescent: { (_) -> CGFloat in

            50 // 返回底部距离
        }) { (_) -> CGFloat in
            return 100 // 返回宽度
        }
        var imageUrl = "http://img3.3lian.com/2013/c2/64/d/65.jpg" // 网络图片链接
        let urlRunDelegate = CTRunDelegateCreate(&imageCallback1, &imageUrl)
        let imgUrlString = NSMutableAttributedString(string: " ") // 空格用于给图片留位置
        imgUrlString.addAttribute(kCTRunDelegateAttributeName as String, value: urlRunDelegate!, range: NSMakeRange(0, 1)) // rundelegate  占一个位置
        imgUrlString.addAttribute("urlImageName", value: imageUrl, range: NSMakeRange(0, 1)) // 添加属性，在CTRun中可以识别出这个字符是图片
        mutableAttrStr.insert(imgUrlString, at: 50)

        // 6 生成framesetter
        let framesetter = CTFramesetterCreateWithAttributedString(mutableAttrStr)
        let frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, mutableAttrStr.length), path.cgPath, nil)

        // 7 绘制除图片以外的部分
        CTFrameDraw(frame, context)

        // 8 处理绘制图片逻辑
        let lines = CTFrameGetLines(frame) as! [CTLine] // 存取frame中的ctlines

        var originsArray = [CGPoint](repeating: .zero, count: lines.count)
        let range = CFRangeMake(0, 0)
        CTFrameGetLineOrigins(frame, range, &originsArray)

        // 遍历CTRun找出图片所在的CTRun并进行绘制,每一行可能有多个
        for i in 0 ..< lines.count {
            // 遍历每一行CTLine
            let line = lines[i]
            var lineAscent: CGFloat = 0
            var lineDescent: CGFloat = 0
            var lineLeading: CGFloat = 0
            // 该函数除了会设置好ascent, descent, leading之外，还会返回这行的宽度
            CTLineGetTypographicBounds(line, &lineAscent, &lineDescent, &lineLeading)

            let runs = CTLineGetGlyphRuns(line) as! [CTRun]
            for j in 0 ..< runs.count {
                // 遍历每一个CTRun
                var runAscent: CGFloat = 0
                var runDescent: CGFloat = 0
                let lineOrigin = originsArray[i] // 获取该行的初始坐标
                let run = runs[j] // 获取当前的CTRun
                let attributes = CTRunGetAttributes(run) as! [String: Any]

                let width = CGFloat(CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &runAscent, &runDescent, nil))

                let runRect = CGRect(x: lineOrigin.x + CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, nil), y: lineOrigin.y - runDescent, width: width, height: runAscent + runDescent)
                let imageNames = attributes["imageName"]
                let urlImageName = attributes["urlImageName"]

                if imageNames is NSString {
                    // 本地图片
                    let image = UIImage(named: imageName as String)
                    let imageDrawRect = CGRect(x: runRect.origin.x, y: lineOrigin.y - runDescent, width: 100, height: 100)
                    context.draw((image?.cgImage)!, in: imageDrawRect)
                }

                if let urlImageName = urlImageName as? String {
                    var image: UIImage?
                    let imageDrawRect = CGRect(x: runRect.origin.x, y: lineOrigin.y - runDescent, width: 100, height: 100)
                    if self.image == nil {
                        image = UIImage(named: "hs") // 灰色图片占位
                        // 去下载
                        if let url = URL(string: urlImageName) {
                            let request = URLRequest(url: url)
                            URLSession.shared.dataTask(with: request, completionHandler: { (data, _, _) -> Void in
                                if let data = data {
                                    DispatchQueue.main.sync(execute: { () -> Void in
                                        self.image = UIImage(data: data)
                                        self.setNeedsDisplay() // 下载完成会重绘
                                    })
                                }
                            }).resume()
                        }

                    } else {
                        image = self.image
                    }
                    context.draw((image?.cgImage)!, in: imageDrawRect)
                }
            }
        }
    }
}
