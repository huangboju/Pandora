//
//  Vc9Controller.swift
//  ScrollViewController
//
//  Created by jasnig on 16/4/22.
//  Copyright © 2016年 ZeroJ. All rights reserved.
// github: https://github.com/jasnig
// 简书: http://www.jianshu.com/users/fb31a3d1ec30/latest_articles

//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

//

import UIKit

class Vc9Controller: UIViewController {
    var scrollPageView: ScrollPageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        // 这个是必要的设置
        automaticallyAdjustsScrollViewInsets = false
        
        var style = SegmentStyle()
        // 缩放文字
        style.scaleTitle = true
        // 颜色渐变
        style.gradualChangeTitleColor = true
        // 显示滚动条
        style.showLine = true
        // 天使遮盖
        style.showCover = true
        // segment可以滚动
        style.scrollTitle = true
        
        let titles = ["国内头条", "国际要闻", "趣事", "囧图", "明星八卦", "爱车", "国防要事", "科技频道", "手机专页", "风景图", "段子"]
        
        scrollPageView = ScrollPageView(frame: CGRect(x: 0, y: 64, width: view.bounds.size.width, height: view.bounds.size.height - 64), segmentStyle: style, titles: titles, childVcs: setChildVcs(), parentViewController: self)
        // 设置默认下标
        scrollPageView.selectedIndex(2, animated: true)
        view.addSubview(scrollPageView)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        scrollPageView.frame = CGRect(x: 0, y: 64, width: view.bounds.size.width, height: view.bounds.size.height - 64)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print(navigationController?.interactivePopGestureRecognizer)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        print(navigationController?.interactivePopGestureRecognizer)

    }
    
    func setChildVcs() -> [UIViewController] {
        let vc1 = storyboard!.instantiateViewControllerWithIdentifier("test")
        
        let vc2 = UIViewController()
        vc2.view.backgroundColor = UIColor.greenColor()
        
        let vc3 = UIViewController()
        vc3.view.backgroundColor = UIColor.redColor()
        
        let vc4 = storyboard!.instantiateViewControllerWithIdentifier("test")
        vc4.view.backgroundColor = UIColor.yellowColor()
        
        let vc5 = UIViewController()
        vc5.view.backgroundColor = UIColor.lightGrayColor()
        
        let vc6 = UIViewController()
        vc6.view.backgroundColor = UIColor.brownColor()
        
        let vc7 = UIViewController()
        vc7.view.backgroundColor = UIColor.orangeColor()
        
        let vc8 = UIViewController()
        vc8.view.backgroundColor = UIColor.blueColor()
        
        let vc9 = UIViewController()
        vc9.view.backgroundColor = UIColor.brownColor()
        
        let vc10 = UIViewController()
        vc10.view.backgroundColor = UIColor.orangeColor()
        
        let vc11 = UIViewController()
        vc11.view.backgroundColor = UIColor.blueColor()
        return [vc1, vc2, vc3,vc4, vc5, vc6, vc7, vc8, vc9, vc10, vc11]
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
