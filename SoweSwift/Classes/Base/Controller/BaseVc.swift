//
//  BaseVc.swift
//  SoweSwift
//
//  Created by 程天聪 on 15/11/10.
//  Copyright © 2015年 CTC. All rights reserved.
//


import UIKit

class BaseVc: UIViewController,
UIAlertViewDelegate,
UMSocialUIDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "openArticleFromPasteBoard:", name: "ArticleFromPasteBoard", object: nil)
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "ArticleFromPasteBoard", object: nil)
    }

    func setTextAttributes(forBarButtonItem barButtonItem:UIBarButtonItem, fontSize:CGFloat) {
        barButtonItem.setTitleTextAttributes([NSFontAttributeName : UIFont(name: "iconfont", size: fontSize)!,NSForegroundColorAttributeName : UIColor.blackColor()], forState: UIControlState.Normal)
    }
    func openArticleFromPasteBoard(notification: NSNotification) {
        
        UIAlertView(title: "搜微", message: "您复制了一篇微文，是否打开？", delegate: self, cancelButtonTitle: "清空复制", otherButtonTitles: "确认打开").show()
        
        
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        switch buttonIndex {
        case 1:
            print("ok")
            let vc = WXArticleVc()
            vc.isPresent = true
            vc.urlString = UIPasteboard.generalPasteboard().string
            presentViewController(UINavigationController(rootViewController: vc), animated: true, completion: nil)
        default:
            print("cancel")
            UIPasteboard.generalPasteboard().string = ""
        }
    }
    
    func share(title title: String, content: String, image: String, url: String) {
        UMSocialSnsService.presentSnsController(self, appKey: "55dec0a367e58ecfa600000c", shareText: title, shareImage: UIImage(data: NSData(contentsOfURL: NSURL(string: image)!)!), shareToSnsNames: [UMShareToWechatSession,UMShareToWechatTimeline,UMShareToWechatFavorite,UMShareToEmail,UMShareToQQ,UMShareToSms], delegate: self)

    }
    
    func didSelectSocialPlatform(platformName: String!, withSocialData socialData: UMSocialData!) {
        print(platformName)
    }
}
