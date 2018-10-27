//
//  SharingCircleButton.swift
//  reincarnation
//
//  Created by Ivan Vorobei on 6/26/16.
//  Copyright © 2016 Ivan Vorobei. All rights reserved.
//

import UIKit

class SPLinesCircleButtonsView: UIView {
    
    fileprivate var minSpace: CGFloat = 15
    var items = [UIButton]()

    init(frame: CGRect = CGRect.zero, buttons: [UIButton]) {
        super.init(frame: frame)
        commonInit()
        self.addButtons(buttons)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.clear
    }
    
    func addButtons(_ buttons: [UIButton]) {
        for button in buttons {
            self.items.append(button)
            self.addSubview(button)
        }
    }
    
    fileprivate func commonInit() {
        self.backgroundColor = UIColor.clear
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let counts: CGFloat = CGFloat(self.items.count)
        var sideSize = self.frame.height
        var space = (self.frame.width - (sideSize * counts)) / (counts - 1)
        if (space < self.minSpace) {
            sideSize = (self.frame.width - (self.minSpace * (counts - 1))) / counts
            space = self.minSpace
        }
        
        var xItemPosition: CGFloat = 0
        let yItemPosition: CGFloat = (self.frame.height / 2) - (sideSize / 2)
        
        for view in self.subviews {
            view.frame = CGRect.init(
                x: xItemPosition,
                y: yItemPosition,
                width: sideSize,
                height: sideSize
            )
            xItemPosition = xItemPosition + sideSize + space
        }
        
    }

}
