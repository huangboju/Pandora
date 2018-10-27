//
//  ViewController.swift
//  ZZCoreTextDemo
//
//  Created by duzhe on 16/1/28.
//  Copyright © 2016年 dz. All rights reserved.
//

import UIKit

class SecondController: UIViewController {

    private lazy var segementConrol: UISegmentedControl = {
        let segementConrol = UISegmentedControl(items: ["CTView", "CTPicTxtView", "CTextView", "CTURLView"])
        segementConrol.frame.origin.y = 20
        segementConrol.frame.size.width = self.view.bounds.width
        segementConrol.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
        segementConrol.selectedSegmentIndex = 0
        return segementConrol
    }()

    private lazy var ctView: CTView = {
        let ctView = CTView()
        ctView.frame = CGRect(x: 10, y: 150, width: self.view.bounds.width - 20, height: 200)
        ctView.backgroundColor = UIColor.white
        return ctView
    }()

    private lazy var cptView: IconLabel = {
        let cptView = IconLabel(iconPosition: .right)
        cptView.title = "活动专区"
        cptView.icon = UIImage(named: "calendar")
        cptView.frame = CGRect(x: 10, y: 100, width: self.view.bounds.width - 20, height: self.view.bounds.height - 200)
        cptView.backgroundColor = UIColor.white
        cptView.layer.borderWidth = 1
        cptView.layer.borderColor = UIColor.gray.cgColor
        return cptView
    }()

    private lazy var ctextView: CTextView = {
        let ctextView = CTextView()
        ctextView.frame = CGRect(x: 10, y: 100, width: self.view.bounds.width - 20, height: 200)
        ctextView.backgroundColor = UIColor.white
        return ctextView
    }()

    private lazy var ctURLView: CTURLView = {
        let ctURLView = CTURLView()
        ctURLView.frame = CGRect(x: 10, y: 100, width: self.view.bounds.width - 20, height: 300)
        ctURLView.backgroundColor = UIColor.gray
        let mutableAttrStr = NSMutableAttributedString(string: ctURLView.str)
        let size = ctURLView.sizeForText(mutableAttrStr)
        ctURLView.frame.size = size
        return ctURLView
    }()

    var currentView: UIView!

