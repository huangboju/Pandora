//
//  ViewController.swift
//  AnimationBegin
//
//  Created by jones on 5/5/16.
//  Copyright © 2016 jones. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UINavigationControllerDelegate {

    var viewcontroller:NewViewController = NewViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Main Viewcontroller";
        self.view.backgroundColor = UIColor.blue
        navigationController!.delegate = self
    }

    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning?{
        let transitionAnim:TransitionAnim = TransitionAnim()
        return transitionAnim
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.navigationController?.pushViewController(viewcontroller, animated: false)
    }

}

