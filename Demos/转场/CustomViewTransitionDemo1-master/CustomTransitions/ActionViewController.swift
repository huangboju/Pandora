//
//  ActionViewController.swift
//  CustomTransitions
//
//  Created by Joyce Echessa on 3/2/15.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

import UIKit

// http://www.appcoda.com.tw/custom-view-controller-transitions-tutorial/

class ActionViewController: UIViewController {

    @IBAction func dismiss(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

}
