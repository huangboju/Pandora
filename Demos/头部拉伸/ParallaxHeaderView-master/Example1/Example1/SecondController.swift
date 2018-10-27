//
//  ViewController.swift
//  Example1
//
//  Created by wl on 15/11/5.
//  Copyright © 2015年 wl. All rights reserved.
//

import UIKit

class SecondController: UITableViewController, ParallaxHeaderViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.setMyBackgroundColor(UIColor(red: 0/255.0, green: 130/255.0, blue: 210/255.0, alpha: 0))
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.width, height: 100))
        imageView.image = UIImage(named: "71c8bcd3d99958de45ed87b8fc213224")
        imageView.contentMode = .scaleAspectFill
        
        let heardView = ParallaxHeaderView(style: .thumb, contentView: imageView, headerViewSize: CGSize(width: tableView.frame.width, height: 64), maxOffsetY: 93, delegate: self)
        automaticallyAdjustsScrollViewInsets = false

        tableView.tableHeaderView = heardView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 20
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        cell?.textLabel?.text = "test\(indexPath.row)"

        return cell!
    }

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let heardView = self.tableView.tableHeaderView as! ParallaxHeaderView
        heardView.layoutHeaderViewWhenScroll(scrollView.contentOffset)
        
    }
}

