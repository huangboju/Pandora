//
//  CoursesTableViewController.swift
//  Developers Academy
//
//  Created by Duc Tran on 11/27/15.
//  Copyright © 2015 Developers Academy. All rights reserved.
//

import UIKit
import SafariServices
import LocalAuthentication

class CoursesTableViewController: UITableViewController
{
    var programs: [Program] = [Program.TotalIOSBlueprint(), Program.SocializeYourApps()]
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Make the row height dynamic
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
    
        // the first screen of the app
        // if walkthroughs haven't been shown, let's show the walkthroughs
        displayWalkthroughs()
    }
    
    func displayWalkthroughs()
    {
        // check if walkthroughs have been shown
        let userDefaults = UserDefaults.standard
        let displayedWalkthrough = userDefaults.bool(forKey: "DisplayedWalkthrough")
        
        // if we haven't shown the walkthroughs, let's show them
        if displayedWalkthrough {
            // instantiate neew PageVC via storyboard
            if let pageViewController = storyboard?.instantiateViewController(withIdentifier: "PageViewController") as? PageViewController {
                self.present(pageViewController, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return programs.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return programs[section].courses.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Course Cell", for: indexPath) as! CourseTableViewCell
        
        let program = programs[indexPath.section]
        let courses = program.courses
        cell.course = courses[indexPath.row]
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let program = programs[indexPath.section]
        let url = program.url
        
        showWebsite(url)
    }
    
    // MARK: - Show Webpage with SFSafariViewController
    
    func showWebsite(_ url: String)
    {
        let webVC = SFSafariViewController(url: URL(string: url)!)
        webVC.delegate = self
        
        self.present(webVC, animated: true, completion: nil)
    }
    
    // MARK: - Target / Action
    
    @IBAction func signupClicked(_ sender: AnyObject)
    {
        self.tabBarController?.selectedIndex = 2
    }
    
    @IBAction func loginClicked(_ sender: AnyObject)
    {
        authenticateUsingTouchID()
    }
    
    // MARK: - Touch ID authentication
    
    func authenticateUsingTouchID()
    {
        let authContext = LAContext()
        let authReason = "Please use Touch ID to sign in Developers Academy"
        var authError: NSError?
        
        if authContext.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
            authContext.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: authReason, reply: { (success, error) -> Void in
                if success {
                    print("successfully authenticated")
                    // this is on a private queue off the main queue (asynchronously), if we want to do UI code, we must get back to the main queue
                    DispatchQueue.main.async(execute: { () -> Void in
                        self.tabBarController?.selectedIndex = 2    // go to the programs tab or sign in in your app
                    })
                } else {
                    if let error = error {
                        // again, this is off the main queue. need to back to the main queue to do ui code
                        DispatchQueue.main.async(execute: { () -> Void in
                            self.reportTouchIDError(error as NSError)
                            // it's best to show other method to login (enter user name and password)
                        })
                    }
                }
            })
        } else {
            // device doesn't support touch id 
            print(authError?.localizedDescription as Any)

            // show other methods to login
        }
    }
    
    func reportTouchIDError(_ error: NSError)
    {
        switch error.code {
        case LAError.Code.authenticationFailed.rawValue:
            print("Authentication failed")
        case LAError.Code.passcodeNotSet.rawValue:
            print("passcode not set")
        case LAError.Code.systemCancel.rawValue:
            print("authentication was canceled by the system")
        case LAError.Code.userCancel.rawValue:
            print("user cancel auth")
        case LAError.Code.touchIDNotEnrolled.rawValue:
            print("user hasn't enrolled any finger with touch id")
        case LAError.Code.touchIDNotAvailable.rawValue:
            print("touch id is not available")
        case LAError.Code.userFallback.rawValue:
            print("user tapped enter password")
        default:
            print(error.localizedDescription)
        }
    }
}

extension CoursesTableViewController : SFSafariViewControllerDelegate
{
    func safariViewControllerDidFinish(_ controller: SFSafariViewController)
    {
        controller.dismiss(animated: true, completion: nil)
    }
}












