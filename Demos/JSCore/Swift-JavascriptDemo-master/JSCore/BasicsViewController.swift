//
//  BasicsViewController.swift
//  JSCore
//
//  Created by Gabriel Theodoropoulos on 13/02/17.
//  Copyright © 2017 Appcoda. All rights reserved.
//

import UIKit
import JavaScriptCore

class BasicsViewController: UIViewController {
    
    var jsContext: JSContext!
    let luckyNumbersHandler: @convention(block) ([Int]) -> Void = { luckyNumbers in
        NotificationCenter.default.post(name: NSNotification.Name("didReceiveRandomNumbers"), object: luckyNumbers)
    }
    var guessedNumbers = [5, 37, 22, 18, 9, 42]
    
    private let consoleLog: @convention(block) (String) -> Void = { logMessage in
        print("\nJS console: ", logMessage)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Add observer
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(BasicsViewController.handleDidReceiveLuckyNumbersNotification(notification:)),
                                               name: NSNotification.Name("didReceiveRandomNumbers"),
                                               object: nil)

        // Do any additional setup after loading the view.
        initializeJS()
        helloWorld()
        jsDemo1()
        jsDemo2()
        jsDemo3()
        
        
        
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
            } catch let ex {
                print(ex.localizedDescription)
            }
        }
        
        // Configurate log
        let consoleLogObject = unsafeBitCast(self.consoleLog, to: AnyObject.self)
        jsContext.setObject(consoleLogObject, forKeyedSubscript: "consoleLog" as (NSCopying & NSObjectProtocol))
        jsContext.evaluateScript("consoleLog")
    }
    
    func helloWorld() {
        if let valiableHW = jsContext.objectForKeyedSubscript("helloWorld") {
            print(valiableHW.toString() ?? "")
        }
    }
    
    func jsDemo1() {
        let firstName = "zhang"
        let lastName = "san"
        if let funcFullName = jsContext.objectForKeyedSubscript("getFullName") {
            if let fullName = funcFullName.call(withArguments: [firstName, lastName]) {
                print(fullName)
            }
        }
    }
    
    func jsDemo2() {
        let values = [10, -5, 22, 14, -35, 101, -55, 16, 14]
        guard let funcMaxMinAverage = jsContext.objectForKeyedSubscript("maxMinAverage") else {
            return
        }
        
        guard let dic = funcMaxMinAverage.call(withArguments: [values]) else {
            return
        }
        
        for (key, value) in dic.toDictionary() {
            print(key, value)
        }
    }
    
    func jsDemo3() {
        let luckyNumberObject = unsafeBitCast(self.luckyNumbersHandler, to: AnyObject.self)
        jsContext.setObject(luckyNumberObject, forKeyedSubscript: "handleLuckyNumbers" as(NSCopying & NSObjectProtocol))
        jsContext.evaluateScript("handleLuckyNumbers")

        guard let funcGenerateLuckyNumbers = jsContext.objectForKeyedSubscript("generateLuckyNumbers") else {
            return
        }
        
        funcGenerateLuckyNumbers.call(withArguments: [])
        
    }
    // MARK: Private Method
    
    @objc func handleDidReceiveLuckyNumbersNotification(notification: Notification) {
        if let luckyNumbers = notification.object as? [Int] {
            print("\n\nLuckyNumbers: ", luckyNumbers, "GuessNumbers: ", guessedNumbers, "\n")
            var correctGuesses = 0
            for number in luckyNumbers {
                if let _ = guessedNumbers.firstIndex(of: number) {
                    print("You guessed correctly: ", number)
                    correctGuesses += 1
                }
            }
            print("Total correct guesses: ", correctGuesses)
            if correctGuesses == 6 {
                print("You are the big winner !!!")
            }
        }
    }
    
    
    // MARK: IBAction Method
    
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
