//
//  TCProgressView.h
//  TCPopupViewDemo
//
//  Created by 程天聪 on 15/9/22.
//  Copyright © 2015年 CTC. All rights reserved.
//

#import <UIKit/UIKit.h>

// 获得RGB颜色
#define TCM_Color(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define TCM_ColorAlpha(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

typedef NS_ENUM(NSInteger, TCProgressViewPosition) {
    TCProgressViewPositionScreen,
    TCProgressViewPositionStatusBar,
    TCProgressViewPositionNavigationBar,
    TCProgressViewPositionStatusBarAndNavigationBar
};

@interface TCProgressView : UIView
+ (void)show;
+ (void)dismiss;
+ (void)setPosition:(TCProgressViewPosition)position;
+ (void)setHeight:(CGFloat)height;
@end
