//
//  TableViewControllerDataSource.swift
//  Reducer
//
//  Created by 黄伯驹 on 2017/8/19.
//  Copyright © 2017年 黄伯驹. All rights reserved.
//

import UIKit

class TableViewControllerDataSource: NSObject, UITableViewDataSource {
    
    enum Section: Int {
        case input = 0, todos, max
    }

    var todos: [String]
    weak var owner: TableViewController?

    init(todos: [String], owner: TableViewController?) {
        self.todos = todos
        self.owner = owner
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.max.rawValue
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = Section(rawValue: section) else {
            fatalError()
        }
        switch section {
        case .input: return 1
        case .todos: return todos.count
        case .max: fatalError()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = Section(rawValue: indexPath.section) else {
            fatalError()
        }

        switch section {
        case .input:
            let cell = tableView.dequeueReusableCell(withIdentifier: inputCellReuseId, for: indexPath) as! TableViewInputCell
            cell.delegate = owner
            return cell
        case .todos:
            let cell = tableView.dequeueReusableCell(withIdentifier: todoCellResueId, for: indexPath)
            cell.textLabel?.text = todos[indexPath.row]
            return cell
        default:
            fatalError()
        }
    }
}