    func valueChanged() {
        let i = segementConrol.selectedSegmentIndex
        let title = segementConrol.titleForSegment(at: i) ?? ""
        currentView.removeFromSuperview()
        switch title {
        case "CTView":
            currentView = ctView
        case "CTPicTxtView":
            currentView = cptView
        case "CTextView":
            currentView = ctextView
        case "CTURLView":
            currentView = ctURLView
        default: break
        }

        view.addSubview(currentView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()


//        view.addSubview(segementConrol)

        
        currentView = ctView
//        view.addSubview(currentView)

//        logFont() 
        
        
        
        let startTime = CFAbsoluteTimeGetCurrent()
        print(startTime)
        var y: CGFloat = 0
        var n: CGFloat = 0
        for i in 0 ..< 1000 {
            var x = CGFloat(i * 65)
            if x >= view.frame.width {
                if n == 0 {
                    n = x
                }
                y = floor(CGFloat(i * 65) / n)
                x.formTruncatingRemainder(dividingBy: n)
            }
//            let iconLabel = creatIconLabel(origin: CGPoint(x: x, y: y * 65))
//            view.addSubview(iconLabel)

//            let button = creatButton(origin: CGPoint(x: x, y: y * 65))
//            view.addSubview(button)

            let mtLabel1 = creatMTLabel2(origin: CGPoint(x: x, y: y * 65))
            view.addSubview(mtLabel1)

//            let mtLabel = creatMTLabel(origin: CGPoint(x: x, y: y * 65))
//            view.addSubview(mtLabel)
        }

        let endTime = CFAbsoluteTimeGetCurrent()
        print(endTime)
        print("耗时", endTime - startTime)
    }
    
    func creatMTLabel(origin: CGPoint) -> UIView {
        let superView = UIView(frame: CGRect(origin: origin, size: CGSize(width: 60, height: 60)))
        superView.layer.borderColor = UIColor.lightGray.cgColor
        superView.layer.borderWidth = 1

        let titleLabel = UILabel(frame: CGRect(x: 5, y: 0, width: 50, height: 20))
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.text = "膜拜单车"
        titleLabel.sizeToFit()
        titleLabel.frame.origin.x = (60 - titleLabel.frame.width) / 2
        superView.addSubview(titleLabel)
        
        let textLable = UILabel(frame: CGRect(x: 5, y: titleLabel.frame.maxY + 8, width: 50, height: 20))
        textLable.font = UIFont.systemFont(ofSize: 14)
        textLable.text = "ofo单车"
        textLable.sizeToFit()
        textLable.frame.origin.x = (60 - textLable.frame.width) / 2
        superView.addSubview(textLable)
        return superView
    }
    
    func creatMTLabel1(origin: CGPoint) -> MTLabel1 {
        let cptView = MTLabel1()
        cptView.frame = CGRect(x: origin.x, y: origin.y, width: 60, height: 60)
        cptView.setContent(("膜拜单车", "ofo单车"))
        cptView.backgroundColor = UIColor.white
        cptView.layer.borderWidth = 1
        cptView.layer.borderColor = UIColor.gray.cgColor
        return cptView
    }
    
    func creatMTLabel2(origin: CGPoint) -> MTLabel2 {
        let cptView = MTLabel2()
        cptView.frame = CGRect(x: origin.x, y: origin.y, width: 60, height: 60)
        cptView.setContent(("膜拜单车", "ofo单车"))
        cptView.backgroundColor = UIColor.white
        cptView.layer.borderWidth = 1
        cptView.layer.borderColor = UIColor.gray.cgColor
        return cptView
    }

    func creatIconLabel(origin: CGPoint) -> IconLabel {
        let cptView = IconLabel(iconPosition: .top)
        cptView.title = "活动专区"
        cptView.icon = UIImage(named: "calendar")
        cptView.frame = CGRect(x: origin.x, y: origin.y, width: 60, height: 60)
        cptView.backgroundColor = UIColor.white
        cptView.layer.borderWidth = 1
        cptView.layer.borderColor = UIColor.gray.cgColor
        return cptView
    }

    func creatButton(origin: CGPoint) -> UIView {
        let superView = UIView(frame: CGRect(origin: origin, size: CGSize(width: 60, height: 60)))
        superView.layer.borderColor = UIColor.lightGray.cgColor
        superView.layer.borderWidth = 1
        let titleLabel = UILabel(frame: CGRect(x: 5, y: 0, width: 50, height: 20))
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.text = "活动专区"
        titleLabel.sizeToFit()
        titleLabel.frame.origin.x = (60 - titleLabel.frame.width) / 2
        superView.addSubview(titleLabel)
        
        let image = UIImage(named: "calendar")
        let iconView = UIImageView(image: image)
        iconView.frame.origin = CGPoint(x: (60 - image!.size.width) / 2, y: titleLabel.frame.maxY + 8)
        superView.addSubview(iconView)

        return superView
    }

    func tagLabel() {
        let texts = ["测试上架", "新手标", "提前气息"]
        
        var ranges = Array(repeating: NSRange(), count: texts.count)
        var str = ""
        for (i, text) in texts.enumerated() {
            str += (text + (i == ranges.count - 1 ? "" : " | "))
            let range = NSRange(location: str.length - 3, length: 3)
            ranges[i] = range
        }
        
        let textLable = UILabel(frame: CGRect(x: 15, y: 200, width: view.bounds.width - 30, height: 30))
        textLable.backgroundColor = UIColor.red
        textLable.font = UIFont.systemFont(ofSize: 12)
        let attr = NSMutableAttributedString(string: str)

        for (i, range) in ranges.enumerated() {
            if i == ranges.count - 1 {
                break
            }
            attr.addAttributes([NSKernAttributeName: 1, NSFontAttributeName: UIFont.systemFont(ofSize: 16)], range: range)
        }
        
        textLable.attributedText = attr
        view.addSubview(textLable)
    }
    
    func logFont() {
        let font = UIFont.systemFont(ofSize: 14)
        print(font.descender) // -3.376953125
        print(font.ascender) // 13.330078125
        print(font.lineHeight) // 16.70703125
        print(font.capHeight) // 9.8642578125
        print(font.xHeight) // 7.369140625
        print(font.leading) // 0.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
