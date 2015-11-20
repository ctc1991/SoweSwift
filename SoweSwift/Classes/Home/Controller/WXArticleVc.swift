//
//  WXArticleVc.swift
//  SoweSwift
//
//  Created by 程天聪 on 15/11/11.
//  Copyright © 2015年 CTC. All rights reserved.
//

import UIKit

class WXArticleVc: BaseVc,
UIWebViewDelegate,
UIGestureRecognizerDelegate {
    var urlString: String?
    var webView: UIWebView?
    var floatNode: ASDisplayNode?
    var jsHelper: TCJavascriptHelper?
    let SCREEN_WIDTH = UIScreen.mainScreen().bounds.size.width
    let SCREEN_HEIGHT = UIScreen.mainScreen().bounds.size.height
    var bottomBtn: UIButton?
    var topBtn: UIButton?
    var topNode: ASDisplayNode?
    var isPresent: Bool?
    var model: TCWeChatModel?
    var textField: UITextField?
    var nickname: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        model?.showSelf()
        initUI()
        webView?.loadRequest(NSURLRequest(URL: NSURL(string: urlString!)!))
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        textField?.text = nickname
    }
    func initUI() {
//        setToolbar()
        setWebView()
//        setTopNode()
        setFloatNode()
        setNavigationBar()
    }
    func setFloatNode() {
        floatNode = ASDisplayNode()
        floatNode?.frame = CGRect(x: SCREEN_WIDTH-54, y: SCREEN_HEIGHT-150, width: 44, height: 100)
        view.addSubnode(floatNode)
        
        topBtn = UIButton(type: UIButtonType.Custom)
        topBtn!.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        topBtn!.titleLabel?.font = UIFont(name: "iconfont", size: 25)
        topBtn!.setTitle("\u{e60E}", forState: UIControlState.Normal)
        topBtn!.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        topBtn!.addTarget(self, action: "goToTop", forControlEvents: UIControlEvents.TouchUpInside)
        floatNode?.view.addSubview(topBtn!)
        
        bottomBtn = UIButton(type: UIButtonType.Custom)
        bottomBtn!.frame = CGRect(x: 0, y: 56, width: 44, height: 44)
        bottomBtn!.titleLabel?.font = UIFont(name: "iconfont", size: 25)
        bottomBtn!.setTitle("\u{e602}", forState: UIControlState.Normal)
        bottomBtn!.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        bottomBtn!.addTarget(self, action: "goToBottom", forControlEvents: UIControlEvents.TouchUpInside)
        floatNode?.view.addSubview(bottomBtn!)
        
        
    }
    func hehe() {
        print("呵呵呵")
    }
    func setTopNode() {
        topNode = ASDisplayNode()
        topNode?.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 64)
        topNode?.backgroundColor = UIColor.blackColor()
        view.addSubnode(topNode!)
        
        let titleLbl = UILabel(frame: CGRect(x: 8, y: 20, width: SCREEN_WIDTH-16, height: 44))
        titleLbl.text = "项目经理PMP证书项目经理PM"
        titleLbl.textAlignment = NSTextAlignment.Center
        titleLbl.textColor = UIColor.whiteColor()
        titleLbl.adjustsFontSizeToFitWidth = true
        topNode?.view.addSubview(titleLbl)
        
        let timeLbl = UILabel(frame: CGRect(x: 8, y: 80, width: SCREEN_WIDTH, height: 12))
        timeLbl.text = "4小时前"
        timeLbl.textAlignment = NSTextAlignment.Center
        timeLbl.textColor = UIColor.lightGrayColor()
        timeLbl.font = UIFont.systemFontOfSize(10)
        view.addSubview(timeLbl)
        
        let nameLbl = UILabel(frame: CGRect(x: 8, y: 64, width: SCREEN_WIDTH, height: 16))
        nameLbl.text = "花园CTC"
        nameLbl.textAlignment = NSTextAlignment.Center
        nameLbl.textColor = UIColor(red: 0, green: 0, blue: 1, alpha: 0.6)
        nameLbl.font = UIFont.systemFontOfSize(14)
        view.addSubview(nameLbl)
    }
    func setWebView() {
        webView = UIWebView(frame: CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT))
        webView?.delegate = self
        view.addSubview(webView!)
        webView!.backgroundColor = UIColor.whiteColor()
        jsHelper = TCJavascriptHelper()
        jsHelper?.webView = webView
        
        
        let viewTest = UIView(frame: CGRect(x: 0, y: -100, width: 300, height: 100))
        viewTest.backgroundColor = UIColor.redColor()
