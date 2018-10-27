//
//  SettingViewController.swift
//  GBPing
//
//  Created by 黄伯驹 on 2017/9/13.
//  Copyright © 2017年 黄伯驹. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "next", style: .plain, target: self, action: #selector(nextAction))
    }

    func nextAction() {
        let vc = UIStoryboard(name: "main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ViewController")
        navigationController?.pushViewController(vc, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
