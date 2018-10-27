//
//  HightLightingTextStorage.swift
//  TextKitStudy
//
//  Created by steven on 2/4/16.
//  Copyright © 2016 Steven lv. All rights reserved.
//

import UIKit

class HightLightingTextStorage: NSTextStorage {
    private lazy var imp:NSMutableAttributedString = {
        var imp:NSMutableAttributedString = NSMutableAttributedString(string: "")
        return imp
    }()
    
    static var iExpression:NSRegularExpression?
    
    override internal init()
    {
        super.init()
    }
    
    required internal init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override  var string:String {
        get{
            return self.imp.string
        }
    }
    
    override  func attributesAtIndex(location: Int, effectiveRange range: NSRangePointer) -> [String : AnyObject] {
        return self.imp.attributesAtIndex(location, effectiveRange: range)
    }
    
    override  func replaceCharactersInRange(range: NSRange, withString str: String) {
        
        self.imp.replaceCharactersInRange(range, withString: str)
        self.edited(.EditedCharacters, range: range, changeInLength: str.characters.count)
        
    }
    
    override  func setAttributes(attrs: [String : AnyObject]?, range: NSRange) {
        self.imp.setAttributes(attrs, range: range)
        self.edited(.EditedAttributes, range: range, changeInLength: 0)
    }
    
    override func processEditing() {
        super.processEditing()

        HightLightingTextStorage.iExpression = try? NSRegularExpression(
            pattern:"i[\\p{Alphabetic}&&\\p{Uppercase}][\\p{Alphabetic}]+",
            options: NSRegularExpressionOptions(rawValue: 0))
        print("\(HightLightingTextStorage.iExpression)")
        
        let paragraphRange:NSRange = (self.string as NSString).paragraphRangeForRange(self.editedRange)
        
        self.removeAttribute(NSForegroundColorAttributeName, range: paragraphRange)
        
        HightLightingTextStorage.iExpression?.enumerateMatchesInString(self.string, options: NSMatchingOptions(rawValue: 0), range: paragraphRange, usingBlock: {
                [weak self](result:NSTextCheckingResult?, flags:NSMatchingFlags, stop:UnsafeMutablePointer<ObjCBool>) -> Void in
                    if let textResult = result {
                        self?.addAttribute(NSForegroundColorAttributeName, value: UIColor.redColor(), range: textResult.range)
                    }
        })
        
        
        
    }

}
