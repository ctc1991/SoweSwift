//
//  HomeCell.swift
//  SoweSwift
//
//  Created by 程天聪 on 15/11/12.
//  Copyright © 2015年 CTC. All rights reserved.
//

import UIKit

public protocol TapCellLabelDelegate : NSObjectProtocol {
     func tapCellLabel(didSelectLabel selectIndex: Int)
}

class TapCellLabel: UITapGestureRecognizer {
    var flag: Int?
    weak  var tapDelegate: TapCellLabelDelegate?
}

class HomeCell: UICollectionViewCell {
    var textLabel: UILabel?
    var tapCellLabel: TapCellLabel?
    func initSelf() {
        if (textLabel == nil) {
            textLabel = UILabel(frame: bounds)
            textLabel?.textAlignment = NSTextAlignment.Center
            textLabel?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
            textLabel?.textColor = UIColor.whiteColor()
            addSubview(textLabel!)
            textLabel?.userInteractionEnabled = true
            tapCellLabel = TapCellLabel(target: self, action: "tapTextLabel:")
            tapCellLabel!.flag = tag
            textLabel?.addGestureRecognizer(tapCellLabel!)
        }
    }
    
     func tapTextLabel(sender: TapCellLabel) {
        sender.tapDelegate?.tapCellLabel(didSelectLabel: sender.flag!)
    }
}
