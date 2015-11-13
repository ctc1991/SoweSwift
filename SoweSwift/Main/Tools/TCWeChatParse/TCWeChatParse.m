//
//  TCWeChatParse.m
//  sowe
//
//  Created by 程天聪 on 15/8/28.
//  Copyright (c) 2015年 CTC. All rights reserved.
//

#import "TCWeChatParse.h"
//#import <MobClick.h>
#import <AVOSCloud.h>

@implementation TCWeChatParse


+ (void)articleModelsWithKeyword:(NSString *)keyword
                            page:(NSInteger)page
                         Success:(void (^)(NSMutableArray *))success
                         failure:(void (^)(NSString *, NSError *))failure {
    [SVProgressHUD show];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *urlString = [NSString stringWithFormat:@"http://weixin.sogou.com/weixinwap?type=2&query=%@&page=%@&ie=utf8",keyword,[NSNumber numberWithInteger:page]];
        NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSError *error;
        NSString *datastring = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
        if (!error) {
            NSLog(@"本次请求的网址:%@",url);
            NSArray *array = [self arrayWithDataString:datastring];
            NSMutableArray *modelArray = [NSMutableArray array];
            for (NSString *str in array) {
                TCWeChatArticleModel *model = [TCWeChatArticleModel weChatArticleModelWithDataString:str];
                [modelArray addObject:model];
            }
            dispatch_sync(dispatch_get_main_queue(), ^{
//                [MobClick event:@"RequestToWechatSearch"];
                success(modelArray);
                [SVProgressHUD dismiss];
            });
        } else {
            dispatch_sync(dispatch_get_main_queue(), ^{
                if (failure) {
                    failure(urlString,error);
                }
                [SVProgressHUD dismiss];
            });
        }
    });
}

+ (void)articleModelsWithUrlString:(NSString *)urlString
                           Success:(void (^)(NSMutableArray *array))success
                           failure:(void (^)(NSString *urlString, NSError *error))failure {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *url = [NSURL URLWithString:urlString];
        NSError *error;
        NSString *datastring = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
        if (!error) {
            NSArray *array = [self arrayWithDataString:datastring];
            NSMutableArray *modelArray = [NSMutableArray array];
            for (NSString *str in array) {
                TCWeChatArticleModel *model = [TCWeChatArticleModel weChatArticleModelWithDataString:str];
                [modelArray addObject:model];
            }
            dispatch_sync(dispatch_get_main_queue(), ^{
                success(modelArray);
            });
        } else {
            dispatch_sync(dispatch_get_main_queue(), ^{
                if (failure) {
                    failure(urlString,error);
                }
            });
        }
    });
}

+ (NSArray *)articleModelsWithUrlString:(NSString *)urlString {
        NSURL *url = [NSURL URLWithString:urlString];
        NSError *error;
        NSString *datastring = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
        if (!error) {
            NSArray *array = [self arrayWithDataString:datastring];
            NSMutableArray *modelArray = [NSMutableArray array];
            for (NSString *str in array) {
                TCWeChatArticleModel *model = [TCWeChatArticleModel weChatArticleModelWithDataString:str];
                [modelArray addObject:model];
            }
            return modelArray;
        } else {
            return [[NSMutableArray array] copy];
        }

}

/**返回一个字符串数组*/
+ (NSArray *)arrayWithDataString:(NSString *)dataString {
    NSMutableArray *a1 = [NSMutableArray array];
    a1 = [[dataString componentsSeparatedByString:@"<!-- a -->"] mutableCopy];
    NSMutableArray *a2 = [NSMutableArray array];
    for (NSInteger index=1; index<a1.count; index++) {
        NSString *str = a1[index];
        NSString *str2 = (NSString *)[[str componentsSeparatedByString:@"<!-- z -->"] firstObject];
        [a2 addObject:str2];
    }
    return a2;
}


