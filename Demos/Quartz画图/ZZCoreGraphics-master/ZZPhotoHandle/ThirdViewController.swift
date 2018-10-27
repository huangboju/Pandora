//
//  ThirdViewController.swift
//  ZZPhotoHandle
//
//  Created by duzhe on 16/2/28.
//  Copyright © 2016年 dz. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let ctView = CGView5(frame:CGRect(x: 0,y: 64, width: view.frame.width, height: 100))
        ctView.backgroundColor = UIColor.white
        view.addSubview(ctView)
        
        let ctView1 = CGView6(frame:CGRect(x: 0,y: 100,width: view.frame.width,height: view.frame.height-100))
        ctView1.backgroundColor = UIColor.white
        view.addSubview(ctView1)
    }
    
}
