//
//  ViewController.swift
//  Bonjour
//
//  Created by 黄伯驹 on 2017/8/25.
//  Copyright © 2017年 黄伯驹. All rights reserved.
//

import UIKit

protocol BrowserViewControllerDelegate: class {
    // This method will be invoked when the user selects one of the service instances from the list.
    // The ref parameter will be the selected (already resolved) instance or nil if the user taps the 'Cancel' button (if shown).
    func browserViewController(bvc: BrowserViewController, didResolveInstance ref: NetService?)
}

extension NetService {
    func localizedCaseInsensitiveCompareByName(aService: NetService) -> ComparisonResult {
        return name.localizedCompare(aService.name)
    }
}

class BrowserViewController: UITableViewController {
    
    var showDisclosureIndicators = false
    var services: [NetService] = []
    var netServiceBrowser = NetServiceBrowser()
    var currentResolve: NetService?
    var timer: Timer?
    var needsActivityIndicator = false
    var _initialWaitOver = false

    weak var delegate: BrowserViewControllerDelegate?
    var searchingForServicesString = "" {
        didSet {
            if searchingForServicesString == oldValue && services.isEmpty {
               return
            }
            // If there are no services, reload the table to ensure that searchingForServicesString appears.
            tableView.reloadData()
        }
    }

