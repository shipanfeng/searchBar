//
//  CityListModel.h
//  91cheliu
//
//  Created by shipanfeng001 on 15/10/19.
//  Copyright (c) 2015年 91cheliu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityListModel : NSObject

@property (copy,nonatomic) NSString *CityName;
@property (copy,nonatomic) NSString *CityID;
@property (copy,nonatomic) NSString *PinYin;
@property (copy,nonatomic) NSString *QuanPin;


+ (CityListModel *)modelWithDic:(NSDictionary *)dic;
- (id)initWithDic:(NSDictionary *)dic;

@end
