//
//  ViewController.swift
//  WKWebViewDemo
//
//  Created by huangyibiao on 15/10/26.
//  Copyright © 2015年 huangyibiao. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKScriptMessageHandler, WKNavigationDelegate, WKUIDelegate {
    var webView: WKWebView!
    var progressView: UIProgressView!
    var testUrl = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = UIRectEdge()

        // 创建webveiew
        // 创建一个webiview的配置项
        let configuretion = WKWebViewConfiguration()

        // Webview的偏好设置
        configuretion.preferences = WKPreferences()
        configuretion.preferences.minimumFontSize = 10
        configuretion.preferences.javaScriptEnabled = true
        configuretion.preferences.setValue(true, forKey: "allowFileAccessFromFileURLs")
        // 默认是不能通过JS自动打开窗口的，必须通过用户交互才能打开
        configuretion.preferences.javaScriptCanOpenWindowsAutomatically = false

        // 通过js与webview内容交互配置
        configuretion.userContentController = WKUserContentController()
        
        // 添加一个JS到HTML中，这样就可以直接在JS中调用我们添加的JS方法
        let script = WKUserScript(source: "function showAlert() { alert('在载入webview时通过Swift注入的JS方法'); }",
                                  injectionTime: .atDocumentStart,// 在载入时就添加JS
            forMainFrameOnly: true) // 只添加到mainFrame中
//        configuretion.userContentController.addUserScript(script)
        
        // 添加一个名称，就可以在JS通过这个名称发送消息：
        // window.webkit.messageHandlers.AppModel.postMessage({body: 'xxx'})
        configuretion.userContentController.add(self, name: "AppModel")
        
        self.webView = WKWebView(frame: self.view.bounds, configuration: configuretion)

        guard let url = Bundle.main.url(forResource: "index", withExtension: "html") else { return }
        webView.loadFileURL(url, allowingReadAccessTo: url)
//        self.webView.load(URLRequest(url: url!))
        self.view.addSubview(self.webView)
        
        
        // 监听支持KVO的属性
        self.webView.addObserver(self, forKeyPath: "loading", options: .new, context: nil)
        self.webView.addObserver(self, forKeyPath: "title", options: .new, context: nil)
        self.webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        
        self.webView.navigationDelegate = self
        self.webView.uiDelegate = self
        
        self.progressView = UIProgressView(progressViewStyle: .default)
        self.progressView.frame.size.width = self.view.frame.size.width
        self.progressView.backgroundColor = UIColor.red
        self.view.addSubview(self.progressView)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "前进", style: .done, target: self, action: #selector(previousPage))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "后退", style: .done, target: self, action: #selector(nextPage))
    }
    
    @objc func previousPage() {
        if self.webView.canGoBack {
            self.webView.goBack()
        }
    }
    
    @objc func nextPage() {
        if self.webView.canGoForward {
            self.webView.goForward()
        }
    }
    
    // MARK: - WKScriptMessageHandler
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print(message.body)
        if message.name == "AppModel" {
            print("message name is AppModel")
        }
    }
    
    // MARK: - KVO
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "loading" {
            print("loading")
        } else if keyPath == "title" {
            self.title = self.webView.title
        } else if keyPath == "estimatedProgress" {
            print(webView.estimatedProgress)
            self.progressView.setProgress(Float(webView.estimatedProgress), animated: true)
        }
        
        // 已经完成加载时，我们就可以做我们的事了
        if !webView.isLoading {
            // 手动调用JS代码
            let js = "callJsAlert()";
            self.webView.evaluateJavaScript(js) { (_, _) -> Void in
                print("call js alert")
            }
            
            UIView.animate(withDuration: 0.55, animations: { () -> Void in
                self.progressView.alpha = 0.0;
            })
        }
    }
    
    // MARK: - WKNavigationDelegate
    
    // 决定导航的动作，通常用于处理跨域的链接能否导航。WebKit对跨域进行了安全检查限制，不允许跨域，因此我们要对不能跨域的链接
    // 单独处理。但是，对于Safari是允许跨域的，不用这么处理。
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        print(#function, navigationAction.request.url, "😁哈哈")
        
        let hostname = (navigationAction.request as NSURLRequest).url?.host?.lowercased()
        
        print(navigationAction.request.url?.path)
        // 处理跨域问题
        if navigationAction.navigationType == .linkActivated && hostname!.contains("image") {
            // 手动跳转
            navigationController?.pushViewController(ImageController(), animated: true)
            decisionHandler(.cancel)
        } else {
            self.progressView.alpha = 1.0
            
            decisionHandler(.allow)
        }
    }
    
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        print(#function)
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        if webView.isLoading && webView.estimatedProgress == 1 {
            webView.stopLoading()
            print("✈️✈️")
        }
        print(#function)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        let aa = "function registerImageClickAction(){var imgs=document.getElementsByTagName('img'); var length=imgs.length; for(var i=0;i<length;i++){img=imgs[i]; img.onclick=function(){window.location.href='image-preview:'+this.src}}}"
//        webView.evaluateJavaScript(aa) { (str, error) in
//            print(error)
//        }
//        webView.evaluateJavaScript("registerImageClickAction();") { (str, error) in
//            print(error)
//        }
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print(#function)
        
        print(navigation, "dddddd")
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print(#function)
    }
    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        print(#function)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(#function)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        print(#function)
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        print(#function)
        completionHandler(.performDefaultHandling, nil)
    }
    
    // MARK: - WKUIDelegate
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alert = UIAlertController(title: "Tip", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (_) -> Void in
            // We must call back js
            completionHandler()
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        let alert = UIAlertController(title: "Tip", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (_) -> Void in
            completionHandler(true)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) -> Void in
            completionHandler(false)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        let alert = UIAlertController(title: prompt, message: defaultText, preferredStyle: .alert)
        
        alert.addTextField { (textField: UITextField) in
            textField.textColor = UIColor.red
        }
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (_) in
            completionHandler(alert.textFields![0].text!)
        }))

        self.present(alert, animated: true, completion: nil)
    }
    
    func webViewDidClose(_ webView: WKWebView) {
        print(#function)
    }
}

