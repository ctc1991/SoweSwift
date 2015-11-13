//
//  TCWeChatParse.h
//  sowe
//
//  Created by 程天聪 on 15/8/28.
//  Copyright (c) 2015年 CTC. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TCWeChatArticleModel;
@class TCWeChatParse;

@protocol TCWeChatParseDelegate <NSObject>

- (void)weChatParseDidFailed;

@end

@interface TCWeChatParse : NSObject
@property (weak, nonatomic) id<TCWeChatParseDelegate>delegate;
/**
 *  获得一页文章
 *
 *  @param keyword    关键词
 *  @param page       页数
 *  @param completion 对请求回来的数组进行处理
 */
+ (void)articleModelsWithKeyword:(NSString *)keyword
                            page:(NSInteger)page
                         Success:(void (^)(NSMutableArray *array))success
                         failure:(void (^)(NSString *urlString, NSError *error))failure;
+ (void)articleModelsWithUrlString:(NSString *)urlString
                           Success:(void (^)(NSMutableArray *array))success
                           failure:(void (^)(NSString *urlString, NSError *error))failure;
+ (NSArray *)articleModelsWithUrlString:(NSString *)urlString;

+ (void)checkAllArticleWithNickname:(NSString *)nickname
                            account:(NSString *)account
                            success:(void (^)(NSURL *url))success
                            failure:(void (^)(NSURL *url))failure;
+ (BOOL)hasSearchResultWithSearchUrlString:(NSString *)searchUrlString;

@end


@interface TCWeChatArticleModel : NSObject
/**正文地址*/
@property (copy, nonatomic) NSString *articleUrlString;
/**图片地址*/
@property (copy, nonatomic) NSString *imageUrlString;
/**标题*/
@property (copy, nonatomic) NSString *title;
/**公众号昵称*/
@property (copy, nonatomic) NSString *nickname;
/**发布时间秒数*/
@property (nonatomic) NSTimeInterval second;


+ (TCWeChatArticleModel *)weChatArticleModelWithDataString:(NSString *)dataString;
+ (NSString *)htmlEntityDecode:(NSString *)string;
+ (NSString *)stringFromLeadingString:(NSString *)leading
                        tailingString:(NSString *)tailing
                            forString:(NSString *)string;
@end


@interface TCWeChatArticleModelWithArticle : NSObject
@property (copy, nonatomic) NSString *postDate;
@property (copy, nonatomic) NSString *postUser;
@property (copy, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *account;
@property (copy, nonatomic) NSString *articleUrlString;
+ (void)weChatArticleModelWithArticleUrlString:(NSString *)urlString
                                       Success:(void (^)(TCWeChatArticleModelWithArticle *model))success;
@end