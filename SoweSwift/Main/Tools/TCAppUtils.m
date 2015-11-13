//
//  TCAppUtils.m
//
//  Created by 程天聪 on 15/7/8.
//

#import "TCAppUtils.h"

@implementation TCAppUtils

+ (void)shadowForView:(UIView *)view {
    view.layer.masksToBounds = NO;
    view.layer.shadowOpacity = 0.75;
    view.layer.shadowRadius = 5.0;
    view.layer.shadowOffset = CGSizeMake(0,0);
}

+ (CGFloat)makeView:(UIView *)view HorizontalCenterInContainer:(UIView *)container {
    CGFloat xChanged;
    CGPoint center = view.center;
    xChanged = view.center.x - center.x;
    center.x = container.center.x;
    view.center = center;
    return xChanged;
}

+ (void)cornerRadius:(CGFloat)cornerRadius
             ForView:(UIView *)view {
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = cornerRadius;
}

+ (void)borderWidth:(CGFloat)borderWidth
        borderColor:(UIColor *)borderColor
            ForView:(UIView *)view {
    view.layer.borderColor = borderColor.CGColor;
    view.layer.borderWidth = borderWidth;
}

+ (UIImage *)screenshotForView:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (void)saveImageInSystemAlbumWithImage:(UIImage *)image completionTarget:(id)completionTarget completionSelector:(SEL)completionSelector contextInfo:(void *)contextInfo {
    UIImageWriteToSavedPhotosAlbum(image,completionTarget, completionSelector, contextInfo);
}

+ (CGFloat)xOfRightByFrame:(CGRect)frame {
    return (frame.origin.x + frame.size.width);
}

+ (CGFloat)yOfBottomByFrame:(CGRect)frame {
    return (frame.origin.y + frame.size.height);
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

+ (void)addLeftViewForTextViewWithImageName:(NSString *)imageName
                               forTextField:(UITextField *)textField {
    UIImageView *iv=[[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    UIView *leftView = [[UIView alloc] init];
    leftView.frame = CGRectMake(10, 0, 30, 15);
    CGRect frame = iv.frame;
    frame.origin.x += 10;
    iv.frame = frame;
    [leftView addSubview:iv];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.leftView = leftView;
}

+ (void)addRightViewForTextViewWithImageName:(NSString *)imageName
                                forTextField:(UITextField *)textField{
    UIImageView *iv=[[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    UIView *rightView = [[UIView alloc] init];
    rightView.frame = CGRectMake(-100, 0, 40, 40);
    CGRect frame = iv.frame;
    frame.origin.x += 10;
    iv.frame = frame;
    [rightView addSubview:iv];
    textField.rightViewMode = UITextFieldViewModeAlways;
    textField.rightView = rightView;
}

+ (void)textFieldPlaceholderWithString:(NSString *)string color:(UIColor *)color forTextField:(UITextField *)textField {
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:string attributes:@{NSForegroundColorAttributeName: color}];
}


@end
