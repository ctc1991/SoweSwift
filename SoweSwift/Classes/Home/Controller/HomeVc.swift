//
//  HomeVc.swift
//  SoweSwift
//
//  Created by 程天聪 on 15/11/10.
//  Copyright © 2015年 CTC. All rights reserved.
//

import UIKit

class HomeVc: BaseVc {
    var scrollNode : ASScrollNode?
    var backgroundImageNode : ASImageNode?
    var outView : UIView?
    var topView : UIView?
    var searchView : UIView?
    var midView : UIView?
    var botView : UIView?
    var collectionView : UICollectionView?
    var clearButton : UIButton?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initUI()
    }
    
    func initUI() {
        setImageNode()
        setScrollNode()

    }
    
    func setImageNode() {
        backgroundImageNode = ASImageNode()
        backgroundImageNode?.frame = UIScreen.mainScreen().bounds
        backgroundImageNode?.backgroundColor = UIColor.whiteColor()
        backgroundImageNode?.image = UIImage(named: "bg_5")
        view.addSubnode(backgroundImageNode)
    }
    
    func setScrollNode() {
        scrollNode = ASScrollNode()
        scrollNode?.frame = UIScreen.mainScreen().bounds
        scrollNode?.view.contentSize = CGSizeMake(0, UIScreen.mainScreen().bounds.size.height + ResizeScreen.offsetY())
        scrollNode?.view?.tag = 10086
        scrollNode?.view?.contentOffset = CGPointMake(0, ResizeScreen.offsetY())
        scrollNode?.view?.showsVerticalScrollIndicator = false
        view.addSubnode(scrollNode)
        setScrollNodeSubviews()
    }
    
    func setScrollNodeSubviews() {
        
    }
    
}
