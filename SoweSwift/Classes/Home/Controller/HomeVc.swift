//
//  HomeVc.swift
//  SoweSwift
//
//  Created by 程天聪 on 15/11/10.
//  Copyright © 2015年 CTC. All rights reserved.
//

import UIKit


class HomeVc: BaseVc ,UITextFieldDelegate {
    var scrollNode: ASScrollNode?
    var backgroundImageNode : ASImageNode?
    var outNode: ASDisplayNode?
    var topNode: ASDisplayNode?
    var searchNode : ASDisplayNode?
    var midNode: ASDisplayNode?
    var botNode: ASDisplayNode?
    var collectionView: UICollectionView?
    var clearButton: UIButton?
    var textField: UITextField?
    let SCREEN_WIDTH = UIScreen.mainScreen().bounds.size.width
    let SCREEN_HEIGHT = UIScreen.mainScreen().bounds.size.height
    let offsetY = ResizeScreen.offsetY()
    var isShow: Bool?
    var isTop: Bool?
    var lessThanZero: Bool?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        lessThanZero = false
        isShow = false
        initUI()
    }
    
    /** 初始化UI */
    func initUI() {
        setImageNode()
        setScrollNode()
    }
    /** 设置背景图 */
    func setImageNode() {
        backgroundImageNode = ASImageNode()
        backgroundImageNode?.frame = UIScreen.mainScreen().bounds
        backgroundImageNode?.backgroundColor = UIColor.whiteColor()
        backgroundImageNode?.image = UIImage(named: "bg_5")
        view.addSubnode(backgroundImageNode)
    }
    /** 设置滑动界面 */
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
    /** 设置滑动界面子视图 */
    func setScrollNodeSubviews() {
        setOutNode()
        setTopNode()
        setSearchNode()
        setMidNode()
        setBotNode()
    }
    /** 初始化滑动界面每个子视图 */
    func setScrollNodeSubview(frame:CGRect) -> ASDisplayNode{
        let node = ASDisplayNode()
        node!.frame = frame
        scrollNode?.addSubnode(node)
        return node
    }
    func setOutNode() {
        outNode = setScrollNodeSubview(CGRectMake(0, 0, SCREEN_WIDTH, offsetY))
        outNode?.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "hideTextField"))
    }
    func setTopNode() {
        topNode = setScrollNodeSubview(CGRectMake(0, offsetY, SCREEN_WIDTH, offsetY))
        topNode?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
        topNode?.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "hideTextField"))
        textField = UITextField(frame: CGRectMake(40, topNode!.bounds.size.height*2/3.0, topNode!.bounds.size.width-80, topNode!.bounds.size.height/3.0))
        textField!.tintColor = UIColor.whiteColor()
        textField!.textColor = UIColor.whiteColor()
        textField!.font = UIFont.systemFontOfSize(20)
        textField!.returnKeyType = UIReturnKeyType.Search
        textField!.delegate = self
        topNode?.view.addSubview(textField!)
        
        clearButton = UIButton(type: UIButtonType.Custom)
        clearButton?.titleLabel?.font = UIFont(name: "iconfont", size: 30)
        clearButton?.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        clearButton?.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        clearButton?.setTitle("\u{e604}", forState: UIControlState.Normal)
        clearButton?.frame = CGRectMake(10, 10, textField!.bounds.size.height, textField!.bounds.size.height)
        clearButton?.addTarget(self, action: "clearTextField", forControlEvents: UIControlEvents.TouchUpInside)
        
        textField?.rightViewMode = UITextFieldViewMode.Always
        textField?.rightView = clearButton
    }
    func setSearchNode() {
        searchNode = setScrollNodeSubview(CGRectMake(0, offsetY*2, SCREEN_WIDTH, offsetY))
        searchNode?.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "showTextField"))
        
        let titleLbl = UILabel(frame: CGRectMake(0, 0, searchNode!.bounds.size.width, searchNode!.bounds.size.height/2.0))
        titleLbl.textAlignment = NSTextAlignment.Center
        titleLbl.font = UIFont.boldSystemFontOfSize(ResizeScreen.searchFontSize())
        titleLbl.text = "精彩尽在搜微"
        titleLbl.textColor = UIColor.whiteColor()
        searchNode?.view.addSubview(titleLbl)
        
        let arrowLbl = UILabel(frame: CGRectMake(0, searchNode!.bounds.size.height/2.0, searchNode!.bounds.size.width, searchNode!.bounds.size.height/2.0))
        arrowLbl.textAlignment = NSTextAlignment.Center
        arrowLbl.font = UIFont(name: "iconfont", size: ResizeScreen.searchFontSize())
        arrowLbl.text = "\u{e606}"
        arrowLbl.textColor = UIColor.whiteColor()
        searchNode?.view.addSubview(arrowLbl)
    }
    func setMidNode() {
        midNode = setScrollNodeSubview(CGRectMake(0, offsetY*3, SCREEN_WIDTH, (SCREEN_HEIGHT-2.5*offsetY)))
    }
    func setBotNode() {
        botNode = setScrollNodeSubview(CGRectMake(0, SCREEN_HEIGHT+0.5*offsetY, SCREEN_WIDTH, offsetY*0.5))
    }
    
    func showTextField() {
        textField?.becomeFirstResponder()
        if (isShow == false) {
            scrollNode!.view.scrollEnabled = false
            let animOffset = POPSpringAnimation(propertyNamed: kPOPScrollViewContentOffset)
            animOffset.toValue = NSValue(CGPoint: CGPointMake(0, 0))
            animOffset.springBounciness = 15
            animOffset.springSpeed = 10
            scrollNode?.view.pop_addAnimation(animOffset, forKey: "showTextField")
//            animOffset.completionBlock = {( anim: POPAnimation, finished: Bool) in
                isShow = true
//            }
        }

    }
    
    func hideTextField() {
        textField?.resignFirstResponder()
        if (isShow == true) {
            scrollNode!.view.scrollEnabled = true
            let animOffset = POPBasicAnimation(propertyNamed: kPOPScrollViewContentOffset)
            animOffset.toValue = NSValue(CGPoint: CGPointMake(0, offsetY))
            animOffset.duration = 0.2
            scrollNode?.view.pop_addAnimation(animOffset, forKey: "hideTextField")
            //            animOffset.completionBlock = {( anim: POPAnimation, finished: Bool) in
            //                isShow = true
            //            }
            isShow = false
        }

    }
    
    func clearTextField() {
        textField?.text = ""
    }
    
}
