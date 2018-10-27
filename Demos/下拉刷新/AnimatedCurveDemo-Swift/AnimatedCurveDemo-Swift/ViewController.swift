//
//  ViewController.swift
//  AnimatedCurveDemo-Swift
//
//  Created by Kitten Yang on 1/18/16.
//  Copyright © 2016 Kitten Yang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let contentOffset = 50.0
    let targetHeight  = 500.0
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "testCell")
        tableView.layoutIfNeeded()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let headerView = CurveRefreshHeaderView(associatedScrollView: self.tableView, withNavigationBar: true)
        headerView.triggerPulling()
        headerView.refreshingBlock = { ()->() in
            let delayTime = DispatchTime.now() + 2
            DispatchQueue.main.asyncAfter(deadline: delayTime){ _ in
                headerView.stopRefreshing()
            }
        }

        let footerView = CurveRefreshFooterView(associatedScrollView: self.tableView, withNavigationBar: true)
        footerView.refreshingBlock = { ()->() in
            let delayTime = DispatchTime.now() + 2
            DispatchQueue.main.asyncAfter(deadline: delayTime){ _ in
                footerView.stopRefreshing()
            }
        }
    }

}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let testCell = tableView.dequeueReusableCell(withIdentifier: "testCell", for: indexPath)
        testCell.textLabel?.text = "第\(indexPath.row)条"
        return testCell
    }
}
