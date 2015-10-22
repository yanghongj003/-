//
//  Question.m
//  猜图
//
//  Created by zpon on 15-4-4.
//  Copyright (c) 2015年 zpon. All rights reserved.
//

#import "Question.h"

@implementation Question

- (instancetype)initWithDic:(NSDictionary *)dic
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

+ (instancetype)questionWithDic:(NSDictionary *)dic
{
    return [[self alloc]initWithDic:dic];
}
@end
