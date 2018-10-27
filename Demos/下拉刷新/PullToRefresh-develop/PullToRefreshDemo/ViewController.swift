//
//  ViewController.swift
//  PullToRefresh
//
//  Created by Anastasiya Gorban on 5/19/15.
//  Copyright (c) 2015 Yalantis. All rights reserved.
//

import PullToRefresh
import UIKit

private let PageSize = 20

class ViewController: UIViewController {
    
    @IBOutlet fileprivate var tableView: UITableView!
    fileprivate var dataSourceCount = PageSize
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPullToRefresh()
    }
    
    deinit {
        tableView.removePullToRefresh()
    }
    
    @IBAction fileprivate func startRefreshing() {
        tableView.headerStartRefreshing()
    }
}

private extension ViewController {

    func setupPullToRefresh() {
        tableView.addHeaderRefresh() { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self?.dataSourceCount = PageSize
                self?.tableView.headerEndRefreshing()
            }
        }

        tableView.addFooterRefresh { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self?.dataSourceCount += PageSize
                self?.tableView.reloadData()
                self?.tableView.footerEndRefreshing()
            }
        }
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSourceCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }
}
