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
        return true
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        let pasteBoard = UIPasteboard.generalPasteboard()
        if (pasteBoard.string!.hasPrefix("http://mp.weixin.qq.com/")) {
            NSNotificationCenter.defaultCenter().postNotificationName("ArticleFromPasteBoard", object: pasteBoard.string)
        }
    }
}