+ (void)saveModelInLeanCloud:(TCWeChatArticleModel *)model {
    AVQuery *query = [AVQuery queryWithClassName:@"TCWeChatArticle"];
    [query whereKey:@"articleUrl" equalTo:model.articleUrlString];
    [query getFirstObjectInBackgroundWithBlock:^(AVObject *object, NSError *error) {
        if (!object && [model.articleUrlString hasPrefix:@"http://mp.weixin.qq.com"]) {
            AVObject *post = [AVObject objectWithClassName:@"TCWeChatArticle"];
            post[@"articleUrl"] = model.articleUrlString;
            post[@"imageUrl"] = model.imageUrlString;
            post[@"nickname"] = model.nickname;
            post[@"title"] = model.title;
            post[@"second"] = @(model.second);
            [post saveInBackground];
        } else {
            return ;
        }
    }];
}

+ (void)checkAllArticleWithNickname:(NSString *)nickname
                            account:(NSString *)account
                            success:(void (^)(NSURL *url))success
                            failure:(void (^)(NSURL *))failure {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSInteger page = 1;
        NSString *newUrlString = nil;
        NSURL *url = nil;
         NSError *error = nil;
        do {
            NSString *urlString = [NSString stringWithFormat:@"http://weixin.sogou.com/weixinwap?query=%@&page=%@",nickname,@(page++)];
            url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            NSString *datastring = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
            NSLog(@"%@",error);
            NSMutableArray *a1 = [NSMutableArray array];
            a1 = [[datastring componentsSeparatedByString:@"<!-- a -->"] mutableCopy];
            [a1 removeObjectAtIndex:0];
            NSMutableArray *a2 = [NSMutableArray array];
            for (NSString *str in a1) {
                NSString *str2 = (NSString *)[[str componentsSeparatedByString:@"<!-- z -->"] firstObject];
                [a2 addObject:str2];
            }
            //微信号
            for (NSString *str  in a2) {
                //微信号
                NSString *account2 = [TCWeChatArticleModel stringFromLeadingString:@"<dt>微信号：</dt>\n<dd class=\"lst_wechat_txt\">" tailingString:@"&nbsp;</dd>" forString:str];
                //openid
                NSString *openId = [TCWeChatArticleModel stringFromLeadingString:@"openid=" tailingString:@"\" class=\"account_box\"" forString:str];
                
                if ([account2 isEqualToString:account]) {
                    newUrlString = [NSString stringWithFormat:@"http://weixin.sogou.com/gzhwap?openid=%@",openId];
                    NSLog(@"匹配成功：%@",newUrlString);
                    break;
                }
            }
            
        } while (newUrlString==nil && error==nil);
                dispatch_sync(dispatch_get_main_queue(), ^{
                    if (!error) {
                        success([NSURL  URLWithString:newUrlString]);
                    } else {
                        failure(url);
                    }
        });
    });
}

