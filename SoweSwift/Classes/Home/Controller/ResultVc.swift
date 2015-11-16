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
    var articles: NSMutableArray? = NSMutableArray()
    var tempArticleModel: TCWeChatModel?
    let SCREEN_WIDTH = UIScreen.mainScreen().bounds.size.width
    let SCREEN_HEIGHT = UIScreen.mainScreen().bounds.size.height

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.whiteColor()
        setWebView()

        
        setNavigationBar()
        textField?.text = keyword
        search(keyword: keyword!)
        
        
        noResultImageNode = ASImageNode()
        noResultImageNode?.frame = (webView?.bounds)!
        noResultImageNode?.image = UIImage(named: "no_result")
        noResultImageNode?.hidden = true
        noResultImageNode?.contentMode = UIViewContentMode.ScaleAspectFit
        noResultImageNode?.backgroundColor = UIColor.lightGrayColor()
        webView?.addSubnode(noResultImageNode)
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        textField?.text = keyword
        textField?.enabled = true
    }
    func setNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(TCAppUtils.imageWithColor(UIColor(red: 0, green: 0, blue: 0, alpha: 0.99), size: CGSize(width: SCREEN_WIDTH, height: 64)), forBarMetrics: UIBarMetrics.Default)
        
        let leftBtn = UIBarButtonItem(title: "\u{e604}", style: UIBarButtonItemStyle.Done, target: self, action: "dismiss")
        leftBtn.setTitleTextAttributes([NSFontAttributeName : UIFont(name: "iconfont", size: 32)!,NSForegroundColorAttributeName : UIColor.whiteColor()], forState: UIControlState.Normal)
        navigationItem.leftBarButtonItem = leftBtn
        
        let rightBtn = UIBarButtonItem(title: "\u{e607}", style: UIBarButtonItemStyle.Done, target: self, action: "search")
        rightBtn.setTitleTextAttributes([NSFontAttributeName : UIFont(name: "iconfont", size: 25)!,NSForegroundColorAttributeName : UIColor.whiteColor()], forState: UIControlState.Normal)
        navigationItem.rightBarButtonItem = rightBtn
        
        textField = UITextField(frame: CGRect(x: SCREEN_WIDTH/4.0, y: 0, width: SCREEN_WIDTH/2.0, height: 40))
        textField!.backgroundColor = UIColor.clearColor()
        textField!.placeholder = "点击搜索"
        textField!.textColor = UIColor.whiteColor()
        textField!.textAlignment = NSTextAlignment.Center
        textField!.tintColor = UIColor.whiteColor()
        textField!.delegate = self
        textField?.font = UIFont.boldSystemFontOfSize(20)
        textField!.setValue(UIColor.whiteColor(), forKeyPath: "_placeholderLabel.textColor")
        navigationController?.navigationBar.addSubview(textField!)
    }
    
    func search(var keyword keyword: String) {
        keyword = keyword.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())!
        let urlString = "http://weixin.sogou.com/weixinwap?type=2&query=\(keyword)&page=1"
        self.keyword = textField?.text
        webView?.loadRequest(NSURLRequest(URL: NSURL(string: urlString)!))
        textField?.resignFirstResponder()
    }
    
    func dismiss() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    func search() {
        if (textField?.editing != true) {
            textField?.becomeFirstResponder()
        } else {
            search(keyword: textField!.text!)
        }
        
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
            vc.model = tempArticleModel
            vc.model?.urlString = urlString
            textField?.text = tempArticleModel?.nickname
            textField?.enabled = false
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
            articles?.removeAllObjects()
            TCWeChatParse.articles(urlString: urlString, completion: { (articles) -> Void in
                self.articles = articles
            })
        } else if (urlString.hasPrefix("http://weixin.sogou.com/websearch")) {
            //请求文章页
            for var index=0; index<self.articles!.count; index++ {
                let model = self.articles?.objectAtIndex(index) as! TCWeChatModel
                let sg10_1 = TCWeChatParse.sg10(model.urlString!)
                let sg10_2 = TCWeChatParse.sg10(urlString)
                if (sg10_1 == sg10_2) {
                    tempArticleModel = TCWeChatModel()
                    tempArticleModel?.urlString = model.urlString
                    tempArticleModel?.image = model.image
                    tempArticleModel?.title = model.title
                    tempArticleModel?.nickname = model.nickname
                    tempArticleModel?.time = model.time
                }
            }
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
        //出现反蜘蛛页面
        jsHelper?.hideElement(className: "header", index: 0)
        jsHelper?.hideElement(elementId: "ft")
        //搜不到结果
        jsHelper?.hideElement(className: "beg_box", index: 0)
        
        webView.scrollView.contentOffset = CGPoint(x: 0, y: -64)
        let anim = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        anim.toValue = 1.0
        anim.duration = 0.5
        webView.pop_addAnimation(anim, forKey: "to1")
    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
        textField!.resignFirstResponder()
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        search(keyword: textField.text!)
        textField.resignFirstResponder()
        return true
    }
}
