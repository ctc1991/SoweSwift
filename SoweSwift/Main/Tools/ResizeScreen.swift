//
//  ResizeScreen.swift
//  SoweSwift
//
//  Created by 程天聪 on 15/11/10.
//  Copyright © 2015年 CTC. All rights reserved.
//

import UIKit

let RATIO: CGFloat = 120/568.0

class ResizeScreen: NSObject {
    class func offsetY() -> CGFloat {
        var y : CGFloat = 0
        if (self.isIphone4orLess()) {
            y = 100
        } else if (self.isIphone5()) {
            y = 120
        } else if (self.isIphone6()) {
            y = 667*RATIO
        } else if (self.isIphone6p()) {
            y = 736*RATIO
        }
        return y
    }
    
    class func cellFontSize() -> CGFloat {
        var y : CGFloat = 0
        if (self.isIphone4orLess()) {
            y = 19
        } else if (self.isIphone5()) {
            y = 19;
        } else if (self.isIphone6()) {
            y = 23
        } else if (self.isIphone6p()) {
            y = 26
        }
        return y
    }
    
    class func searchFontSize() -> CGFloat {
        var y : CGFloat = 0
        if (self.isIphone4orLess()) {
            y = 27
        } else if (self.isIphone5()) {
            y = 27;
        } else if (self.isIphone6()) {
            y = 32
        } else if (self.isIphone6p()) {
            y = 35
        }
        return y
    }
    
    class func botFontSize() -> CGFloat {
        var y : CGFloat = 0
        if (self.isIphone4orLess()) {
            y = 30
        } else if (self.isIphone5()) {
            y = 30;
        } else if (self.isIphone6()) {
            y = 35
        } else if (self.isIphone6p()) {
            y = 40
        }
        return y
    }
    
    class func isIphone4orLess() -> Bool {
        return self.maxLenthOfScreen() <= 480 ? true : false
    }
    
    class func isIphone5() -> Bool {
        return self.maxLenthOfScreen() == 568 ? true : false
    }
    
    class func isIphone6() -> Bool {
        return self.maxLenthOfScreen() == 667 ? true : false
    }
    
    class func isIphone6p() -> Bool {
        return self.maxLenthOfScreen() == 736 ? true : false
    }
    
    class func maxLenthOfScreen() -> CGFloat {
        let width : CGFloat  = UIScreen.mainScreen().bounds.size.width
        let height : CGFloat  = UIScreen.mainScreen().bounds.size.height
        return width > height ? width : height
    }
}
