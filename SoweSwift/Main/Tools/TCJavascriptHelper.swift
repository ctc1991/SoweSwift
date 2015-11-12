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
    func hideJsClass(className className:String) {
        let index = Int(runJsCode(code: "document.getElementsByClassName('\(className)').length"))
        for i in 0..<index! {
            runJsCode(code: "document.getElementsByClassName('\(className)')[\(i)].style.display='none'")
        }
    }
}
