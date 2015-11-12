//
//  ResultVc.swift
//  SoweSwift
//
//  Created by 程天聪 on 15/11/11.
//  Copyright © 2015年 CTC. All rights reserved.
//

import UIKit

class ResultVc: BaseVc
, UIWebViewDelegate {
    var urlString: String?
    var webView: UIWebView?
    var jsHelper: TCJavascriptHelper?
    let SCREEN_WIDTH = UIScreen.mainScreen().bounds.size.width
    let SCREEN_HEIGHT = UIScreen.mainScreen().bounds.size.height

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setWebView()
        webView?.loadRequest(NSURLRequest(URL: NSURL(string: urlString!)!))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "X", style: UIBarButtonItemStyle.Done, target: self, action: "dismiss")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = UIColor.whiteColor()
    }
    
    func dismiss() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func setWebView() {
        webView = UIWebView(frame: CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT))
        webView?.delegate = self
        webView?.alpha = 0
        view.addSubview(webView!)
        
        jsHelper = TCJavascriptHelper()
        jsHelper?.webView = webView
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        jsHelper?.hideJsClass(className: "rss_bx")
        jsHelper?.hideJsClass(className: "searchBox")
        jsHelper?.hideJsClass(className: "mianNav")
        jsHelper?.hideJsClass(className: "footer")
        jsHelper?.hideJsClass(className: "account_txt")
        jsHelper?.hideJsClass(className: "btn_share")
        jsHelper?.hideJsClass(className: "btn_favorites")
        jsHelper?.hideJsClass(className: "beg_box")
        jsHelper?.hideJsClass(className: "tabLst")
    
        let anim = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        anim.toValue = 1.0
        anim.duration = 0.5
        webView.pop_addAnimation(anim, forKey: "to1")
    }
}
