//
//  BaseVc.swift
//  SoweSwift
//
//  Created by 程天聪 on 15/11/10.
//  Copyright © 2015年 CTC. All rights reserved.
//

import UIKit

class BaseVc: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "openArticleFromPasteBoard:", name: "ArticleFromPasteBoard", object: nil)
    }

    func setTextAttributes(forBarButtonItem barButtonItem:UIBarButtonItem, fontSize:CGFloat) {
        barButtonItem.setTitleTextAttributes([NSFontAttributeName : UIFont(name: "iconfont", size: fontSize)!,NSForegroundColorAttributeName : UIColor.blackColor()], forState: UIControlState.Normal)
    }
    func openArticleFromPasteBoard(notification: NSNotification) {
        let urlString = notification.object as! String
        let vc = WXArticleVc()
        vc.isPresent = true
        vc.urlString = urlString
        presentViewController(UINavigationController(rootViewController: vc), animated: true, completion: nil)
    }

}
