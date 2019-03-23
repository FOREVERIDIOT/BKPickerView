//
//  NSDate+BKPickerView.h
//  BKPickerView
//
//  Created by zhaolin on 2019/3/19.
//  Copyright © 2019年 BIKE. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (BKPickerView)

/**
 转化成年

 @return 年
 */
-(NSUInteger)bk_transformYear;

/**
 转化成月
 
 @return 月
 */
-(NSUInteger)bk_transformMonth;

/**
 转化成天
 
 @return 天
 */
-(NSUInteger)bk_transformDay;

/**
 转化成时
 
 @return 时
 */
-(NSUInteger)bk_transformHour;

/**
 转化成分
 
 @returnf 分
 */
-(NSUInteger)bk_transformMinute;

/**
 转化成秒
 
 @return 秒
 */
-(NSUInteger)bk_transformSecond;

@end

NS_ASSUME_NONNULL_END
