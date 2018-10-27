//
//  TextEffectsViewController.swift
//  TextKitStudy
//
//  Created by steven on 3/11/16.
//  Copyright © 2016 Steven lv. All rights reserved.
//

import UIKit

class TextEffectsViewController: UIViewController {

    
    var textEffectLabel: TextAnimationLabel!
    var changeText:UIButton = UIButton(type: UIButtonType.System)
    var backgroundImage:UIImageView = UIImageView()
    
    private var textArray = [
        "What is design?",
        "Design Code By Swift",
        "Design is not just",
        "what it looks like",
        "and feels like.",
        "Hello,Swift",
        "is how it works.",
        "- Steve Jobs",
        "Older people",
        "sit down and ask,",
        "'What is it?'",
        "but the boy asks,",
        "'What can I do with it?'.",
        "- Steve Jobs",
        "Swift",
        "Objective-C",
        "iPhone", "iPad", "Mac Mini",
        "MacBook Pro", "Mac Pro",
        "爱老婆"
    ]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.backgroundViewSetup()
        
        let frame = CGRectMake(0, 100, UIScreen.mainScreen().bounds.width, 100)
        self.textEffectLabel = TextAnimationLabel(frame: frame)
        self.view.addSubview(self.textEffectLabel)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.textEffectLabel.font = UIFont.systemFontOfSize(38.0)//UIFont(name: "Apple SD Gothic Neo", size: 38)
        self.textEffectLabel.numberOfLines = 5
        self.textEffectLabel.textAlignment = NSTextAlignment.Center
        self.textEffectLabel.text = "Yes,Hello World"
        self.textEffectLabel.textColor = UIColor.whiteColor()
        
        self.changeButtonSetup()
        
        print("OutSide:\(self.view.actionForLayer(self.view.layer, forKey: "backgroundColor"))")
        UIView.beginAnimations(nil, context: nil)
        print("InSide:\(self.view.actionForLayer(self.view.layer, forKey: "backgroundColor"))")
        UIView.commitAnimations()

        
        
        // Do any additional setup after loading the view.
    }
    
    func backgroundViewSetup()
    {
        
        self.backgroundImage.image = UIImage(named: "2.jpg")
        self.backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.backgroundImage)
        self.view.addConstraints(
            [
                NSLayoutConstraint(item: self.backgroundImage, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: self.backgroundImage, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: self.backgroundImage, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: self.backgroundImage, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0.0),
                
            ]
        )
        
        let maskView = UIView()
        maskView.alpha = 0.5
        maskView.backgroundColor = UIColor(red: 29.0/255.0, green: 29.0/255.0, blue: 29.0/255.0, alpha: 1.0)

        maskView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(maskView)
        self.view.addConstraints(
            [
                NSLayoutConstraint(item: maskView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: maskView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: maskView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: maskView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0.0),
                
            ]
        )

    }
    
    func changeButtonSetup()
    {
        changeText.addTarget(self, action: #selector(TextEffectsViewController.changeText(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        changeText.setTitle("Change Text", forState: UIControlState.Normal)
        //        changeText.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        changeText.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(changeText)
        self.view.addConstraints(
            [
                NSLayoutConstraint(item: changeText, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.LessThanOrEqual, toItem: self.textEffectLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 100),
                NSLayoutConstraint(item: changeText, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.LessThanOrEqual, toItem: self.view, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 100),
                NSLayoutConstraint(item: changeText, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 50),
                NSLayoutConstraint(item: changeText, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: -50),
                
            ]
        )

    }
    
    func changeText(sender:AnyObject?)
    {
        //        let picture = Int(arc4random_uniform(6))
        //        if picture > 0 && picture < 7
        //        {
        //            self.backgroundImage.image = UIImage(named: "\(picture).jpg")
        //        }
        let index = Int(arc4random_uniform(20))
        
        if index < textArray.count
        {
            let text:String = textArray[index]
            self.textEffectLabel.text = text
        }
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
