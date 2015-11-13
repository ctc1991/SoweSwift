//
//  ResultVc.swift
//  SoweSwift
//
//  Created by 程天聪 on 15/11/11.
//  Copyright © 2015年 CTC. All rights reserved.
//

import UIKit

class ResultVc: BaseVc,
UIWebViewDelegate,
UIScrollViewDelegate,
UITextFieldDelegate {
    var webView: UIWebView?
    var keyword: String?
    var noResultImageNode: ASImageNode?
    var jsHelper: TCJavascriptHelper?
    var textField: UITextField?
    let SCREEN_WIDTH = UIScreen.mainScreen().bounds.size.width
    let SCREEN_HEIGHT = UIScreen.mainScreen().bounds.size.height

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.whiteColor()
        setWebView()
        search(keyword: keyword!)
        

        setNavigationBar()
        textField?.text = keyword
        
        noResultImageNode = ASImageNode()
        noResultImageNode?.frame = (webView?.bounds)!
        noResultImageNode?.image = UIImage(named: "no_result")
        noResultImageNode?.hidden = true
        noResultImageNode?.contentMode = UIViewContentMode.ScaleAspectFit
        noResultImageNode?.backgroundColor = UIColor.lightGrayColor()
        webView?.addSubnode(noResultImageNode)
    }
    func setNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(TCAppUtils.imageWithColor(UIColor(red: 0, green: 0, blue: 0, alpha: 0.99), size: CGSize(width: SCREEN_WIDTH, height: 64)), forBarMetrics: UIBarMetrics.Default)
        
        
        let leftBtn = UIBarButtonItem(title: "\u{e604}", style: UIBarButtonItemStyle.Done, target: self, action: "dismiss")
        leftBtn.setTitleTextAttributes([NSFontAttributeName : UIFont(name: "iconfont", size: 32)!,NSForegroundColorAttributeName : UIColor.whiteColor()], forState: UIControlState.Normal)
        navigationItem.leftBarButtonItem = leftBtn
        
        let rightBtn = UIBarButtonItem(title: "\u{e603}", style: UIBarButtonItemStyle.Done, target: self, action: "refresh")
        rightBtn.setTitleTextAttributes([NSFontAttributeName : UIFont(name: "iconfont", size: 32)!,NSForegroundColorAttributeName : UIColor.whiteColor()], forState: UIControlState.Normal)
        navigationItem.rightBarButtonItem = rightBtn
        
        textField = UITextField(frame: CGRect(x: SCREEN_WIDTH/4.0, y: 0, width: SCREEN_WIDTH/2.0, height: 40))
        textField!.backgroundColor = UIColor.clearColor()
        textField!.placeholder = "点击搜索"
        textField!.textColor = UIColor.whiteColor()
        textField!.textAlignment = NSTextAlignment.Center
        textField!.tintColor = UIColor.whiteColor()
        textField!.delegate = self
        textField!.setValue(UIColor.whiteColor(), forKeyPath: "_placeholderLabel.textColor")
        navigationController?.navigationBar.addSubview(textField!)
    }
    
    func search(var keyword keyword: String) {
        keyword = keyword.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())!
        let urlString = "http://weixin.sogou.com/weixinwap?type=2&query=\(keyword)&page=1"
        webView?.loadRequest(NSURLRequest(URL: NSURL(string: urlString)!))
    }
    
    func dismiss() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    func refresh() {
        if (noResultImageNode!.hidden == true) {
            textField!.resignFirstResponder()
            webView?.reload()
        }
    }
    func setWebView() {
        webView = UIWebView(frame: CGRectMake(-7, -9, SCREEN_WIDTH+14, SCREEN_HEIGHT+28))
        webView?.delegate = self
        view.addSubview(webView!)
        webView?.scrollView.delegate = self
        webView!.backgroundColor = UIColor.whiteColor()
        webView?.scrollView.showsVerticalScrollIndicator = false
        jsHelper = TCJavascriptHelper()
        jsHelper?.webView = webView
        
        webView?.scrollView.mj_header = MJRefreshNormalHeader(refreshingBlock: { () -> Void in
            self.refresh()
            self.webView?.scrollView.mj_header.endRefreshing()
        })
//        webView?.scrollView.mj_footer = MJRefreshBackStateFooter(refreshingBlock: { () -> Void in
//            self.dismiss()
//            self.webView?.scrollView.mj_footer.endRefreshing()
//        })
 
    }
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        webView.alpha = 0
        let urlString:String = String(request.URL!)
        if (urlString.hasPrefix("http://mp.weixin.qq.com/")) {
            let vc = WXArticleVc()
            vc.urlString = urlString
            navigationController?.pushViewController(vc, animated: true)
            webView.alpha = 1
            return false
        } else if (urlString.hasPrefix("http://yibo.iyiyun.com")) {
            //查询无结果
            noResultImageNode!.hidden = false
            return false
        } else if (urlString.hasPrefix("http://weixin.sogou.com/antispider")) {
            //反蜘蛛
        } else if (urlString.hasPrefix("http://weixin.sogou.com/weixinwap")) {
            //查询基本页
        } else if (urlString.hasPrefix("http://weixin.sogou.com/websearch")) {
            //请求文章页
        }
        noResultImageNode?.hidden = true
        return true
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        
        //隐藏常规界面
        jsHelper?.hideElement(className: "rss_bx")
        jsHelper?.hideElement(className: "searchBox")
        jsHelper?.hideElement(className: "mianNav")
        jsHelper?.hideElement(className: "footer")
        jsHelper?.hideElement(className: "account_txt")
        jsHelper?.hideElement(className: "btn_share")
        jsHelper?.hideElement(className: "btn_favorites")
        jsHelper?.hideElement(className: "beg_box")
        jsHelper?.hideElement(className: "tabLst")
        //出现异常时 清除界面元素
        jsHelper?.hideElement(className: "h12")
        jsHelper?.hideElement(tagName: "table", index: 0)
        jsHelper?.hideElement(tagName: "table", index: 3)
        //搜不到结果
        jsHelper?.hideElement(className: "beg_box", index: 0)
        
        webView.scrollView.contentOffset = CGPoint(x: 0, y: -64)
        let anim = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        anim.toValue = 1.0
        anim.duration = 0.5
        webView.pop_addAnimation(anim, forKey: "to1")
    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
        print("offset\(scrollView.contentOffset.y)")
        print("height\(scrollView.contentSize.height)")
        textField!.resignFirstResponder()
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        search(keyword: textField.text!)
        textField.resignFirstResponder()
        return true
    }
}
