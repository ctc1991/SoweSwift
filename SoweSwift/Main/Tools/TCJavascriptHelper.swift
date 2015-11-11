//
//  TCJavascriptHelper.swift
//  SoweSwift
//
//  Created by 程天聪 on 15/11/11.
//  Copyright © 2015年 CTC. All rights reserved.
//

import UIKit
import WebKit

class TCJavascriptHelper: NSObject {
    var webView: WKWebView?
    func hideJsClass(className: String) {
//        NSInteger index = [[self runJsCode:[NSString stringWithFormat:@"document.getElementsByClassName('%@').length",className]] integerValue];
//        for (NSInteger i=0; i<index; i++) {
//            [self runJsCode:[NSString stringWithFormat:@"document.getElementsByClassName('%@')[%@].style.display='none'",className,@(i)]];
//        }
        for index in 1...100 {
            runJsCode("document.getElementsByClassName('\(index)')[\(className)].style.display='none'")
//            print(index)
        }
    }
    
    func runJsCode(code: String) {
        webView?.evaluateJavaScript(code, completionHandler: nil)
    }
}
