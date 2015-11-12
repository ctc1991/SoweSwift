//
//  HomeCell.swift
//  SoweSwift
//
//  Created by 程天聪 on 15/11/12.
//  Copyright © 2015年 CTC. All rights reserved.
//

import UIKit

class HomeCell: UICollectionViewCell {
    var textLabel: UILabel?
    func initSelf() {
        if (textLabel == nil) {
            textLabel = UILabel(frame: bounds)
            textLabel?.textAlignment = NSTextAlignment.Center
            textLabel?.font = UIFont.systemFontOfSize(ResizeScreen.cellFontSize())
            addSubview(textLabel!)
        }
    }
}
