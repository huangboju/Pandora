//
//  ForthViewController.swift
//  ZZPhotoHandle
//
//  Created by duzhe on 16/2/28.
//  Copyright © 2016年 dz. All rights reserved.
//

import UIKit

class ForthViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let ctView = CGView7(frame:CGRect(x: 0,y: 64,width: view.frame.width,height: view.frame.height))
        view.addSubview(ctView)
        ctView.backgroundColor = UIColor.white
    }
    
}
