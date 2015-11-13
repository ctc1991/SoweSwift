//
//  WXArticleVc.swift
//  SoweSwift
//
//  Created by 程天聪 on 15/11/11.
//  Copyright © 2015年 CTC. All rights reserved.
//

import UIKit

class WXArticleVc: BaseVc {
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
    }
    
    func setWebView() {
        webView = UIWebView(frame: CGRectMake(-7, -9, SCREEN_WIDTH+14, SCREEN_HEIGHT+28))
//        webView?.delegate = self
        view.addSubview(webView!)
        webView!.backgroundColor = UIColor.whiteColor()
        webView?.scrollView.showsVerticalScrollIndicator = false
        jsHelper = TCJavascriptHelper()
        jsHelper?.webView = webView
        
        webView?.scrollView.mj_header = MJRefreshNormalHeader(refreshingBlock: { () -> Void in
            self.refresh()
            self.webView?.scrollView.mj_header.endRefreshing()
        })
    }
    func refresh() {
            webView?.reload()
    }


}
