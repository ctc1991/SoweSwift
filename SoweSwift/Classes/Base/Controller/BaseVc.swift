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
    }

    func setTextAttributes(forBarButtonItem barButtonItem:UIBarButtonItem, fontSize:CGFloat) {
        barButtonItem.setTitleTextAttributes([NSFontAttributeName : UIFont(name: "iconfont", size: fontSize)!,NSForegroundColorAttributeName : UIColor.blackColor()], forState: UIControlState.Normal)
    }
}
