//
//  HomeTableViewController.swift
//  WBWaterfallFlow
//
//  Created by caowenbo on 16/2/20.
//  Copyright © 2016年 曹文博. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {

    private lazy var tests: [String] = {
        [String(FirstCollectionViewController), String(WaterFallFlowController)]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func tableView(tableView _: UITableView, numberOfRowsInSection _: Int) -> Int {

        return tests.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)

        cell.textLabel?.text = tests[indexPath.row]

        return cell
    }

    // MARK: - Table view Delegate
    override func tableView(tableView _: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        var collectionController: UIViewController?

        switch indexPath.row {

        case 0: collectionController = FirstCollectionViewController()
        case 1: collectionController = WaterFallFlowController()

        default: return
        }

        navigationController?.pushViewController(collectionController!, animated: true)
    }
}

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
