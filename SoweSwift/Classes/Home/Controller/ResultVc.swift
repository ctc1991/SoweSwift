//
//  ResultVc.swift
//  SoweSwift
//
//  Created by 程天聪 on 15/11/11.
//  Copyright © 2015年 CTC. All rights reserved.
//

import UIKit
import WebKit

class ResultVc: BaseVc, WKNavigationDelegate {
    var urlString: String?
    var webView: WKWebView?
    var jsHelper: TCJavascriptHelper?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        jsHelper = TCJavascriptHelper();
        setWebView()
        webView?.loadRequest(NSURLRequest(URL: NSURL(string: "http://weixin.sogou.com/weixinwap?type=2&query=%E4%BD%A0%E5%A5%BD&page=2")!))
        webView!.addObserver(self, forKeyPath: "estimatedProgress", options: .New, context: nil)
    }
    
    func setWebView() {
        let js = "alert('123')"
        let script =  WKUserScript(source: js, injectionTime: WKUserScriptInjectionTime.AtDocumentEnd, forMainFrameOnly: true)
        let userContentController = WKUserContentController()
        userContentController.addUserScript(script)
        
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = userContentController
        webView = WKWebView.init(frame: UIScreen.mainScreen().bounds, configuration: configuration)
//        webView = WKWebView.init(frame: UIScreen.mainScreen().bounds)
        webView?.navigationDelegate = self;
        view.addSubview(webView!)
        jsHelper?.webView = webView;
    }
    
    func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
    }
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        jsHelper?.hideJsClass("searchBox")
        
        // 根据生成的WKUserScript对象，初始化WKWebViewConfiguration
        
    }
    
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<()>) {
        if (keyPath == "estimatedProgress") {
            if (webView!.estimatedProgress == 1) {
                print("加载完毕")
                print(webView?.title);
                webView?.evaluateJavaScript("alert('123')", completionHandler: nil)
            }
        }
    }
    
}