+ (BOOL)hasSearchResultWithSearchUrlString:(NSString *)searchUrlString {
    NSURL *url = [NSURL URLWithString:[searchUrlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSString *datastring = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    if ([datastring rangeOfString:@"我们可以帮他找到亲人"].location != NSNotFound) return NO;
    else return YES;
}
@end

@implementation TCWeChatArticleModel

+ (TCWeChatArticleModel *)weChatArticleModelWithDataString:(NSString *)dataString {
    TCWeChatArticleModel *model = [[TCWeChatArticleModel alloc] init];
    model.articleUrlString = [self stringFromLeadingString:@"<a class=\"news_lst_tab2\" href=\"" tailingString:@"\" uigs_exp_id" forString:dataString];
    if ([model.articleUrlString hasPrefix:@"/websearch/art.jsp?"]) {
        
        model.articleUrlString = [@"http://weixin.sogou.com" stringByAppendingString:model.articleUrlString];
        
        model.imageUrlString = [self stringFromLeadingString:@"url=" tailingString:@"\"></div>\n" forString:[self stringFromLeadingString:@"this.parentNode" tailingString:@"<div class=\"news_txt_box2\">" forString:dataString]];
    } else {
        model.imageUrlString = [self stringFromLeadingString:@"url=" tailingString:@"\"></div>\n<div class=\"news_txt_box2\">" forString:dataString];
    }
    
    model.title = [self htmlEntityDecode:[self stringFromLeadingString:@"40px\">" tailingString:@"</p>\n<p class=\"news_lst_txt3\" style=\"display:none;\">" forString:dataString]];
    // 有些公众号文章标题本身有问题 二次转义优化搜索列表的显示
    model.title = [self htmlEntityDecode:model.title];
    model.nickname = [self htmlEntityDecode:[self stringFromLeadingString:@"title=\"" tailingString:@"\" i=\"" forString:dataString]];
    model.second = (NSTimeInterval)[[self stringFromLeadingString:@"\" t=\"" tailingString:@"\">\n<span target=\"" forString:dataString] integerValue];
//    [TCWeChatParse saveModelInLeanCloud:model];
    return model;
}

/**
 *  截取字符串
 *
 *  @param leading 前
 *  @param tailing 后
 *  @param string  整个字符串
 */
+ (NSString *)stringFromLeadingString:(NSString *)leading
                        tailingString:(NSString *)tailing
                            forString:(NSString *)string {
    NSString *str = [[string componentsSeparatedByString:leading] objectAtIndex:1];
    return [[str componentsSeparatedByString:tailing] firstObject];
    
}
/**HTML转义*/
+ (NSString *)htmlEntityDecode:(NSString *)string {
    // HTML
    string = [string stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    string = [string stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"];
    string = [string stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    string = [string stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    string = [string stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    string = [string stringByReplacingOccurrencesOfString:@"&mdash;" withString:@"—"];
    string = [string stringByReplacingOccurrencesOfString:@"&ldquo;" withString:@"“"];
    string = [string stringByReplacingOccurrencesOfString:@"&rdquo;" withString:@"”"];
    string = [string stringByReplacingOccurrencesOfString:@"&deg;" withString:@"°"];
    string = [string stringByReplacingOccurrencesOfString:@"&bull;" withString:@"•"];
    string = [string stringByReplacingOccurrencesOfString:@"&middot;" withString:@"·"];
    string = [string stringByReplacingOccurrencesOfString:@"&hellip;" withString:@"…"];
    string = [string stringByReplacingOccurrencesOfString:@"&cap;" withString:@"∩"];
    string = [string stringByReplacingOccurrencesOfString:@"&nbsp;&nbsp;" withString:@" | "];
    string = [string stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    // 因搜索的红字关键字
    string = [string stringByReplacingOccurrencesOfString:@"<em>" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"</em>" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"<!--red_beg-->" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"<!--red_end-->" withString:@""];
    
    return string;
}






@end

@implementation TCWeChatArticleModelWithArticle
+ (void)weChatArticleModelWithArticleUrlString:(NSString *)urlString
                                       Success:(void (^)(TCWeChatArticleModelWithArticle *model))success {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSString *datastring = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
        TCWeChatArticleModelWithArticle *model = [[TCWeChatArticleModelWithArticle alloc] init];
        model.postDate = [TCWeChatArticleModel stringFromLeadingString:@"<em id=\"post-date\" class=\"rich_media_meta rich_media_meta_text\">" tailingString:@"</em>" forString:datastring];
        model.postUser = [TCWeChatArticleModel stringFromLeadingString:@"_meta_nickname\">" tailingString:@"</span>" forString:datastring];
        model.articleUrlString = urlString;
        model.title = [TCWeChatArticleModel stringFromLeadingString:@"<h2 class=\"rich_media_title\">" tailingString:@"</h2>" forString:datastring];
//        model.account = [TCWeChatArticleModel stringFromLeadingString:@">微信号</label>\n<span class=\"profile_meta_value\">" tailingString:@"</span>" forString:datastring];
        dispatch_sync(dispatch_get_main_queue(), ^{
            success(model);
        });
    });
}

@end