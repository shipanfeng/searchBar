//
//  CityListModel.m
//  91cheliu
//
//  Created by shipanfeng001 on 15/10/19.
//  Copyright (c) 2015年 91cheliu. All rights reserved.
//

#import "CityListModel.h"

@implementation CityListModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{}


+ (CityListModel *)modelWithDic:(NSDictionary *)dic{
    return [[self alloc]initWithDic:dic];
}

- (id)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}
@end