    convenience init(_ title: String, showDisclosureIndicators show: Bool, showCancelButton: Bool) {
        self.init(style: .plain)
        self.title = title
        showDisclosureIndicators = show
        
        if showCancelButton {
            // add Cancel button as the nav bar's custom right view
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelAction))
        }

        // Make sure we have a chance to discover devices before showing the user that nothing was found (yet)
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(initialWaitOver) , userInfo: nil, repeats: false)
    }
    
    // Creates an NSNetServiceBrowser that searches for services of a particular type in a particular domain.
    // If a service is currently being resolved, stop resolving it and stop the service browser from
    // discovering other services.
    @discardableResult
    func searchForServices(of type: String, inDomain domain: String) -> Bool {
        
        stopCurrentResolve()
        netServiceBrowser.stop()
        services.removeAll()
        
        let aNetServiceBrowser = NetServiceBrowser()
        
        aNetServiceBrowser.delegate = self
        netServiceBrowser = aNetServiceBrowser
        
        netServiceBrowser.searchForServices(ofType: type, inDomain: domain)
        tableView.reloadData()
        return true
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // If there are no services and searchingForServicesString is set, show one row to tell the user.
        let count = services.count
        if count == 0 && searchingForServicesString.isEmpty && _initialWaitOver {
            return 1
        }

        return count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
        
        let count = services.count
        if count == 0 && !searchingForServicesString.isEmpty {
            // If there are no services and searchingForServicesString is set, show one row explaining that to the user.
            cell.textLabel?.text = searchingForServicesString
            cell.textLabel?.textColor = UIColor(white: 0.5, alpha: 0.5)
            cell.accessoryType = .none
            // Make sure to get rid of the activity indicator that may be showing if we were resolving cell zero but
            // then got didRemoveService callbacks for all services (e.g. the network connection went down).
            cell.accessoryView = nil
            return cell
        }
        
        // Set up the text for the cell
        
        let service = services[indexPath.row]
        cell.textLabel?.text = service.name
        cell.textLabel?.textColor = UIColor.black
        cell.accessoryType = showDisclosureIndicators ? .disclosureIndicator : .none

        // Note that the underlying array could have changed, and we want to show the activity indicator on the correct cell
        if needsActivityIndicator && currentResolve == service {
            if cell.accessoryView == nil {
                
                
                let frame = CGRect(x: 0, y: 0, width: 20, height: 20)
                
                let spinner = UIActivityIndicatorView(frame: frame)
                spinner.stopAnimating()
                spinner.activityIndicatorViewStyle = .gray
                spinner.sizeToFit()
                spinner.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin]
                cell.accessoryView = spinner
            }
        } else if cell.accessoryView != nil {
            cell.accessoryView = nil
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        // Ignore the selection if there are no services as the searchingForServicesString cell
        // may be visible and tapping it would do nothing
        return services.isEmpty ? nil : indexPath
    }
    
    func stopCurrentResolve() {
        needsActivityIndicator = false
        timer = nil
        
        currentResolve?.stop()
        currentResolve = nil
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // If another resolve was running, stop it & remove the activity indicator from that cell
        if let currentResolve = currentResolve {
            // Get the indexPath for the active resolve cell
            let indexPath = IndexPath(row: services.index(of: currentResolve) ?? -1, section: 0)
            
            // Stop the current resolve, which will also set self.needsActivityIndicator
            stopCurrentResolve()
            
            // If we found the indexPath for the row, reload that cell to remove the activity indicator
            if indexPath.row != 0 {
                tableView.reloadRows(at: [indexPath], with: .none)
            }
        }
        
        // Then set the current resolve to the service corresponding to the tapped cell
        currentResolve = services[indexPath.row]
        currentResolve?.delegate = self
        
        // Attempt to resolve the service. A value of 0.0 sets an unlimited time to resolve it. The user can
        // choose to cancel the resolve by selecting another service in the table view.
        currentResolve?.resolve(withTimeout: 0)
        
        // Make sure we give the user some feedback that the resolve is happening.
        // We will be called back asynchronously, so we don't want the user to think we're just stuck.
        // We delay showing this activity indicator in case the service is resolved quickly.
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(showWaiting), userInfo: currentResolve, repeats: false)
    }
    
    // If necessary, sets up state to show an activity indicator to let the user know that a resolve is occuring.
    func showWaiting(_ timer: Timer) {
        if timer != self.timer {
            return
        }
        guard currentResolve == timer.userInfo as? NetService else {
            return
        }

        guard let currentResolve = currentResolve else {
            return
        }
        needsActivityIndicator = true

        let indexPath = IndexPath(row: services.index(of: currentResolve) ?? -1, section: 0)
        if indexPath.row != NSNotFound {
            tableView.reloadRows(at: [indexPath], with: .none)
            // Deselect the row since the activity indicator shows the user something is happening.
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

    func initialWaitOver(timer: Timer) {
        _initialWaitOver = true
        if services.isEmpty {
            return
        }
        tableView.reloadData()
    }
    
    func sortAndUpdateUI() {
        // Sort the services by name.
//        services.sort(by: <#T##(NetService, NetService) -> Bool#>)
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
    }

    func cancelAction() {
        delegate?.browserViewController(bvc: self, didResolveInstance: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension BrowserViewController: NetServiceBrowserDelegate {
    func netServiceBrowser(_ browser: NetServiceBrowser, didRemove service: NetService, moreComing: Bool) {
        // If a service went away, stop resolving it if it's currently being resolved,
        // remove it from the list and update the table view if no more events are queued.
        if currentResolve != nil && service == currentResolve {
            stopCurrentResolve()
        }
        services.remove(object: service)

        // If moreComing is NO, it means that there are no more messages in the queue from the Bonjour daemon, so we should update the UI.
        // When moreComing is set, we don't update the UI so that it doesn't 'flash'.
        if !moreComing {
            sortAndUpdateUI()
        }
    }
    
    func netServiceBrowser(_ browser: NetServiceBrowser, didFind service: NetService, moreComing: Bool) {
        // If a service came online, add it to the list and update the table view if no more events are queued.
        services.append(service)
        
        // If moreComing is NO, it means that there are no more messages in the queue from the Bonjour daemon, so we should update the UI.
        // When moreComing is set, we don't update the UI so that it doesn't 'flash'.
        if !moreComing {
            sortAndUpdateUI()
        }
    }
}

extension BrowserViewController: NetServiceDelegate {
    func netService(_ sender: NetService, didNotResolve errorDict: [String : NSNumber]) {
        stopCurrentResolve()
        tableView.reloadData()
    }

    func netServiceDidResolveAddress(_ sender: NetService) {
        assert(sender == currentResolve)

        stopCurrentResolve()
        
        delegate?.browserViewController(bvc: self, didResolveInstance: sender)
    }
}


extension Array where Element: Equatable {
    
    // Remove first collection element that is equal to the given `object`:
    mutating func remove(object: Element) {
        if let index = index(of: object) {
            remove(at: index)
        }
    }
}
