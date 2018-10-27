//
//  SyntaxHighlightTextStorage.swift
//  SwiftTextKitNotepad
//
//  Created by Gabriel Hauber on 18/07/2014.
//  Copyright (c) 2014 Gabriel Hauber. All rights reserved.
//

import UIKit

class SyntaxHighlightTextStorage: NSTextStorage {
    let backingStore = NSMutableAttributedString()
    var replacements: [String : [AnyHashable: Any]]!
    
    override init() {
        super.init()
        createHighlightPatterns()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override var string: String {
        return backingStore.string
    }
    
    override func attributes(at location: Int, effectiveRange range: NSRangePointer?) -> [String : Any] {
        return backingStore.attributes(at: location, effectiveRange: range)
    }
    
    override func replaceCharacters(in range: NSRange, with str: String) {
        print("replaceCharactersInRange:\(range) withString:\(str)")
        
        beginEditing()
        backingStore.replaceCharacters(in: range, with:str)
        edited([.editedCharacters, .editedAttributes], range: range, changeInLength: (str as NSString).length - range.length)
        endEditing()
    }
    
    override func setAttributes(_ attrs: [String : Any]?, range: NSRange) {
        print("setAttributes:\(attrs) range:\(range)")
        
        beginEditing()
        backingStore.setAttributes(attrs, range: range)
        edited(.editedAttributes, range: range, changeInLength: 0)
        endEditing()
    }
    
    func applyStylesToRange(_ searchRange: NSRange) {
        let normalAttrs = [NSFontAttributeName : UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)]
        
        // iterate over each replacement
        for (pattern, attributes) in replacements {
            let regex = try! NSRegularExpression(pattern: pattern, options: [])
            regex.enumerateMatches(in: backingStore.string, options: [], range: searchRange) {
                match, flags, stop in
                guard let match = match else { return }
                // apply the style
                let matchRange = match.rangeAt(1)
                self.addAttributes(attributes as! [String : Any], range: matchRange)
                
                // reset the style to the original
                let maxRange = matchRange.location + matchRange.length
                if maxRange + 1 < self.length {
                    self.addAttributes(normalAttrs, range: NSMakeRange(maxRange, 1))
                }
            }
        }
    }
    
    func performReplacementsForRange(_ changedRange: NSRange) {
        var extendedRange = NSUnionRange(changedRange, NSString(string: backingStore.string).lineRange(for: NSMakeRange(changedRange.location, 0)))
        extendedRange = NSUnionRange(changedRange, NSString(string: backingStore.string).lineRange(for: NSMakeRange(NSMaxRange(changedRange), 0)))
        applyStylesToRange(extendedRange)
    }
    
    override func processEditing() {
        performReplacementsForRange(self.editedRange)
        super.processEditing()
    }
    
    func createAttributesForFontStyle(_ style: String, withTrait trait: UIFontDescriptorSymbolicTraits) -> [AnyHashable: Any] {
        let fontDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: UIFontTextStyle.body)
        let descriptorWithTrait = fontDescriptor.withSymbolicTraits(trait)
        let font = UIFont(descriptor: descriptorWithTrait!, size: 0)
        return [NSFontAttributeName : font]
    }
    
    func createHighlightPatterns() {
        let scriptFontDescriptor = UIFontDescriptor(fontAttributes: [UIFontDescriptorFamilyAttribute : "Zapfino"])
        
        // 1. base our script font on the preferred body font size
        let bodyFontDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: UIFontTextStyle.body)
        let bodyFontSize = bodyFontDescriptor.fontAttributes[UIFontDescriptorSizeAttribute] as! NSNumber
        let scriptFont = UIFont(descriptor: scriptFontDescriptor, size: CGFloat(bodyFontSize.floatValue))
        
        // 2. create the attributes
        let boldAttributes = createAttributesForFontStyle(UIFontTextStyle.body.rawValue, withTrait:.traitBold)
        let italicAttributes = createAttributesForFontStyle(UIFontTextStyle.body.rawValue, withTrait:.traitItalic)
        let strikeThroughAttributes = [NSStrikethroughStyleAttributeName : 1]
        let scriptAttributes = [NSFontAttributeName : scriptFont]
        let redTextAttributes = [NSForegroundColorAttributeName : UIColor.red]
        
        // construct a dictionary of replacements based on regexes
        replacements = [
            "(\\*\\w+(\\s\\w+)*\\*)" : boldAttributes,
            "(_\\w+(\\s\\w+)*_)" : italicAttributes,
            "([0-9]+\\.)\\s" : boldAttributes,
            "(-\\w+(\\s\\w+)*-)" : strikeThroughAttributes,
            "(~\\w+(\\s\\w+)*~)" : scriptAttributes,
            "\\s([A-Z]{2,})\\s" : redTextAttributes
        ]
    }
    
    func update() {
        // update the highlight patterns
        createHighlightPatterns()
        
        // change the 'global' font
        let bodyFont = [NSFontAttributeName : UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)]
        addAttributes(bodyFont, range: NSMakeRange(0, length))
        
        // re-apply the regex matches
        applyStylesToRange(NSMakeRange(0, length))
    }
    
}
