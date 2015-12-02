//
//  AppDelegate.swift
//  SoweSwift
//
//  Created by 程天聪 on 15/11/10.
//  Copyright © 2015年 CTC. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.rootViewController = HomeVc()
        window?.makeKeyAndVisible()
        window?.backgroundColor = UIColor.whiteColor()
        setUmeng()
        return true
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        let string = UIPasteboard.generalPasteboard().string
        if (string != nil && string!.hasPrefix("http://mp.weixin.qq.com/")) {
            NSNotificationCenter.defaultCenter().postNotificationName("ArticleFromPasteBoard", object: nil)
        }
    }
    
    func setUmeng() {
        UMSocialData.setAppKey("55dec0a367e58ecfa600000c")
        UMSocialConfig.setFinishToastIsHidden(true, position: UMSocialiToastPositionTop)
        UMSocialWechatHandler.setWXAppId("wx473e5ce5f11196f6", appSecret: "c6661a896baed2245a850ae98ed95e58", url: "http://www.ctc1991.com/ctc1991")
        UMSocialQQHandler.setQQWithAppId("1104837386", appKey: "HBNzDlquxJGzq4An", url: "http://www.ctc1991.com/ctc1991")
//        UMSocialConfig.hiddenNotInstallPlatforms([UMShareToQQ,UMShareToQzone,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToWechatFavorite])
    }
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        return UMSocialSnsService.handleOpenURL(url)
    }
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return UMSocialSnsService.handleOpenURL(url)
    }
}
