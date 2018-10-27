// The MIT License (MIT)
// Copyright © 2016 Ivan Vorobei (hello@ivanvorobei.by)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import UIKit

extension SPLaunchAnimation {
    
    private static let windowColor: UIColor = UIColor.black
    private static let animateDuration: TimeInterval = 1
    private static let delay: TimeInterval = 0.8
    private static let paralaxTranslationXCoef: CGFloat = 0.3
    
    static func slideWithParalax(
        launchScreenStoryboardName: String = "LaunchScreen",
        disabelParalaxForFirstViewOnLaunchScreenView: Bool = true,
        disabelParalaxForFirstViewOnRootViewController: Bool = true,
        disabelParalaxForRootViewController: Bool = false,
        onWindow window: UIWindow) {
        
        window.backgroundColor = self.windowColor
        window.makeKeyAndVisible()
        
        let screenBounds = UIScreen.main.bounds
        window.rootViewController?.view.frame.origin.x += screenBounds.width
        
        var rootViewControllerSubviews = (window.rootViewController?.view.subviews)!

        if (disabelParalaxForFirstViewOnRootViewController) {
            rootViewControllerSubviews.removeFirst()
        }
        
        let launchScreenController = UIStoryboard(name: launchScreenStoryboardName, bundle: nil).instantiateInitialViewController()
        let launchScreenView = launchScreenController!.view!
        window.addSubview(launchScreenView)
        
        var launchScreenViewSubviews = launchScreenView.subviews

        if (disabelParalaxForFirstViewOnLaunchScreenView) {
            launchScreenViewSubviews.removeFirst()
        }
        
        for view in rootViewControllerSubviews {
            var paralaxTranslationXCoef = self.paralaxTranslationXCoef
            
            if disabelParalaxForRootViewController {
                paralaxTranslationXCoef = 0
            }
            
            view.transform = CGAffineTransform(translationX: screenBounds.width * paralaxTranslationXCoef, y: 0)
        }
        
        SPAnimationSpring.animate(
            self.animateDuration,
            animations: {
                
                window.rootViewController?.view.frame.origin = CGPoint.zero
                for view in rootViewControllerSubviews {
                    view.transform = CGAffineTransform.identity
                }
                launchScreenView.transform = CGAffineTransform(translationX: -screenBounds.width, y: 0)
                for view in launchScreenViewSubviews {
                    view.transform = CGAffineTransform.init(translationX: -screenBounds.width * self.paralaxTranslationXCoef, y: 0)
                }
                
                
        }, delay: self.delay,
           spring: 1.0,
           velocity: 0.0,
           options: [.curveEaseInOut],
           withComplection: {
            finished in
                launchScreenView.removeFromSuperview()
        })
    }
}
