//
//  AppDelegate.swift
//  Bonjour
//
//  Created by 黄伯驹 on 2017/8/25.
//  Copyright © 2017年 黄伯驹. All rights reserved.
//

import UIKit

let kWebServiceType = "_http._tcp"
let kInitialDomain = "local"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var browser: BonjourBrowser?
    
    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Create the Bonjour Browser for Web services
        
        let aBrowser = BonjourBrowser(kWebServiceType, domain: kInitialDomain, customDomains: nil, showDisclosureIndicators: false, showCancelButton: false)
        browser = aBrowser

        browser?.delegate = self
        
        // We want to let the user know that the services list is dynamic and always updating, even when there are no
        // services currently found.
        browser?.searchingForServicesString = NSLocalizedString("Searching for web services", comment: "Searching for web services string")

        window = UIWindow(frame: UIScreen.main.bounds)

        window?.rootViewController = browser
        window?.makeKeyAndVisible()

        return true
    }
    
    func copyString(from TXTDict: [String: Any], which: String) -> String? {
        // Helper for getting information from the TXT data
        if let data = TXTDict[which] as? Data {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
}

extension AppDelegate: BonjourBrowserDelegate {
    func bonjourBrowser(browser: BonjourBrowser, didResolveInstance service: NetService?) {
        // Construct the URL including the port number
        // Also use the path, username and password fields that can be in the TXT record

        guard let service = service, let data = service.txtRecordData() else {
            return
        }

        let dict = NetService.dictionary(fromTXTRecord: data)
        let host = service.hostName ?? ""

        
        let user = copyString(from: dict, which: "u")
        let pass = copyString(from: dict, which: "p")
        
        var portStr = ""
        
        // Note that [NSNetService port:] returns an NSInteger in host byte order
        let port = service.port
        if port != 0 && port != 80 {
            portStr = ":\(port)"
        }

        var path = copyString(from: dict, which: "path") ?? ""
        if path.isEmpty {
            path = "/"
        } else if path.hasPrefix("/") {
            let tempPath = "/\(path)"
            path = tempPath
        }

        let string = "http://\(user ?? "")\(pass != nil ? ":" : "")\(pass ?? "")\((user != nil || pass != nil) ? "@": "")\(host)\(portStr)\(path)"

        let url = URL(string: string)
        UIApplication.shared.open(url!, options: [:]) { (flag) in
            
        }
    }
}
