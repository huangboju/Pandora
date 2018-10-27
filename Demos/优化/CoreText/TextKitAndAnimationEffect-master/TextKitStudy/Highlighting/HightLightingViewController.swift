//
//  HightLightingViewController.swift
//  TextKitStudy
//
//  Created by steven on 2/4/16.
//  Copyright © 2016 Steven lv. All rights reserved.
//

import UIKit

class HightLightingViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!

    @IBOutlet weak var bottomInSet: NSLayoutConstraint!
    
    private lazy var textSotrage:HightLightingTextStorage = {
        let _textStorage:HightLightingTextStorage = HightLightingTextStorage()
        return _textStorage
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textSotrage.addLayoutManager(self.textView.layoutManager)
        self.textSotrage.replaceCharactersInRange(NSMakeRange(0, 0), withString: try! String(contentsOfFile: NSBundle.mainBundle().pathForResource("iText", ofType: "txt")!, encoding: NSUTF8StringEncoding))

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HightLightingViewController.keyboardWillShowOrHide(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HightLightingViewController.keyboardWillShowOrHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func keyboardWillShowOrHide(notifcation:NSNotification)
    {
        
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
