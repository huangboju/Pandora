//
//  BonjourController.swift
//  Bonjour
//
//  Created by 黄伯驹 on 2017/8/25.
//  Copyright © 2017年 黄伯驹. All rights reserved.
//

import UIKit

class BonjourController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        findingService()

        findingDomains()
    }

    func findingService() {
        let browser = Bonjour()
        // This will find all HTTP servers - Check out Bonjour.Services for common services
        browser.findService(Bonjour.Services.Hypertext_Transfer, domain: Bonjour.LocalDomain) { (services) in
            print(services)
            // Do something with your services!
            // services will be an empty array if nothing was found
        }
    }

    func findingDomains() {
        let bonjour = Bonjour()
        bonjour.findDomains { (domains) in
            print(domains)
            // Do something with your domains!
            // services will be an empty array if nothing was found
        }
    }
}
