//
//  TCAppUtils.h
//
//  Created by 程天聪 on 15/7/8.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TCAppUtils : NSObject

/**阴影添加*/
+ (void)shadowForView:(UIView *)view;

/**
 *  使视图水平居中
 *
 *  @param view      需要居中的视图
 *  @param container 居中视图所处的容器
 *
 *  @return 移动的水平距离
 */
+ (CGFloat)makeView:(UIView *)view HorizontalCenterInContainer:(UIView *)container;

/**圆角半径*/
+ (void)cornerRadius:(CGFloat)cornerRadius ForView:(UIView *)view;

/**
 *  描边
 *
 *  @param borderWidth 线宽
 *  @param borderColor 线色
 *  @param view        需要描边的视图
 */
+ (void)borderWidth:(CGFloat)borderWidth
        borderColor:(UIColor *)borderColor
            ForView:(UIView *)view;

/**
 *  截图
 *
 *  @param view 需要截图的视图
 *
 *  @return 返回一张截图
 */
+ (UIImage *)screenshotForView:(UIView *)view;

/**图片保存于系统相册*/
+ (void)saveImageInSystemAlbumWithImage:(UIImage *)image
                       completionTarget:(id)completionTarget
                     completionSelector:(SEL)completionSelector
                            contextInfo:(void *)contextInfo;

/**返回最右X*/
+ (CGFloat)xOfRightByFrame:(CGRect)frame;

/**返回最下Y*/
+ (CGFloat)yOfBottomByFrame:(CGRect)frame;

/**
 *  颜色形成图
 *
 *  @param color 颜色
 *  @param size  图片大小
 *
 *  @return 图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

/**给textField加左图标*/
+ (void)addLeftViewForTextViewWithImageName:(NSString *)imageName
                               forTextField:(UITextField *)textField;


/**给textField加右图标*/
+ (void)addRightViewForTextViewWithImageName:(NSString *)imageName
                                forTextField:(UITextField *)textField;

/**设置textField 缺省*/
+ (void)textFieldPlaceholderWithString:(NSString *)string color:(UIColor *)color forTextField:(UITextField *)textField;

@end
