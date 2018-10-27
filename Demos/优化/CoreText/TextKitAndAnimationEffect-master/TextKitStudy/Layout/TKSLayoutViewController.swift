//
//  TKSLayoutViewController.swift
//  TextKitStudy
//
//  Created by steven on 2/21/16.
//  Copyright © 2016 Steven lv. All rights reserved.
//

import UIKit

class TKSLayoutViewController: UIViewController, NSLayoutManagerDelegate{
    
    private lazy var textLayoutManager:TKSOutliningLayoutManager = {
        let layoutManager = TKSOutliningLayoutManager()
        layoutManager.delegate = self
        return layoutManager
    }()
    
    private lazy var textStorage:TKSLinkDetectingTextStorage = {
        let path:String = NSBundle.mainBundle().pathForResource("layout", ofType: "txt")!
        let textStorage:TKSLinkDetectingTextStorage = TKSLinkDetectingTextStorage()
        
        do{
            let text:String = try String(contentsOfFile: path)
            let attributed:NSMutableAttributedString = NSMutableAttributedString(string: text)
            textStorage.setAttributedString(attributed)
        }catch _
        {
            print("Something went wrong!")
            let textStorage:TKSLinkDetectingTextStorage = TKSLinkDetectingTextStorage()
        }
        return textStorage
    }()
    
    private lazy var textView:UITextView = {
        self.textStorage.addLayoutManager(self.textLayoutManager)
        let textContainer:NSTextContainer = NSTextContainer()
        self.textLayoutManager.addTextContainer(textContainer)
        let textView = UITextView(frame: CGRectZero, textContainer: textContainer)
        return textView
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.addSubview(self.textView)
        self.textView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraints(
            [
            NSLayoutConstraint(item: self.textView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 20),

            NSLayoutConstraint(item: self.view, attribute: .Bottom, relatedBy: .Equal, toItem: self.textView, attribute: .Bottom, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: self.view, attribute: .Leading, relatedBy: .Equal, toItem: self.textView, attribute: .Leading, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: self.view, attribute: .Trailing, relatedBy: .Equal, toItem: self.textView, attribute: .Trailing, multiplier: 1, constant: 0)
            ]
        )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - NSLayoutManager delegate
    
    func layoutManager(layoutManager: NSLayoutManager, lineSpacingAfterGlyphAtIndex glyphIndex: Int, withProposedLineFragmentRect rect: CGRect) -> CGFloat {
        return CGFloat(glyphIndex/100)
    }
    
    func layoutManager(layoutManager: NSLayoutManager, shouldBreakLineByWordBeforeCharacterAtIndex charIndex: Int) -> Bool {
        
        var rangePointer:NSRange = NSMakeRange(NSNotFound, 0)
        
        let URLLink:NSURL? = layoutManager.textStorage?.attribute(NSLinkAttributeName, atIndex: charIndex, effectiveRange: &rangePointer) as? NSURL
        if (URLLink != nil) && charIndex > rangePointer.location && charIndex <= NSMaxRange(rangePointer)
        {
            return false
        }else
        {
            return true
        }
    }
    
    func layoutManager(layoutManager: NSLayoutManager, paragraphSpacingAfterGlyphAtIndex glyphIndex: Int, withProposedLineFragmentRect rect: CGRect) -> CGFloat {
        return 100
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