//        webView?.scrollView.addSubview(viewTest)
        
        webView?.scrollView.mj_header = MJRefreshNormalHeader(refreshingBlock: { () -> Void in
            self.refresh()
            self.webView?.scrollView.mj_header.endRefreshing()
        })
        webView?.scrollView.contentOffset = CGPoint(x: 0, y: -64)
    }
    func setToolbar() {
//        let toolBar = UIToolbar(frame: CGRect(x: 0, y: SCREEN_HEIGHT-44, width: SCREEN_WIDTH, height: 44))
//        view.addSubview(toolBar)
//        
//        let backBtn = UIBarButtonItem(title: "\u{e601}", style: UIBarButtonItemStyle.Done, target: self, action: "back")
//        let shareBtn = UIBarButtonItem(title: "\u{e600}", style: UIBarButtonItemStyle.Done, target: self, action: "share")
//        bottomBtn = UIBarButtonItem(title: "\u{e602}", style: UIBarButtonItemStyle.Done, target: self, action: "goToBottom")
//        let topBtn = UIBarButtonItem(title: "\u{e60E}", style: UIBarButtonItemStyle.Done, target: self, action: "goToTop")
//        let weChatBtn = UIBarButtonItem(title: "\u{e60B}", style: UIBarButtonItemStyle.Done, target: self, action: "goToWeChat")
//        
//        
//        
//        setTextAttributes(forBarButtonItem: backBtn, fontSize: 25)
//        setTextAttributes(forBarButtonItem: shareBtn, fontSize: 25)
//        setTextAttributes(forBarButtonItem: bottomBtn!, fontSize: 25)
//        setTextAttributes(forBarButtonItem: topBtn, fontSize: 25)
//        setTextAttributes(forBarButtonItem: weChatBtn, fontSize: 25)
//        
//        let line = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 1))
//        line.backgroundColor = UIColor.blackColor()
//        toolBar.addSubview(line)
//        
//        let flexItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
//        let fixedItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
//        
//        toolBar.setItems([fixedItem,backBtn,flexItem,shareBtn,flexItem,topBtn,flexItem,bottomBtn!,fixedItem], animated: false)
    }
    func setNavigationBar() {
        
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        
        let rightBtn = UIBarButtonItem(title: "\u{e610}", style: UIBarButtonItemStyle.Done, target: self, action: "share")
        rightBtn.setTitleTextAttributes([NSFontAttributeName : UIFont(name: "iconfont", size: 32)!,NSForegroundColorAttributeName : UIColor.whiteColor()], forState: UIControlState.Normal)
        navigationItem.rightBarButtonItem = rightBtn
        
//        textField = UITextField(frame: CGRect(x: SCREEN_WIDTH/4.0, y: 0, width: SCREEN_WIDTH/2.0, height: 40))
//        textField!.backgroundColor = UIColor.clearColor()
//        textField!.placeholder = "点击搜索"
//        textField!.textColor = UIColor.whiteColor()
//        textField!.textAlignment = NSTextAlignment.Center
//        textField!.tintColor = UIColor.whiteColor()
//        textField!.delegate = self
//        textField?.font = UIFont.boldSystemFontOfSize(20)
//        textField!.setValue(UIColor.whiteColor(), forKeyPath: "_placeholderLabel.textColor")
//        navigationController?.navigationBar.addSubview(textField!)
    }
    func refresh() {
            webView?.reload()
    }
    func back() {
        if (isPresent == false) {
            navigationController?.popViewControllerAnimated(true)
        } else {
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    func share() {
        
    }
    func goToBottom() {
        let height:String = (self.jsHelper?.runJsCode(code: "document.body.offsetHeight"))!
        UIView.animateWithDuration(0.3) { () -> Void in
            self.jsHelper?.runJsCode(code: "window.scrollBy(0, \(height))")
        }
    }
    func goToTop() {
        let goToTop = POPSpringAnimation(propertyNamed: kPOPScrollViewContentOffset)
        goToTop.toValue = NSValue(CGPoint: CGPointMake(0, -64))
        goToTop.springBounciness = 10
        goToTop.springSpeed = 20
        webView?.scrollView.pop_addAnimation(goToTop, forKey: "goToTop")
        bottomBtn?.enabled = false
        goToTop.completionBlock = { (anim: POPAnimation!, finished: Bool!) -> Void in
            (self.bottomBtn?.enabled = true)!
        }
    }
    func goToWeChat() {
        
    }
    func webViewDidStartLoad(webView: UIWebView) {
        TCProgressView.show()
        TCProgressView.setPosition(TCProgressViewPosition.StatusBarAndNavigationBar)
    }
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        TCProgressView.dismiss()
    }
    func webViewDidFinishLoad(webView: UIWebView) {
        TCProgressView.dismiss()

//        jsHelper?.hideElement(elementId: "activity-name")
        jsHelper?.hideElement(elementId: "js_view_source")
//        jsHelper?.hideElement(className: "rich_media_meta_list")
        textField?.text = jsHelper?.element(elementId: "post-user")
        nickname = textField!.text
        if (nickname == model?.nickname) {
            //信息对称 分享才用图
            print("nickname相等")
        } else {
            print("信息不对称")
        }
    }


}
