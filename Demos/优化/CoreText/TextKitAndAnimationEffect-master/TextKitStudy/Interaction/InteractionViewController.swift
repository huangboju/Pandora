//
//  InteractionViewController.swift
//  TextKitStudy
//
//  Created by steven on 3/7/16.
//  Copyright © 2016 Steven lv. All rights reserved.
//

import UIKit

class InteractionViewController: UIViewController,UITextViewDelegate {

    var circleView:TextCircleView = TextCircleView()
    
    @IBOutlet weak var textView: UITextView!
    
    var panOffset:CGPoint = CGPointZero

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reloadText()
        self.configuration()
        self.updateExclusionPaths()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.updateExclusionPaths()

    }
    
    func reloadText()
    {
        let path:String? = NSBundle.mainBundle().pathForResource("lorem", ofType: "txt")
        guard path != nil else { return }
        let content:String? = try? String(contentsOfFile: path!, usedEncoding: nil)
        guard content != nil else { return }
        self.textView.textStorage.replaceCharactersInRange(NSMakeRange(0, 0), withString: content!)
    }
    
    func configuration()
    {
        self.textView.addSubview(self.circleView)
        self.circleView.addGestureRecognizer(
            UIPanGestureRecognizer(
                                target: self,
                                action: #selector(InteractionViewController.panGestureRecognizer(_:))
                                 )
        )
//        self.circleView.opaque = false
        self.circleView.frame = CGRectMake((UIScreen.mainScreen().bounds.width-234)/2, (UIScreen.mainScreen().bounds.height-234)/2, 234, 234)
        self.circleView.clipsToBounds = true
        self.circleView.backgroundColor = UIColor.clearColor()
        self.textView.layoutManager.hyphenationFactor = 1.0;

    }
    
    
    
    func panGestureRecognizer(panGestureRecognizer:UIPanGestureRecognizer)
    {
        
        //MARK:PlanA
        /*
        //这个是手指在self.view这个coordinate system上的location
        let lastLocation:CGPoint = panGestureRecognizer.locationInView(self.view)
        if panGestureRecognizer.state == .Began
        {
            //这个是手指在self.circleView这个coordinate system上的location
            panOffset = panGestureRecognizer.locationInView(self.circleView)
            print("began:\(panOffset)")
        }
        if panGestureRecognizer.state == .Changed
        {
            print("changed:\(panOffset)")

        }
        if panGestureRecognizer.state == .Ended
        {
            print("Ended:\(panOffset)")

        }
        let center:CGPoint = CGPointMake(lastLocation.x-panOffset.x+self.circleView.frame.size.width/2,lastLocation.y-panOffset.y+self.circleView.frame.size.height/2)
        self.circleView.center = center
        */
        //MARK:PlanB
        if panGestureRecognizer.state == .Changed || panGestureRecognizer.state == .Ended
        {
            let offsetInCircle = panGestureRecognizer.translationInView(self.circleView)
            print("circleViewOffset:\(offsetInCircle)")
            let offsetInView = panGestureRecognizer.translationInView(self.view)
            print("viewOffset:\(offsetInView)")
            self.circleView.center.x += offsetInView.x
            self.circleView.center.y += offsetInView.y
            panGestureRecognizer.setTranslation(CGPointZero, inView: self.circleView)
        }
        self.updateExclusionPaths()
        
    }
    
    func updateExclusionPaths()
    {
        var ovalFrame = self.textView.convertRect(self.circleView.bounds, fromView: self.circleView)
        ovalFrame.origin.x -= self.textView.textContainerInset.left
        ovalFrame.origin.y -= self.textView.textContainerInset.top
        let bezierPaht:UIBezierPath = UIBezierPath(ovalInRect: ovalFrame)
        self.textView.textContainer.exclusionPaths = [bezierPaht]
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
