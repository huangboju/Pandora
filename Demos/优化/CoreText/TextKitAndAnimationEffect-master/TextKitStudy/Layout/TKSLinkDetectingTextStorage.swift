//
//  TKSLinkDetectingTextStorage.swift
//  TextKitStudy
//
//  Created by steven on 2/17/16.
//  Copyright © 2016 Steven lv. All rights reserved.
//

import UIKit

class TKSLinkDetectingTextStorage: NSTextStorage {
    
    private lazy var imp:NSMutableAttributedString = {
        var _imp:NSMutableAttributedString = NSMutableAttributedString()
        return _imp
    }()
    
    
    override var string:String
    {
        get{
            return self.imp.string
        }
    }
    
    override func attributesAtIndex(location: Int, effectiveRange range: NSRangePointer) -> [String : AnyObject] {
        
        return self.imp.attributesAtIndex(location, effectiveRange: range)
    }
    
    override func replaceCharactersInRange(range: NSRange, withString str: String) {
        self.beginEditing()
        self.imp.replaceCharactersInRange(range, withString: str)
        self.edited(.EditedCharacters, range: range, changeInLength: str.characters.count)
        
        
        
        
        
        self.endEditing()
    }
    
    override func setAttributes(attrs: [String : AnyObject]?, range: NSRange) {
        self.beginEditing()
        self.imp.setAttributes(attrs, range: range)
        self.edited(.EditedAttributes, range: range, changeInLength: 0)
        self.endEditing()
    }
    
    override func processEditing() {
        super.processEditing()

        //添加下划线
        let linkDetector:NSDataDetector? = try? NSDataDetector(types: NSTextCheckingType.Link.rawValue)
        let range:NSRange = (self.string as NSString).paragraphRangeForRange(NSMakeRange(0, self.string.characters.count))
        
        self.imp.removeAttribute(NSLinkAttributeName, range: range)
        self.imp.removeAttribute(NSForegroundColorAttributeName, range: range)
        self.imp.removeAttribute(NSUnderlineStyleAttributeName, range: range)
        
        if linkDetector != nil
        {
            linkDetector!.enumerateMatchesInString(self.imp.string, options:NSMatchingOptions(rawValue: 0), range: range) { [weak self](textCheckingResult:NSTextCheckingResult?, flags:NSMatchingFlags, stop:UnsafeMutablePointer<ObjCBool>) -> Void in
                if textCheckingResult != nil
                {
                    self?.imp.addAttribute(NSLinkAttributeName, value: textCheckingResult!.URL!, range: textCheckingResult!.range)
//                    self?.imp.addAttribute(NSForegroundColorAttributeName, value: UIColor.yellowColor(), range: textCheckingResult!.range)
                    self?.imp.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.StyleSingle.rawValue, range: textCheckingResult!.range)
                }
            }
            
        }

    }
}
