//
//  ViewController.swift
//  Example1
//
//  Created by wl on 15/11/5.
//  Copyright © 2015年 wl. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, ParallaxHeaderViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.setMyBackgroundColor(UIColor(red: 0/255.0, green: 130/255.0, blue: 210/255.0, alpha: 0))
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.width, height: 100))
        imageView.image = UIImage(named: "ba1ec0437cc8d5367a516ff69b01ea89")
        imageView.contentMode = .scaleAspectFill

        let heardView = ParallaxHeaderView(style: .fill(UIImage(named: "ba1ec0437cc8d5367a516ff69b01ea89")!), contentView: imageView, headerViewSize: CGSize(width: tableView.bounds.width, height: 100), maxOffsetY: -220, delegate: self)

        tableView.tableHeaderView = heardView

//        let dog = DogView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
//        tableView.addSubview(dog)
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

