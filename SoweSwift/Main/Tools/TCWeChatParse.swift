//
//  TCWeChatParse.swift
//  SoweSwift
//
//  Created by ctc on 15/11/14.
//  Copyright © 2015年 CTC. All rights reserved.
//

import Foundation

class TCWeChatParse {
    class func articles(urlString urlString: String, completion: ((NSMutableArray) -> Void)?) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            let url = NSURL(string: urlString)
            let data = NSData(contentsOfURL: url!)
            let dataString = String(data: data!, encoding: NSUTF8StringEncoding)
            let dataArray = TCWeChatParse.array(dataString: dataString!)
            let articles = NSMutableArray()
            for str in dataArray {
                let article = TCWeChatModel.article(dataString: str as! String)
                articles.addObject(article)
            }
            dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                completion!(articles)
            })
        }

    }
    class func array(dataString dataString:String) -> NSMutableArray {
        let a1 = NSArray(array: dataString.componentsSeparatedByString("<!-- a -->"))
        let a2 = NSMutableArray()
        for var index=0; index<a1.count; index++ {
            let str = a1[index]
            let str2 = NSArray(array: str.componentsSeparatedByString("<!-- z -->")).firstObject
            a2.addObject(str2!)
        }
        a2.removeObjectAtIndex(0)
        return a2
    }
    class func sg10(string:String) -> String {
        let str = NSArray(array: string.componentsSeparatedByString("sg=")).objectAtIndex(1) as! String
        var nsStr = NSString(format: "%@", str)
        nsStr = nsStr.substringToIndex(10)
        return nsStr as String
    }
}
class TCWeChatModel {
    var urlString: String?
    var image: String?
    var title: String?
    var nickname: String?
    var time: Double?
    
    func showSelf() {
        print("urlString:"+urlString!)
        print("image:"+image!)
        print("title:"+title!)
        print("nickname:"+nickname!)
        print("time:\(time!)\n")
    }
    
    class func article(dataString dataString:String) -> TCWeChatModel {
        let model = TCWeChatModel()
        model.urlString = string(leadingString: "<a class=\"news_lst_tab2\" href=\"", tailingString: "\" uigs_exp_id", forString: dataString)
        if model.urlString!.hasPrefix("/websearch/art.jsp?") {
            model.urlString = "http://weixin.sogou.com" + model.urlString!
            model.image = string(leadingString: "url=", tailingString: "\"></div>\n", forString: string(leadingString: "this.parentNode", tailingString: "<div class=\"news_txt_box2\">", forString: dataString))
        } else {
            model.image = string(leadingString: "url=http", tailingString: "\"></div>\n<div class=\"news_txt_box2\">", forString: dataString)
        }
        model.title = htmlEntityDecode(forString: string(leadingString: "40px\">", tailingString: "</p>\n<p class=\"news_lst_txt3\" style=\"display:none;\">", forString: dataString))
        model.nickname = htmlEntityDecode(forString: string(leadingString: "title=\"", tailingString: "\" i=\"", forString: dataString))
        model.time = Double(string(leadingString: "\" t=\"", tailingString: "\">\n<span target=\"", forString: dataString))
//        model.showSelf()
        return model
    }
    
    class func string(leadingString leadingString: String,tailingString: String, forString string:String) -> String {
        let str = NSArray(array: string.componentsSeparatedByString(leadingString)).objectAtIndex(1)
        return NSArray(array: str.componentsSeparatedByString(tailingString)).objectAtIndex(0) as! String
    }
    /**HTML转义*/
    class func htmlEntityDecode(var forString string:String) -> String {
        // HTML
        string = string.stringByReplacingOccurrencesOfString("&quot;", withString: "\"")
        string = string.stringByReplacingOccurrencesOfString("&apos;", withString: "'")
        string = string.stringByReplacingOccurrencesOfString("&amp;", withString: "&")
        string = string.stringByReplacingOccurrencesOfString("&lt;", withString: "<")
        string = string.stringByReplacingOccurrencesOfString("&gt;", withString: ">")
        string = string.stringByReplacingOccurrencesOfString("&mdash;", withString: "—")
        string = string.stringByReplacingOccurrencesOfString("&ldquo;", withString: "“")
        string = string.stringByReplacingOccurrencesOfString("&rdquo;", withString: "”")
        string = string.stringByReplacingOccurrencesOfString("&deg;", withString: "°")
        string = string.stringByReplacingOccurrencesOfString("&bull;", withString: "•")
        string = string.stringByReplacingOccurrencesOfString("&middot;", withString: "·")
        string = string.stringByReplacingOccurrencesOfString("&hellip;", withString: "…")
        string = string.stringByReplacingOccurrencesOfString("&cap;", withString: "∩")
        string = string.stringByReplacingOccurrencesOfString("&nbsp;&nbsp;", withString: " | ")
        string = string.stringByReplacingOccurrencesOfString("&nbsp;", withString: " ")
        // 因搜索的红字关键字
        string = string.stringByReplacingOccurrencesOfString("<em>", withString: "")
        string = string.stringByReplacingOccurrencesOfString("</em>", withString: "")
        string = string.stringByReplacingOccurrencesOfString("<!--red_beg-->", withString: "")
        string = string.stringByReplacingOccurrencesOfString("<!--red_end-->", withString: "")
        return string
    }
}

