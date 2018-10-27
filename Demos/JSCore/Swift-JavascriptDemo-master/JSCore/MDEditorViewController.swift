//
//  MDEditorViewController.swift
//  JSCore
//
//  Created by Gabriel Theodoropoulos on 13/02/17.
//  Copyright © 2017 Appcoda. All rights reserved.
//

import UIKit
import JavaScriptCore

class MDEditorViewController: UIViewController {

    @IBOutlet weak var tvEditor: UITextView!
    
    @IBOutlet weak var webResults: UIWebView!
    
    @IBOutlet weak var conTrailingEditor: NSLayoutConstraint!
    
    @IBOutlet weak var conLeadingWebview: NSLayoutConstraint!
    
    var jsContext: JSContext!
    private let consoleLog: @convention(block) (String) -> Void = { logMessage in
        print("\nJS console: \n", logMessage)
    }
    
    let markdownToHTMLHandler: @convention(block) (String) -> Void = { htmlOutput in
        NotificationCenter.default.post(name: NSNotification.Name("markdownToHTMLNotification"), object: htmlOutput)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        /// Add observer
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(MDEditorViewController.handleMarkdownToHTMLNotification(notification:)),
                                               name: NSNotification.Name("markdownToHTMLNotification"),
                                               object: nil)
        
        initializeJS()
    }

 
    func initializeJS() {
        self.jsContext = JSContext()
        
        /// Catch exception
        self.jsContext.exceptionHandler = { context, exception in
            if let ex = exception {
                print("JS exception: " + ex.toString())
            }
        }
        
        let jsPath = Bundle.main.path(forResource: "jssource", ofType: "js")
        if let path = jsPath {
            do {
                let jsSourceContents = try String(contentsOfFile: path)
                jsContext.evaluateScript(jsSourceContents)
                
                // Fetch and evaluate the Snowdown script.
                let snowdownScript = try String(contentsOf: URL(string: "https://cdn.rawgit.com/showdownjs/showdown/1.6.3/dist/showdown.min.js")!)
                self.jsContext.evaluateScript(snowdownScript)
            } catch let ex {
                print(ex.localizedDescription)
            }
        }
        
        // Configurate log
        let consoleLogObject = unsafeBitCast(self.consoleLog, to: AnyObject.self)
        jsContext.setObject(consoleLogObject, forKeyedSubscript: "consoleLog" as (NSCopying & NSObjectProtocol))
        jsContext.evaluateScript("consoleLog")
        
        // Configurate result handler
        let htmlResultHandler = unsafeBitCast(self.markdownToHTMLHandler, to: AnyObject.self)
        jsContext.setObject(htmlResultHandler, forKeyedSubscript: "handleConvertedMarkdown" as(NSCopying & NSObjectProtocol))
        jsContext.evaluateScript("handleConvertedMarkdown")
    }

    func convertMarkdownToHTML() {
        if let funcConvertMarkdownToHTML = jsContext.objectForKeyedSubscript("convertMarkdownToHTML") {
            funcConvertMarkdownToHTML.call(withArguments: [self.tvEditor.text])
        }
    }
    
    func handleMarkdownToHTMLNotification(notification: Notification) {
        if let html = notification.object as? [Int] {
            let newContent = "body { background-color: cyan; } \(html)"
            self.webResults.loadHTMLString(newContent, baseURL: nil)
        }
    }

    // MARK: IBAction Methods
    
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func previewHTML(_ sender: Any) {
        var newTrailingConstant: CGFloat!
        
        if conTrailingEditor.constant == 0.0 {
            newTrailingConstant = self.view.frame.size.width/2
        }
        else if conTrailingEditor.constant == self.view.frame.size.width/2 {
            newTrailingConstant = self.view.frame.size.width
        }
        else {
            newTrailingConstant = 0.0
        }
        
        
        UIView.animate(withDuration: 0.4) {
            self.conTrailingEditor.constant = newTrailingConstant
            self.view.layoutIfNeeded()
        }
    }
    
    
    @IBAction func convert(_ sender: Any) {
        convertMarkdownToHTML()
    }
    
    

}
