//
//  NSDate+BKPickerView.m
//  BKPickerView
//
//  Created by zhaolin on 2019/3/19.
//  Copyright © 2019年 BIKE. All rights reserved.
//

#import "NSDate+BKPickerView.h"

@implementation NSDate (BKPickerView)

static NSCalendar * _calendar = nil;

#pragma mark - 日历/日期格式创建

+(NSCalendar*)calendar
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    });
    return _calendar;
}

/**
 转化成年份
 
 @return 年份
 */
-(NSUInteger)bk_transformYear
{
    return [[NSDate calendar] component:NSCalendarUnitYear fromDate:self];
}

/**
 转化成月份
 
 @return 月份
 */
-(NSUInteger)bk_transformMonth
{
    return [[NSDate calendar] component:NSCalendarUnitMonth fromDate:self];
}

/**
 转化成天
 
 @return 天
 */
-(NSUInteger)bk_transformDay
{
    return [[NSDate calendar] component:NSCalendarUnitDay fromDate:self];
}

/**
 转化成时
 
 @return 时
 */
-(NSUInteger)bk_transformHour
{
    return [[NSDate calendar] component:NSCalendarUnitHour fromDate:self];
}

/**
 转化成分
 
 @returnf 分
 */
-(NSUInteger)bk_transformMinute
{
    return [[NSDate calendar] component:NSCalendarUnitMinute fromDate:self];
}

/**
 转化成秒
 
 @return 秒
 */
-(NSUInteger)bk_transformSecond
{
    return [[NSDate calendar] component:NSCalendarUnitSecond fromDate:self];
}

@end
