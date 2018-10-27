//
//  RounderButton.swift
//  reincarnation
//
//  Created by Ivan Vorobei on 6/19/16.
//  Copyright © 2016 Ivan Vorobei. All rights reserved.
//

import UIKit

class SPRoundButton: SPRoundFrameButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    
    private func commonInit() {
        self.backgroundColor = UIColor.white
        self.layer.borderWidth = 0
    }
}

class SPRoundLineButton: SPRoundFrameButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    
    private func commonInit() {
        self.backgroundColor = UIColor.clear
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor(hue: 0,
                                         saturation: 0,
                                         brightness: 100,
                                         alpha: 0.5).cgColor
        self.layer.borderColor = UIColor.init(white: 1, alpha: 0.5).cgColor
    }
}

class SPRoundFrameButton: UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let minSide = min(self.frame.width, self.frame.height)
        self.layer.cornerRadius = minSide / 2
        self.clipsToBounds = true
    }
}
