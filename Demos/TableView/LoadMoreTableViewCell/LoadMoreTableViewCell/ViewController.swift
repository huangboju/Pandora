//
//  ViewController.swift
//  LoadMoreTableViewCell
//
//  Created by hengchengfei on 15/9/29.
//  Copyright © 2015年 cfs. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!

    // 默认Label可收缩高度
    let defaultCollapseHeight: CGFloat = 86
    let labelMaxWidth = UIScreen.mainScreen().bounds.size.width - 16

    var expandedIndexpaths: [NSIndexPath]!
    let datasources: [String] = ["The first step to creating a fancy animation was creating a UITableViewCell (called BookCell) with flexible constraints. By flexible, I mean that no constraint was absolutely required. The cell included a yellow subview subview with a collapsible height constraint — the height constraint always has a constant of 0, and it initially has a priority of 999. Within the collapsible subview, no vertical constraints are required. We set the priority of all the internal vertical constraints to 998.", "用人单位法定节假日安排加班，应按不低于日或者小时工资基数的300％支付加班工资，休息日期间安排加班，应当安排同等时间补休，不能安排补休的，按照不低于日或者小时工资基数的200％支付加班工资。", "如《广东省工资支付条例》第三十五 条非因劳动者原因造成用人单位停工、停产，未超过一个工资支付周期（最长三十日）的，用人单位应当按照正常工作时间支付工资。超过一个工资支付周期的，可以根据劳动者提供的劳动，按照双方新约定的标准支付工资；用人单位没有安排劳动者工作的，应当按照不低于当地最低工资标准的百分之八十支付劳动者生活费，生活费发放至企业复工、复产或者解除劳动关系。", "来看看劳动法克林顿刷卡思考对方卡拉卡斯的楼房卡拉卡斯的疯狂拉萨的罚款 ", "中秋节、十一假期分为两类。一类是法定节假日，即9月30日(中秋节)、10月1日、2日、3日共四天为法定节假日;另一类是休息日，即10月4日至10月7日为休息日。", "2000(元)÷21.75(天)×200％×1(天)=183.9(元)"]

    override func viewDidLoad() {
        super.viewDidLoad()

        expandedIndexpaths = []

        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()
        tableView.tableHeaderView = UIView()
    }

    // cell自适应大小
    // http://stackoverflow.com/questions/28675025/self-sizing-cells-make-uitableview-jump
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }

    // MARK: - UITableViewDataSource,UITableViewDelegate
    func tableView(tableView _: UITableView, numberOfRowsInSection _: Int) -> Int {
        return datasources.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let s: String = datasources[indexPath.row]
        let size = NSString(string: s).boundingRectWithSize(CGSizeMake(labelMaxWidth, 9999), options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont.systemFontOfSize(16)], context: nil).size

        let cell = tableView.dequeueReusableCellWithIdentifier("cell1", forIndexPath: indexPath) as! BaseTableViewCell
        cell.txtLabel.text = s

        if size.height < defaultCollapseHeight {
            cell.isExpandable = false
        } else {
            cell.isExpandable = true

            if expandedIndexpaths.contains(indexPath) {
                cell.expanded = true
            } else {
                cell.expanded = false
            }
        }

        cell.expandClosure = { () -> Void in
            if !cell.expanded! {
                self.expandedIndexpaths.append(indexPath)
            } else {
                let index = self.expandedIndexpaths.indexOf(indexPath)
                self.expandedIndexpaths.removeAtIndex(index!)
            }
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
        }

        cell.selectionStyle = .None

        return cell
    }

    func tableView(tableView _: UITableView, willDisplayCell _: UITableViewCell, forRowAtIndexPath _: NSIndexPath) {
    }

    func tableView(tableView _: UITableView, didDeselectRowAtIndexPath _: NSIndexPath) {
    }
}
