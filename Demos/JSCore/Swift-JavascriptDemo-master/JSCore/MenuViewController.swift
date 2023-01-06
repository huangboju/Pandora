//
//  MenuViewController.swift
//  JSCore
//
//  Created by Gabriel Theodoropoulos on 13/02/17.
//  Copyright © 2017 Appcoda. All rights reserved.
//

import UIKit
import JavaScriptCore

extension String {
    var jsString: String {
        return "'\(self)'"
    }
}

class MenuViewController: UIViewController {

    var jsContext: JSContext!

    private let consoleLog: @convention(block) (String) -> Void = { logMessage in
        print("\nJS console: ", logMessage)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        initializeJS()

        trigger()
    }

    func trigger() {
        let array = [
            "1",
            "action",
            "noteId",
            "goodsId",
            "noteType",
            "searchWord",
            "ruleId",
            "{\"keyword\":\"测试\"}"
        ].map {
            $0.jsString
        }

        let execute: String

        let falg = false

        if falg {
            execute = "positiveTrigger(" + array.joined(separator: ",") + ")"
        } else {
            execute = "negativeTrigger(" + array.joined(separator: ",") + ")"
        }

        evaluateScript(execute)
    }
    

    func initializeJS() {
        self.jsContext = JSContext()

        /// Catch exception
        self.jsContext.exceptionHandler = { context, exception in
            if let ex = exception {
                print("JS exception: " + ex.toString())
            }
        }

        let jsPath = Bundle.main.path(forResource: "surprise_box", ofType: "js")
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

    func evaluateScript(_ execute: String, callbackOn queue: DispatchQueue? = nil, complection: ((JSValue) -> Void)? = nil) {
        if let result = self.jsContext.evaluateScript(execute) {
            if let comp = complection {
                if let _queue = queue {
                    _queue.async {
                        comp(result)
                    }
                } else {
                    comp(result)
                }
            }
        } else {

        }
    }
}
