//
//  DevicesViewController.swift
//  JSCore
//
//  Created by Gabriel Theodoropoulos on 13/02/17.
//  Copyright © 2017 Appcoda. All rights reserved.
//

import UIKit
import JavaScriptCore

class DevicesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tblDeviceList: UITableView!
    var jsContext: JSContext!
    private let consoleLog: @convention(block) (String) -> Void = { logMessage in
        print("\nJS console: \n", logMessage)
    }
    var deviceInfo: [DeviceInfo]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        initializeJS()
        parseDeviceData()
    }

    func initializeJS() {
        self.jsContext = JSContext()
        
        /// Catch exception
        self.jsContext.exceptionHandler = { context, exception in
            if let ex = exception {
                print("JS exception: " + ex.toString())
            }
        }
        
        // Load the PapaParse library.
        if let papaParsePath = Bundle.main.path(forResource: "papaparse.min", ofType: "js") {
            do {
                let papaParseContents = try String(contentsOfFile: papaParsePath)
                self.jsContext.evaluateScript(papaParseContents)
            }
            catch {
                print(error.localizedDescription)
            }
        }
        
        let jsPath = Bundle.main.path(forResource: "jssource", ofType: "js")
        if let path = jsPath {
            do {
                let jsSourceContents = try String(contentsOfFile: path)
                jsContext.evaluateScript(jsSourceContents)
                
            } catch let ex {
                print(ex.localizedDescription)
            }
        }
        
        // Configurate log
        let consoleLogObject = unsafeBitCast(self.consoleLog, to: AnyObject.self)
        jsContext.setObject(consoleLogObject, forKeyedSubscript: "consoleLog" as (NSCopying & NSObjectProtocol))
        jsContext.evaluateScript("consoleLog")
        
        // Set the DeviceInfo class to the JSContext.
        self.jsContext.setObject(DeviceInfo.self, forKeyedSubscript: "DeviceInfo" as (NSCopying & NSObjectProtocol)!)

    }
    
    func parseDeviceData() {
        if let path = Bundle.main.path(forResource: "iPhone_List", ofType: "csv") {
            do {
                let contents = try String(contentsOfFile: path)
                
                if let functionParseiPhoneList = self.jsContext.objectForKeyedSubscript("parseiPhoneList") {
                    if let parsedDeviceData = functionParseiPhoneList.call(withArguments: [contents]).toArray() as? [DeviceInfo] {
                        self.deviceInfo = parsedDeviceData
                        self.tblDeviceList.reloadData()
                    }
                }
                
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tblDeviceList.delegate = self
        tblDeviceList.dataSource = self
        tblDeviceList.tableFooterView = UIView(frame: CGRect.zero)
        tblDeviceList.register(UINib(nibName: "DeviceCell", bundle: nil), forCellReuseIdentifier: "idDeviceCell")
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    // MARK: IBAction Methods
    
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    // MARK: UITableViewDelegate & UITableViewDataSource Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.deviceInfo != nil) ? self.deviceInfo.count : 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "idDeviceCell") as! DeviceCell
        
        let currentDevice = self.deviceInfo[indexPath.row]
        
        cell.textLabel?.text = currentDevice.model
        cell.detailTextLabel?.text = currentDevice.concatOS()
        
        (URLSession(configuration: URLSessionConfiguration.default)).dataTask(with: URL(string: currentDevice.imageURL)!, completionHandler: { (imageData, response, error) in
            if let data = imageData {
                DispatchQueue.main.async {
                    cell.imageView?.image = UIImage(data: data)
                    cell.layoutSubviews()
                }
            }
        }).resume()
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
}
