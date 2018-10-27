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

class ParallaxTableViewCell: SPParallaxTableViewCell {
    
    var backgroundImageView: UIImageView!
    var gradeView: UIView!
    var separatorView: UIView!
    var titleLabel: UILabel!
    
    private var separateHeight: CGFloat = 2
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    private func commonInit() {
        backgroundImageView = UIImageView.init()
        backgroundImageView.contentMode = .scaleAspectFill
        self.parallaxViews.append(backgroundImageView)
        self.addSubview(backgroundImageView)
        
        gradeView = UIView.init()
        gradeView.backgroundColor = UIColor.black
        gradeView.isUserInteractionEnabled = false
        gradeView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(gradeView)
        
        separatorView = UIView.init()
        separatorView.backgroundColor = UIColor.black
        self.addSubview(separatorView)
        
        titleLabel = UILabel.init()
        titleLabel.textColor = UIColor.white
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(name: "AvenirNext-Medium", size: 20)
        titleLabel.addShadow(blurRadius: 0, widthOffset: 0, heightOffset: 1, opacity: 0.45)
        self.addSubview(titleLabel)
        
        SPConstraintsAssistent.setCenteringConstraint(titleLabel, superView: self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundImageView.frame = CGRect.init(
            x: 0,
            y: self.backgroundImageView.frame.origin.y,
            width: self.bounds.width,
            height: self.bounds.height + self.parallaxSize
        )
        
        self.separatorView.frame = CGRect.init(
            x: 0,
            y: self.frame.height - self.separateHeight,
            width: self.frame.width,
            height: self.separateHeight
        )
        
        SPAnimation.animate(0.3, animations: {
            self.gradeView.frame = self.bounds
        })
    }
}
