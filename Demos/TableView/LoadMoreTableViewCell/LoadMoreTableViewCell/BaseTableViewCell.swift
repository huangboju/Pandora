//
//  BaseTableViewCell.swift
//  LoadMoreTableViewCell
//
//  Created by hengchengfei on 15/9/29.
//  Copyright © 2015年 cfs. All rights reserved.
//

import UIKit

///
/// 设置Autolayout优先级时,切记一定要设置为750,800,不能是其他值如749,750
/// http://stackoverflow.com/questions/18422065/xcode-ib-storyboards-orientation-and-container-views
///

class BaseTableViewCell: UITableViewCell {

    typealias ExpandClosure = () -> Void

    @IBOutlet weak var txtLabel: UILabel!
    @IBOutlet weak var showAllButton: UIButton!

    // container view 高度的优先级约束
    @IBOutlet weak var containerViewHeightLayoutConstrain: NSLayoutConstraint!

    // container view相对于superview的bottom约束
    @IBOutlet weak var containerViewBottomLayoutConstrain: NSLayoutConstraint!

    var expandClosure: ExpandClosure?

    // 是否显示"收起"按钮
    let isShowCollapse: Bool = true

    // 收起或展开操作
    var expanded: Bool? {
        didSet {
            // 收起操作
            if !expanded! {
                containerViewHeightLayoutConstrain.priority = 800
                showAllButton.hidden = false
                showAllButton.setTitle("显示全部", forState: .Normal)
                showAllButton.setImage(UIImage(named: "down"), forState: .Normal)

            } else {
                // 展开操作
                containerViewHeightLayoutConstrain.priority = 750 // < 降低container view的高度约束优先级，使其小于UILabel的Vertical Constrain（800）

                showAllButton.setTitle("收起", forState: .Normal)
                showAllButton.setImage(UIImage(named: "up"), forState: .Normal)
                if !isShowCollapse {
                    containerViewBottomLayoutConstrain.priority = 1000
                    showAllButton.hidden = true
                }
            }
        }
    }

    // 是否可以收缩
    var isExpandable: Bool? {
        didSet {
            if !isExpandable! {
                containerViewBottomLayoutConstrain.priority = 100.0 // 不可收缩时，距离底部的约束由相对于按钮改变为相对于superview（->uibutton 750 ->superview 1000）
                containerViewHeightLayoutConstrain.priority = 250 // 降低container view的高度约束优先级，使其小于UILabel的Vertical Constrain（800）
                showAllButton.hidden = true
            } else {
                showAllButton.hidden = false
            }
        }
    }

    @IBAction func didClickExpandOrCollapse() {
        if expandClosure != nil {
            expandClosure!()
        }
    }
}
