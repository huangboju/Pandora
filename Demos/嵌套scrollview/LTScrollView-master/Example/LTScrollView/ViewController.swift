//
//  ViewController.swift
//  LTScrollView
//
//  Created by 1282990794@qq.com on 02/03/2018.
//  Copyright (c) 2018 1282990794@qq.com. All rights reserved.
//
//  如有疑问，欢迎联系本人QQ: 1282990794
//
//  ScrollView嵌套ScrolloView解决方案（初级、进阶)， 支持OC/Swift
//
//  github地址: https://github.com/gltwy/LTScrollView
//
//  clone地址:  https://github.com/gltwy/LTScrollView.git
//

import UIKit

class ViewController: UIViewController, LTTableViewProtocal {
    
    private let datas = ["基础版（LTSimple）", "进阶版（LTAdvanced）"]
    
    private lazy var tableView: UITableView = {
        let tableView: UITableView = tableViewConfig(self, self, nil)
        tableView.frame.origin.y = 64
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "首页"
        view.backgroundColor = UIColor.white
        view.addSubview(tableView)
        if #available(iOS 11.0, *) {
            self.tableView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cellWithTableView(tableView)
        cell.textLabel?.text = datas[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let viewControllers = [LTSimpleManagerDemo(), LTAdvancedManagerDemo()]
        pushVc(viewControllers[indexPath.row], index: indexPath.row)
    }
    
    private func pushVc(_ VC: UIViewController, index: Int) {
        VC.title = datas[index]
        navigationController?.pushViewController(VC, animated: true)
    }
}

