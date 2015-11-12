//
//  HomeVc.swift
//  SoweSwift
//
//  Created by 程天聪 on 15/11/10.
//  Copyright © 2015年 CTC. All rights reserved.
//

import UIKit


class HomeVc: BaseVc
, UITextFieldDelegate
, UIScrollViewDelegate
, ASCollectionViewDataSource {
    var scrollNode: ASScrollNode?
    var backgroundImageNode : ASImageNode?
    var outNode: ASDisplayNode?
    var topNode: ASDisplayNode?
    var searchNode : ASDisplayNode?
    var midNode: ASDisplayNode?
    var botNode: ASDisplayNode?
    var clearButton: UIButton?
    var textField: UITextField?
    let SCREEN_WIDTH = UIScreen.mainScreen().bounds.size.width
    let SCREEN_HEIGHT = UIScreen.mainScreen().bounds.size.height
    let offsetY = ResizeScreen.offsetY()
    var isShow: Bool?
    var isTop: Bool?
    var lessThanZero: Bool?
    var keywords = ["新闻", "职场", "美食", "风景", "鸡汤", "旅行", "娱乐", "体育"]
    var collectionView: ASCollectionView?

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
        backgroundImageNode?.image = UIImage(named: "bg_7")
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
        scrollNode?.view.delegate = self
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
        topNode?.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "hideTextField"))
        topNode?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        topNode?.alpha = 0
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
        midNode?.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "showTextField"))
        
        collectionView = ASCollectionView?()
        let width = min(midNode!.bounds.size.width-80, midNode!.bounds.size.height)
        collectionView!.frame = CGRectMake(0, 0, width, width)
        collectionView!.center = CGPointMake((midNode?.view.center.x)!, (collectionView?.center.y)!)
        collectionView?.backgroundColor = UIColor.clearColor()
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.asyncDataSource = self
        midNode?.view.addSubview(collectionView!)
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
            scrollNode?.view.pop_removeAllAnimations()
            scrollNode?.view.pop_addAnimation(animOffset, forKey: "showTextField")
            isShow = true
            
            let animAlpha2 = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
            animAlpha2.toValue = 1.0
            topNode?.view.pop_removeAllAnimations()
            topNode?.view.pop_addAnimation(animAlpha2, forKey: "animAlpha")

            
            let animAlpha = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
            animAlpha.toValue = 0.0
            searchNode?.view.pop_removeAllAnimations()
            searchNode?.view.pop_addAnimation(animAlpha, forKey: "animAlpha")
            
            let animScale = POPBasicAnimation(propertyNamed: kPOPViewSize)
            animScale.duration = 0.4
            animScale.toValue = NSValue(CGSize: CGSizeMake(view.bounds.size.width*1.5,view.bounds.size.height*1.5))
            backgroundImageNode?.view.pop_addAnimation(animScale, forKey: "scale0")
        }

    }
    
    func hideTextField() {
        textField?.resignFirstResponder()
        if (isShow == true) {
            scrollNode!.view.scrollEnabled = true
            let animOffset = POPBasicAnimation(propertyNamed: kPOPScrollViewContentOffset)
            animOffset.toValue = NSValue(CGPoint: CGPointMake(0, offsetY))
            animOffset.duration = 0.2
            scrollNode?.view.pop_removeAllAnimations()
            scrollNode?.view.pop_addAnimation(animOffset, forKey: "hideTextField")
            isShow = false
            
            let animAlpha2 = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
            animAlpha2.toValue = 0.0
            animAlpha2.duration = 0.5;
            topNode?.view.pop_removeAllAnimations()
            topNode?.view.pop_addAnimation(animAlpha2, forKey: "animAlpha")
            
            let animAlpha = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
            animAlpha.toValue = 1.0
            animAlpha.duration = 0.3;
            searchNode?.view.pop_removeAllAnimations()
            searchNode?.view.pop_addAnimation(animAlpha, forKey: "animAlpha2")
            
            let animScale = POPBasicAnimation(propertyNamed: kPOPViewSize)
            animScale.duration = 0.2
            animScale.toValue = NSValue(CGSize: CGSizeMake(view.bounds.size.width*1,view.bounds.size.height*1))
            backgroundImageNode?.view.pop_addAnimation(animScale, forKey: "scale01")
        }

    }
    
    func clearTextField() {
        textField?.text = ""
    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
        var ratio = (offsetY - scrollView.contentOffset.y)/offsetY
        ratio = (0.5+ratio) > 1.8 ? 1.8 : (0.5+ratio)
        ratio = ratio < 1 ? 1 : ratio
        
        let animScale = POPBasicAnimation(propertyNamed: kPOPViewSize)
        animScale.duration = 0.1
        animScale.toValue = NSValue(CGSize: CGSizeMake(view.bounds.size.width*ratio,view.bounds.size.height*ratio))
        backgroundImageNode?.view.pop_addAnimation(animScale, forKey: "scale")
        
        print(ratio)
        if (scrollView.tag == 10086) {
            if (scrollView.contentOffset.y > offsetY) {
                scrollView.contentOffset = CGPointMake(0, offsetY)
            }
            if (scrollView.contentOffset.y < -offsetY) {
                scrollView.contentOffset = CGPointMake(0, -offsetY)
            }
        }
    }
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if (scrollView.tag == 10086) {
            if (scrollView.contentOffset.y < offsetY) {
                showTextField()
            }
        }
    }
    
    func collectionView(collectionView: UICollectionView!, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
}
