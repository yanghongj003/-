//
//  Question.h
//  猜图
//
//  Created by zpon on 15-4-4.
//  Copyright (c) 2015年 zpon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Question : NSObject

@property(nonatomic,copy)NSString *answer;
@property(nonatomic,copy)NSString *icon;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,strong)NSArray *options;

- (instancetype)initWithDic:(NSDictionary *)dic;
+ (instancetype)questionWithDic:(NSDictionary *)dic;
@end
