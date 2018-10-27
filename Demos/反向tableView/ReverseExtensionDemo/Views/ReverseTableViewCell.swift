//
//  reverseTableViewCell.swift
//  ReverseExtensionDemo
//
//  Created by SOTSYS022 on 27/04/17.
//  Copyright © 2017 SOTSYS022s. All rights reserved.
//

import UIKit

class ReverseTableViewCell: UITableViewCell {

    @IBOutlet var cellImageView: UIImageView!
    @IBOutlet var cellLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
