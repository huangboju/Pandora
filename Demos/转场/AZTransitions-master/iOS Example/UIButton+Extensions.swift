//
//  UIButton+Extensions.swift
//  AZTransitions
//
//  Created by Alex Zimin on 06/11/2016.
//  Copyright © 2016 Alexander Zimin. All rights reserved.
//

import UIKit

extension UIButton {
  func underlineCurrentTitle() {
    guard let text = title(for: .normal) else { return }
    let textRange = NSMakeRange(0, text.characters.count)
    let attributedText = NSMutableAttributedString(string: text)
    attributedText.addAttribute(NSUnderlineStyleAttributeName , value: NSUnderlineStyle.styleSingle.rawValue, range: textRange)
    attributedText.addAttribute(NSForegroundColorAttributeName, value: titleColor(for: .normal) ?? UIColor.blue, range: textRange)
    setAttributedTitle(attributedText, for: .normal)
  }
}
