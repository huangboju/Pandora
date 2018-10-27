//
//  CustomCell.swift
//  GBPing
//
//  Created by 黄伯驹 on 2017/9/13.
//  Copyright © 2017年 黄伯驹. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {
    
    @IBOutlet weak var ipAddressLabel: UILabel!

    @IBOutlet weak var averageLabel: UILabel!
    @IBOutlet weak var consumeLabel: UILabel!
    
    @IBOutlet weak var indexLabel: UILabel!
    var item: PingResult? {
        didSet {
            ipAddressLabel.text = "IP: \(item?.ipAddress ?? "")"

            let format: (Double?) -> String = { String(format: "%.3f", $0 ?? 0) }

            averageLabel.text = "ping: \(format(item?.minAverage))ms"
            consumeLabel.text = "测试耗时: \(format(item?.consumimg))s"
        }
    }
}
