//
//  CharacterLabel.swift
//  TextKitStudy
//
//  Created by steven on 3/11/16.
//  Copyright © 2016 Steven lv. All rights reserved.
//

import UIKit


typealias textAnimationClosure = ()->()

typealias effectAnimatableLayerColsure = (layer:CALayer) ->CALayer

typealias effectTextAnimationClosure = (layer:CALayer,duration:NSTimeInterval,delay:NSTimeInterval,isFinished:Bool)

class TextAnimationLabel: UILabel,NSLayoutManagerDelegate {
    
    var oldCharacterTextLayers:[CATextLayer] = []
    var newCharacterTextLayers:[CATextLayer] = []
    
    let textStorage:NSTextStorage = NSTextStorage(string: "")
    let textLayoutManager:NSLayoutManager = NSLayoutManager()
    let textContainer:NSTextContainer = NSTextContainer()
    
    var animationOut: textAnimationClosure?
    var animationIn:textAnimationClosure?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        textKitObjectSetup()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textKitObjectSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        textKitObjectSetup()
        fatalError("init(coder:) has not been implemented")
    }
    
    func textKitObjectSetup() {
        textStorage.addLayoutManager(textLayoutManager)
        textLayoutManager.addTextContainer(textContainer)
        textLayoutManager.delegate = self
        textContainer.size = bounds.size
        textContainer.maximumNumberOfLines = numberOfLines
        textContainer.lineBreakMode = lineBreakMode
    }
    
    override var lineBreakMode:NSLineBreakMode {
        get {
            return super.lineBreakMode
        }
        set {
            textContainer.lineBreakMode = newValue
            super.lineBreakMode = newValue
        }
    }
    
    override var numberOfLines:Int {
        get {
            return super.numberOfLines
        }
        set {
            textContainer.maximumNumberOfLines = newValue
            super.numberOfLines = newValue
        }
    }
    
    override var bounds: CGRect
        {
        get {
            return super.bounds
        }
        set {
            textContainer.size = newValue.size
            super.bounds = newValue
        }
    }
    
    override var textColor:UIColor! {
        get {
            return super.textColor
        }
        set {
            super.textColor = newValue
            let text = self.textStorage.string
            self.text = text
        }
    }
    
    override var text:String!{
        get {
            return super.text
        }
        set {
            super.text = text
            let attributedText = NSMutableAttributedString(string: newValue)
            let textRange = NSMakeRange(0, newValue.characters.count)
            attributedText.setAttributes([NSForegroundColorAttributeName:self.textColor], range: textRange)
            attributedText.setAttributes([NSFontAttributeName:self.font], range: textRange)
            let paragraphyStyle = NSMutableParagraphStyle()
            paragraphyStyle.alignment = self.textAlignment
            attributedText.addAttributes([NSParagraphStyleAttributeName:paragraphyStyle], range: textRange)
            self.attributedText = attributedText
        }
        
    }
    
    override var attributedText:NSAttributedString!{
        get {
           return self.textStorage as NSAttributedString
        }
        set{
            cleanOutOldCharacterTextLayers()
            oldCharacterTextLayers = Array(newCharacterTextLayers)
            textStorage.setAttributedString(newValue)
            
            self.startAnimation { () -> () in
            }
            self.endAnimation(nil)
        }
        
    }
    
    
    //MARK:NSLayoutManagerDelegate
    func layoutManager(layoutManager: NSLayoutManager, didCompleteLayoutForTextContainer textContainer: NSTextContainer?, atEnd layoutFinishedFlag: Bool) {
        calculateTextLayers()
        print("\(textStorage.string)")
    }
    
    
    //MARK:CalculateTextLayer
    func calculateTextLayers()
    {
        newCharacterTextLayers.removeAll(keepCapacity: false)
        let attributedText = textStorage.string
        let wordRange = NSMakeRange(0, attributedText.characters.count)
        let attributedString = self.internalAttributedText();
        let layoutRect = textLayoutManager.usedRectForTextContainer(textContainer)
        var index = wordRange.location
        let totalLength = NSMaxRange(wordRange)
        while index < totalLength
        {
            let glyphRange = NSMakeRange(index, 1)
            let characterRange = textLayoutManager.characterRangeForGlyphRange(glyphRange, actualGlyphRange: nil)
            let textContainer = textLayoutManager.textContainerForGlyphAtIndex(index, effectiveRange: nil)
            var glyphRect = textLayoutManager.boundingRectForGlyphRange(glyphRange, inTextContainer: textContainer!)
            
            let kerningRange = textLayoutManager.rangeOfNominallySpacedGlyphsContainingIndex(index)
            if kerningRange.location == index && kerningRange.length > 1 {
                if newCharacterTextLayers.count > 0 {
                    //如果前一个textlayer的frame.size.width不变大的话，当前的textLayer会遮挡住字体的一部分，比如“You”的Y右上角会被切掉一部分
                    let previousLayer = newCharacterTextLayers[newCharacterTextLayers.endIndex - 1]
                    var frame = previousLayer.frame
                    frame.size.width += CGRectGetMaxX(glyphRect) - CGRectGetMaxX(frame)
                    previousLayer.frame = frame
//                    previousLayer.borderColor = UIColor.blueColor().CGColor
//                    previousLayer.borderWidth = 4.0

                }
            }
            
            //中间垂直
            glyphRect.origin.y += (self.bounds.size.height/2)-(layoutRect.size.height/2)
            
            //打印 font的metric信息
//            let attributedCharacter = attributedString.attributedSubstringFromRange(characterRange)
//            let font = attributedCharacter.attribute(NSFontAttributeName, atIndex: 0, effectiveRange: nil) as! UIFont
//            print("\ncharacter:\(attributedCharacter.string)||lineHeight:\(font.lineHeight)||capHeight:\(font.capHeight)||descender:\(font.descender)||Ascender:\(font.ascender)||x-height:\(font.xHeight)")
            
            let textLayer = CATextLayer(frame: glyphRect, string: attributedString.attributedSubstringFromRange(characterRange));
            self.initialTextLayerAttributes(textLayer)
//            textLayer.borderColor = UIColor.redColor().CGColor
//            textLayer.borderWidth = 1.0
            
            layer.addSublayer(textLayer);
            newCharacterTextLayers.append(textLayer);
            
            index += characterRange.length
        }
    }
    
    func cleanOutOldCharacterTextLayers()
    {
        for textLayer in oldCharacterTextLayers
        {
            textLayer.removeFromSuperlayer()

        }
        oldCharacterTextLayers.removeAll(keepCapacity: false)
    }
    
    func internalAttributedText() -> NSMutableAttributedString! {
        let wordRange = NSMakeRange(0, textStorage.string.characters.count);
        let attributedText = NSMutableAttributedString(string: textStorage.string);
        attributedText.addAttribute(NSForegroundColorAttributeName , value: self.textColor.CGColor, range:wordRange);
        attributedText.addAttribute(NSFontAttributeName , value: self.font, range:wordRange);
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = self.textAlignment
        attributedText.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range: wordRange)
        
        return attributedText;
    }
    
    func initialTextLayerAttributes(textLayer: CATextLayer) {
        textLayer.opacity = 0.0
    }

    
    
    //MARK:TextAnimation
    func startAnimation(animationClosure:textAnimationClosure?)
    {
        
        var longestAnimationDuration = 0.0
        var longestAniamtionIndex = -1
        var index = 0
        
        for textlayer in oldCharacterTextLayers
        {
            
//            let duration = NSTimeInterval(arc4random()%200/100)+0.25
            let duration = (NSTimeInterval(arc4random()%100)/125.0)+0.35

            let delay = NSTimeInterval(arc4random_uniform(100)/500)
            let distance = CGFloat(arc4random()%50)+25
            let angle = CGFloat((Double(arc4random())/M_PI_2)-M_PI_4)

            var transform = CATransform3DMakeTranslation(0, distance, 0)
            transform = CATransform3DRotate(transform, angle, 0, 0, 1)
            
            if delay+duration > longestAnimationDuration
            {
                longestAnimationDuration = delay+duration
                longestAniamtionIndex = index
            }
            
            TELayerAniamtion.textLayerAnimation(textlayer, durationTime: duration, delayTime: delay, animationClosure: { (layer) -> CALayer in
                layer.transform = transform
                layer.opacity = 0.0
                return layer
                }, completion: {[weak self](finished) -> () in
                    textlayer.removeFromSuperlayer()
                    if let textLayers = self?.oldCharacterTextLayers
                    {
                        
                        if textLayers.count > longestAniamtionIndex  && textlayer == textLayers[longestAniamtionIndex]
                        {
                            if let animationOut = animationClosure
                            {
                                animationOut()
                            }
                        }
                    }
            })
            index += 1
        }
        
        
    }
    
    func endAnimation(animationClosure:textAnimationClosure?)
    {
        
        
        for textLayer in newCharacterTextLayers
        {
//            textLayer.opacity = 0.0
            let duration = NSTimeInterval(arc4random()%200/100)+0.25
            let delay = 0.06//NSTimeInterval(arc4random_uniform(100)/500)
            
            TELayerAniamtion.textLayerAnimation(textLayer, durationTime: duration, delayTime: delay, animationClosure: { (layer) -> CALayer in
                layer.opacity = 1.0
                return layer
                }, completion: { (finished) -> () in
                    if let animationIn = animationClosure {
                        animationIn()
                    }

            })
        }
        
    }

    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}

//MARK: CATextLayer extension

extension CATextLayer {
    convenience init(frame:CGRect, string: NSAttributedString)
    {
        self.init()
        self.contentsScale = UIScreen.mainScreen().scale
        self.frame = frame
        self.string = string
    }
}
