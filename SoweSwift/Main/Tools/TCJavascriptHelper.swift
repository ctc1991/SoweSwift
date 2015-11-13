//
//  TCJavascriptHelper.swift
//  SoweSwift
//
//  Created by 程天聪 on 15/11/11.
//  Copyright © 2015年 CTC. All rights reserved.
//

import UIKit

class TCJavascriptHelper: NSObject {
    var webView: UIWebView?
    
    func runJsCode(code code:String) -> String {
        return webView!.stringByEvaluatingJavaScriptFromString(code)!
    }
    func hideElement(className className:String) {
        let index = Int(runJsCode(code: "document.getElementsByClassName('\(className)').length"))
        for i in 0..<index! {
            runJsCode(code: "document.getElementsByClassName('\(className)')[\(i)].style.display='none'")
        }
    }
    func hideElement(tagName tagName:String, index:Int) {
        runJsCode(code: "document.getElementsByTagName('\(tagName)')[\(index)].style.display='none'")
    }
    func hideElement(className className:String, index:Int) {
        runJsCode(code: "document.getElementsByClassName('\(className)')[\(index)].style.display='none'")
    }

}
