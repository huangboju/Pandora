//
//  DomainViewController.swift
//  Bonjour
//
//  Created by 黄伯驹 on 2017/8/25.
//  Copyright © 2017年 黄伯驹. All rights reserved.
//

import UIKit

protocol DomainViewControllerDelegate: class {
    // This method will be invoked when the user selects one of the domains from the list.
    // The domain parameter will be the selected domain or nil if the user taps the 'Cancel' button (if shown)
    func domainViewController(dvc: DomainViewController, didSelectDomain domain: String?)
}

class DomainViewController: UITableViewController {
    
    
    var showDisclosureIndicators = false
    var domains: [String] = []
    var customs: [String] = []
    var customTitle = ""
    var addDomainTitle = ""
    var netServiceBrowser: NetServiceBrowser? {
        didSet {
            oldValue?.stop()
        }
    }
    var showCancelButton = false

    weak var delegate: DomainViewControllerDelegate?

    // Initialization. BonjourBrowser invokes this during its initialization.

    convenience init(_ title: String, showDisclosureIndicators show: Bool, customsTitle: String, customs: [String]?, addDomainTitle: String, showCancelButton: Bool) {
        self.init(style: .plain)
        self.title = title
        self.showDisclosureIndicators = show
        self.customTitle = customsTitle
        self.customs = customs ?? []
        self.addDomainTitle = addDomainTitle
        self.showCancelButton = showCancelButton
        addButtons(tableView.isEditing)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
    }

    func addButtons(_ editing: Bool) {
        if editing {
            // Add the "done" button to the navigation bar
            let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction))
            
            navigationItem.leftBarButtonItem = doneButton
            addButtons(true)
        } else {
            if !customs.isEmpty {
                // Add the "edit" button to the navigation bar
                let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editAction))
                navigationItem.leftBarButtonItem = editButton
            } else {
                addAddButton(false)
            }

            if showCancelButton {
                // add Cancel button as the nav bar's custom right view
                let addButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelAction))
                navigationItem.rightBarButtonItem = addButton
            } else {
                navigationItem.rightBarButtonItem = nil
            }
        }
    }
    
    func addAddButton(_ right: Bool) {
        // add + button as the nav bar's custom right view

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addAction))
        if right {
            navigationItem.rightBarButtonItem = addButton
        } else {
            navigationItem.leftBarButtonItem = addButton
        }
    }
    
    var commonSetup: Bool {
        netServiceBrowser = NetServiceBrowser()
        if netServiceBrowser == nil {
            return false
        }

        netServiceBrowser?.delegate = self
        return true
    }
    
    // A cover method to -[NSNetServiceBrowser searchForBrowsableDomains].
    @discardableResult
    func searchForBrowsableDomains() -> Bool {
        if !commonSetup {
            return false
        }
        netServiceBrowser?.searchForBrowsableDomains()
        return true
    }
    
    // A cover method to -[NSNetServiceBrowser searchForRegistrationDomains].
    func searchForRegistrationDomains() -> Bool {
        if !commonSetup {
            return false
        }
        netServiceBrowser?.searchForRegistrationDomains()
        return true
    }
    
    @objc func addAction() {
        let alert = UIAlertController(title: addDomainTitle, message: nil, preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.action("取消", style: .cancel)
        alert.action("确定") { (action) in
            let text = alert.textFields?.first?.text
            self.addCustom(with: text)
            
        }
        present(alert, animated: true, completion: nil)
    }
    
    @objc func doneAction() {
        tableView.setEditing(false, animated: true)
        addButtons(tableView.isEditing)
    }
    
    @objc func editAction() {
        tableView.setEditing(true, animated: true)
        addButtons(tableView.isEditing)
    }
    
    @objc func cancelAction() {
        delegate?.domainViewController(dvc: self, didSelectDomain: nil)
    }
    
    func addCustom(with text: String?) {
        guard let text = text, !text.isEmpty else {
            return
        }

        if !customs.contains(text) {
            customs.append(text)
            //            [self.customs sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        }

        addButtons(self.tableView.isEditing)
        tableView.reloadData()
        
        guard let n = customs.firstIndex(of: text) else {
            return
        }
        
        let indexPath = IndexPath(indexes: [1, n])
        tableView.scrollToRow(at: indexPath, at: .none, animated: true)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1 + (customs.isEmpty ? 0 : 1)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section > 0 {
            return customs.count
        }
        return domains.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section > 0 ? customTitle : "Bonjour" // Note that "Bonjour" is the proper name of the technology, therefore should not be localized
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)

        // Set up the text for the cell

        cell.textLabel?.text = (indexPath.section > 0 ? customs : domains)[indexPath.row]

        cell.textLabel?.textColor = .black
        cell.accessoryType = showDisclosureIndicators ? .disclosureIndicator : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section > 0 && tableView.isEditing
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let text = (indexPath.section > 0 ? customs : domains)[indexPath.row]

        delegate?.domainViewController(dvc: self, didSelectDomain: text)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        assert(editingStyle == .delete)
        assert(indexPath.section == 1)
        customs.remove(at: indexPath.row)
        if customs.isEmpty {
            tableView.deleteSections(IndexSet(integer: 1), with: .right)
        } else {
            tableView.deleteRows(at: [indexPath], with: .none)
        }
        addButtons(tableView.isEditing)
    }
    
    func updateUI() {
        // Sort the domains by name, then modify the selection, as it may have moved
//        [self.domains sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        tableView.reloadData()
    }
}

extension DomainViewController: NetServiceBrowserDelegate {
    func netServiceBrowser(_ browser: NetServiceBrowser, didRemoveDomain domainString: String, moreComing: Bool) {
        
        let tmp = (domainString as NSString).transmogrify ?? ""
        domains.remove(object: tmp)

        // moreComing really means that there are no more messages in the queue from the Bonjour daemon, so we should update the UI.
        // When moreComing is set, we don't update the UI so that it doesn't 'flash'.
        if !moreComing {
            updateUI()
        }
    }
    
    func netServiceBrowser(_ browser: NetServiceBrowser, didFindDomain domainString: String, moreComing: Bool) {

        let tmp = (domainString as NSString).transmogrify ?? ""

        if !domains.contains(tmp) {
            domains.append(tmp)
        }
        
        

        // moreComing really means that there are no more messages in the queue from the Bonjour daemon, so we should update the UI.
        // When moreComing is set, we don't update the UI so that it doesn't 'flash'.
        if !moreComing {
            updateUI()
        }
    }
}

extension UIAlertController {
    @discardableResult
    func action(_ title: String?, style: UIAlertAction.Style = .`default`, _ handle: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
        let action = UIAlertAction(title: title, style: style, handler: handle)
        addAction(action)
        return self
    }
}
