//
//  ViewController.swift
//  TableSearch
//
//  Created by xiAo_Ju on 2019/2/28.
//  Copyright © 2019 黄伯驹. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController {
    
    // MARK: - Types
    
    static let nibName = "TableCell"
    static let tableViewCellIdentifier = "cellID"
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: BaseTableViewController.nibName, bundle: nil)
        
        // Required if our subclasses are to use `dequeueReusableCellWithIdentifier(_:forIndexPath:)`.
        tableView.register(nib, forCellReuseIdentifier: BaseTableViewController.tableViewCellIdentifier)
    }
    
    // MARK: - Configuration
    
    func configureCell(_ cell: UITableViewCell, forProduct product: Product) {
        cell.textLabel?.text = product.title
        
        /*
         Build the price and year string.
         Use NSNumberFormatter to get the currency format out of this NSNumber (product.introPrice).
         */
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.formatterBehavior = .default
        
        let priceString = numberFormatter.string(from: NSNumber(value: product.introPrice))
        
        cell.detailTextLabel?.text = "\(priceString!) | \(product.yearIntroduced)"
    }
}
