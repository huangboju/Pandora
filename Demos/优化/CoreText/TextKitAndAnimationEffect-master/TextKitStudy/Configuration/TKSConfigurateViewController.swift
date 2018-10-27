//
//  TKSConfigurateViewController.swift
//  TextKitStudy
//
//  Created by steven on 2/4/16.
//  Copyright © 2016 Steven lv. All rights reserved.
//

import UIKit

class TKSConfigurateViewController: UIViewController {

    @IBOutlet weak var viewContainerTwo: UIView!
    
    @IBOutlet weak var viewContainerThree: UIView!
    
    @IBOutlet weak var textViewOne: UITextView!
    
    @IBOutlet weak var textViewTwo: UITextView!
    
    @IBOutlet weak var textViewThree: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storageTextOne:NSTextStorage = self.textViewOne.textStorage
        
        let stringULR:String? = NSBundle.mainBundle().pathForResource("lorem", ofType: "txt")
        
        if let urlStr:String = stringULR
        {
            do
            {
                let content:String   = try NSString(contentsOfFile: urlStr, encoding: NSUTF8StringEncoding) as String
                print("\(content)")
                
                storageTextOne.replaceCharactersInRange(NSMakeRange(0, 0), withString: content)
                
                let otherLayoutManager:NSLayoutManager = NSLayoutManager()
                storageTextOne.addLayoutManager(otherLayoutManager)
                
                let otherTextContainer:NSTextContainer = NSTextContainer()
                otherLayoutManager.addTextContainer(otherTextContainer)
                
                let otherTextView:UITextView = UITextView(frame: CGRectZero, textContainer: otherTextContainer)
                otherTextView.backgroundColor = UIColor.purpleColor()
                
//                otherTextView.autoresizingMask = [.FlexibleWidth,.FlexibleHeight]
                otherTextView.scrollEnabled = false
                
                self.viewContainerTwo.addSubview(otherTextView)
                
                otherTextView.translatesAutoresizingMaskIntoConstraints = false
                
                self.viewContainerTwo.addConstraints([
                    NSLayoutConstraint(item: otherTextView, attribute: .Top, relatedBy: .Equal, toItem: self.viewContainerTwo, attribute: .Top, multiplier: 1, constant: 0),
                    NSLayoutConstraint(item: otherTextView, attribute: .Bottom, relatedBy: .Equal, toItem: self.viewContainerTwo, attribute: .Bottom, multiplier: 1, constant: 0),
                    NSLayoutConstraint(item: otherTextView, attribute: .Left, relatedBy: .Equal, toItem: self.viewContainerTwo, attribute: .Left, multiplier: 1, constant: 0),
                    NSLayoutConstraint(item: otherTextView, attribute: .Right, relatedBy: .Equal, toItem: self.viewContainerTwo, attribute: .Right, multiplier: 1, constant: 0)
                    ])
                
                let thirdTextContainer:NSTextContainer = NSTextContainer()
                otherLayoutManager.addTextContainer(thirdTextContainer)
                
                let thirdTextView:UITextView = UITextView(frame: CGRectZero, textContainer: thirdTextContainer)
//                thirdTextView.autoresizingMask = [.FlexibleWidth,.FlexibleHeight]
                self.viewContainerThree.addSubview(thirdTextView)
                
                thirdTextView.translatesAutoresizingMaskIntoConstraints = false
                self.viewContainerThree.addConstraints(
                    [
                        NSLayoutConstraint(item: thirdTextView, attribute: .Top, relatedBy: .Equal, toItem: self.viewContainerThree, attribute: .Top, multiplier: 1.0, constant: 0.0),
                        NSLayoutConstraint(item: thirdTextView, attribute: .Bottom, relatedBy: .Equal, toItem: self.viewContainerThree, attribute: .Bottom, multiplier: 1.0, constant: 0.0),
                         NSLayoutConstraint(item: thirdTextView, attribute: .Left, relatedBy: .Equal, toItem: self.viewContainerThree, attribute: .Left, multiplier: 1.0, constant: 0.0),
                         NSLayoutConstraint(item: thirdTextView, attribute: .Right, relatedBy: .Equal, toItem: self.viewContainerThree, attribute: .Right, multiplier: 1.0, constant: 0.0)
                    ]
                )
                
                
            }
            catch let error as NSError
            {
                print("\(error)")
            }
            

        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
