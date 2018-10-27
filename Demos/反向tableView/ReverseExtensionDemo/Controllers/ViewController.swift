//
//  ViewController.swift
//  ReverseExtensionDemo
//
//  Created by SOTSYS022 on 27/04/17.
//  Copyright © 2017 SOTSYS022s. All rights reserved.
//

import UIKit
import ReverseExtension

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet var reverseTableView: UITableView!
    
    private var numberOfCell : Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        reverseTableView.re.dataSource = self
        
        reverseTableView.register(UINib(nibName: "ReverseTableViewCell", bundle: nil), forCellReuseIdentifier: "ReverseTableViewCell")

        reverseTableView.re.delegate = self
        reverseTableView.re.scrollViewDidReachTop = { scrollView in
            print("scrollViewDidReachTop")
        }
        reverseTableView.re.scrollViewDidReachBottom = { scrollView in
            print("scrollViewDidReachBottom")
        }
        reverseTableView.estimatedRowHeight = 56
        reverseTableView.rowHeight = UITableViewAutomaticDimension
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK:IBAction
    
    @IBAction func addCellTapped(_ sender: Any) {
        numberOfCell = numberOfCell + 1
        reverseTableView.beginUpdates()
        reverseTableView.re.insertRows(at: [IndexPath(row: numberOfCell - 1, section: 0)], with: .automatic)
        reverseTableView.endUpdates()
    }
    func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
    
    //MARK:UITableViewDataSource & Delegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("scrollView.contentOffset.y =", scrollView.contentOffset.y)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfCell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReverseTableViewCell", for: indexPath) as! ReverseTableViewCell
        cell.cellLabel.text = "\(indexPath.row)"
        cell.cellImageView.image = UIImage(named: "Dog\(indexPath.row%2).jpg")
        cell.backgroundColor = UIColor(red:   random(),
                                       green: random(),
                                       blue:  random(),
                                       alpha: 1.0)
        return cell
    }

}

