//
//  BonjourBrowser.swift
//  Bonjour
//
//  Created by 黄伯驹 on 2017/8/25.
//  Copyright © 2017年 黄伯驹. All rights reserved.
//

import UIKit

protocol BonjourBrowserDelegate: UINavigationControllerDelegate {
    // This method will be invoked when the user selects one of the service instances from the list.
    // The ref parameter will be the selected (already resolved) instance or nil if the user taps the 'Cancel' button (if shown).
    func bonjourBrowser(browser: BonjourBrowser, didResolveInstance service: NetService?)
}

class BonjourBrowser: UINavigationController {
    weak var _delegate: BonjourBrowserDelegate?
    var dvc: DomainViewController?
    var bvc: BrowserViewController?
    var type = ""
    var domain = ""
    var showDisclosureIndicators = false
    var searchingForServicesString = ""
    var showCancelButton = false
    var showTitleInNavigationBar = false {
        willSet {
            if newValue {
                bvc?.navigationItem.prompt = title
                dvc?.navigationItem.prompt = title
            } else {
                bvc?.navigationItem.prompt = nil
                dvc?.navigationItem.prompt = nil
            }
        }
    }

    /// The Bonjour service type to browse for, e.g. @"_http._tcp"
    /// The initial domain to browse in (pass nil to start in domains list)
    /// An array of domains specified by the user
    /// Whether to show discolsure indicators on service instance table cells
    /// e.g. if you want to push a view controller onto this navigation controller
    /// Whether to show a cancel button as the right navigation item
    /// Pass YES if you are modally showing this BonjourBrowser
    convenience init(_ type: String, domain: String, customDomains: [String]?, showDisclosureIndicators: Bool, showCancelButton: Bool) {
        // Create some strings that will be used in the DomainViewController.
        let domainsTitle = NSLocalizedString("Domains", comment: "Domains title")
        let domainLabel = NSLocalizedString("Added Domains", comment: "Added Domains label")
        let addDomainTitle = NSLocalizedString("Add Domain", comment: "Add Domain title")
        let searchingForServicesString = NSLocalizedString("Searching for services", comment: "Searching for services string")

        // Initialize the DomainViewController, which uses a NSNetServiceBrowser to look for Bonjour domains.

        let dvc = DomainViewController(domainsTitle, showDisclosureIndicators: true, customsTitle: domainLabel, customs: customDomains, addDomainTitle: addDomainTitle, showCancelButton: showCancelButton)

        self.init(rootViewController: dvc)

        self.type = type
        self.showDisclosureIndicators = showDisclosureIndicators
        self.showCancelButton = showCancelButton
        self.searchingForServicesString	= searchingForServicesString
        self.dvc = dvc
        dvc.delegate = self
        dvc.searchForBrowsableDomains() // Tells the DomainViewController's NSNetServiceBrowser to start a search for domains that are browsable via Bonjour and the computer's network configuration.

        if !domain.isEmpty {
            self.domain = domain
            setupBrowser() // Initiate a search for Bonjour services of the type self.type.
            pushViewController(bvc!, animated: false)
        }
    }
    
    // Create a BrowserViewController, which manages a NSNetServiceBrowser configured to look for Bonjour services.
    func setupBrowser() {
        let aBvc = BrowserViewController(domain, showDisclosureIndicators: showDisclosureIndicators, showCancelButton: showCancelButton)
        aBvc.searchingForServicesString = searchingForServicesString
        aBvc.delegate = self
        // Calls -[NSNetServiceBrowser searchForServicesOfType:inDomain:].
        aBvc.searchForServices(of: type, inDomain: domain)

        // Store the BrowerViewController in an instance variable.
        self.bvc = aBvc;
        if showTitleInNavigationBar {
            bvc?.navigationItem.prompt = title
        }
    }
    
    override var delegate: UINavigationControllerDelegate? {
        set {
            _delegate = newValue as? BonjourBrowserDelegate
            super.delegate = _delegate
        }
        get {
            assert((super.delegate as? BonjourBrowserDelegate) != nil)
            return _delegate
        }
    }
}

extension BonjourBrowser: BrowserViewControllerDelegate {
    func browserViewController(bvc: BrowserViewController, didResolveInstance service: NetService?) {
        assert(bvc == self.bvc)
        _delegate?.bonjourBrowser(browser: self, didResolveInstance: service)
    }
}

extension BonjourBrowser: DomainViewControllerDelegate {
    func domainViewController(dvc: DomainViewController, didSelectDomain domain: String?) {
        if domain == nil {
            // Cancel
            _delegate?.bonjourBrowser(browser: self, didResolveInstance: nil)
            return
        }

        self.domain = domain!
        setupBrowser()
        pushViewController(bvc!, animated: true)
    }
}
