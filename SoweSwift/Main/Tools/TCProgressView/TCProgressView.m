//
//  TCProgressView.m
//  TCPopupViewDemo
//
//  Created by 程天聪 on 15/9/22.
//  Copyright © 2015年 CTC. All rights reserved.
//

#import "TCProgressView.h"
#define LOADING_MAX_LENGTH [UIScreen mainScreen].bounds.size.width
#define LOADING_PER_LENGTH (LOADING_MAX_LENGTH/100.0)
#define statusBarShowWhenLoading (![UIApplication sharedApplication].statusBarHidden)

@interface TCProgressView ()
@property (strong, nonatomic) NSTimer *timer;
@end

@implementation TCProgressView
+ (TCProgressView *)shareInstance {
    static TCProgressView *singleton = nil;
    static dispatch_once_t onceBlock;
    dispatch_once(&onceBlock, ^{
        singleton = [[TCProgressView alloc] init];
    });
    return singleton;
}

- (instancetype)init {
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, 0, 2);
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:self];
        self.backgroundColor = TCM_Color(4, 176, 15);
    }
    return self;
}

+ (void)show {
    [[TCProgressView shareInstance] show];
}
+ (void)dismiss {
    [[TCProgressView shareInstance] dismiss];
}
+ (void)setPosition:(TCProgressViewPosition)position {
    CGRect frame = [TCProgressView shareInstance].frame;
    switch (position) {
        case TCProgressViewPositionScreen:
            frame.origin.y = 0;
            break;
        case TCProgressViewPositionStatusBar:
            frame.origin.y = 20;
            break;
        case TCProgressViewPositionNavigationBar:
            frame.origin.y = 44;
            break;
        case TCProgressViewPositionStatusBarAndNavigationBar:
            frame.origin.y = 64;
            break;
    }
    [TCProgressView shareInstance].frame = frame;
}
+ (void)setHeight:(CGFloat)height {
    CGRect frame = [TCProgressView shareInstance].frame;
    frame.size.height = height;
    [TCProgressView shareInstance].frame = frame;
}
- (void)show {
    [_timer invalidate];
    [self setLength:0];
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(loading) userInfo:nil repeats:YES];
}
- (void)dismiss {
    [_timer invalidate];
    if (self.frame.size.width<LOADING_MAX_LENGTH) {
        [UIView animateWithDuration:0.35 animations:^{
            [self setLength:LOADING_MAX_LENGTH];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3 animations:^{
                self.alpha = 0;
            } completion:^(BOOL finished) {
                [self setLength:0];
                self.alpha = 1;
            }];
        }];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            [self setLength:0];
            self.alpha = 1;
        }];
    }
}

- (void)setLength:(CGFloat)length {
    CGRect frame = self.frame;
    frame.size.width=length;
    self.frame = frame;
}

- (void)loading {
    if (self.frame.size.width <= LOADING_MAX_LENGTH*0.6) {
        [UIView animateWithDuration:0.1 animations:^{
            [self setLength:self.frame.size.width+LOADING_PER_LENGTH*1.5];
        }];
    } else if (self.frame.size.width <= LOADING_MAX_LENGTH*0.75) {
        [UIView animateWithDuration:0.1 animations:^{
            [self setLength:self.frame.size.width+LOADING_PER_LENGTH*0.25];
        }];
    } else if (self.frame.size.width <= LOADING_MAX_LENGTH*0.93) {
        [UIView animateWithDuration:0.1 animations:^{
            [self setLength:self.frame.size.width+LOADING_PER_LENGTH*0.15];
        }];
    }
    if (self.frame.size.width >= LOADING_MAX_LENGTH) {
        [self dismiss];
    }
}

@end
