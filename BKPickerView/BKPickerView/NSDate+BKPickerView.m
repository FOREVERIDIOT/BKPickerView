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
static NSDateFormatter * _dateFormatter = nil;

#pragma mark - 日历/日期格式创建

+(NSCalendar*)calendar
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    });
    return _calendar;
}

+(NSDateFormatter*)dateFormatter
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _dateFormatter = [[NSDateFormatter alloc] init];
    });
    return _dateFormatter;
}

/**
 转化成年份
 
 @return 年份
 */
-(NSUInteger)bk_transformYear
{
    [NSDate dateFormatter].dateFormat = @"Y";
    return [[[NSDate dateFormatter] stringFromDate:self] integerValue];
}

/**
 转化成月份
 
 @return 月份
 */
-(NSUInteger)bk_transformMonth
{
    [NSDate dateFormatter].dateFormat = @"M";
    return [[[NSDate dateFormatter] stringFromDate:self] integerValue];
}

/**
 转化成天
 
 @return 天
 */
-(NSUInteger)bk_transformDay
{
    [NSDate dateFormatter].dateFormat = @"d";
    return [[[NSDate dateFormatter] stringFromDate:self] integerValue];
}

/**
 转化成时
 
 @return 时
 */
-(NSUInteger)bk_transformHour
{
    [NSDate dateFormatter].dateFormat = @"H";
    return [[[NSDate dateFormatter] stringFromDate:self] integerValue];
}

/**
 转化成分
 
 @returnf 分
 */
-(NSUInteger)bk_transformMinute
{
    [NSDate dateFormatter].dateFormat = @"m";
    return [[[NSDate dateFormatter] stringFromDate:self] integerValue];
}

/**
 转化成秒
 
 @return 秒
 */
-(NSUInteger)bk_transformSecond
{
    [NSDate dateFormatter].dateFormat = @"s";
    return [[[NSDate dateFormatter] stringFromDate:self] integerValue];
}

@end
