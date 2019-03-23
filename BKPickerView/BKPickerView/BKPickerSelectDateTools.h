//
//  BKPickerSelectDateTools.h
//  BKPickerView
//
//  Created by zhaolin on 2019/3/22.
//  Copyright © 2019年 BIKE. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BKPickerSelectDateTools : NSObject

/**
 切换选中日期

 @param date 选中日期
 */
-(void)changeSelectDate:(NSDate*)date;

/**
 年
 */
@property (nonatomic,assign,readonly) NSUInteger selectYear;
/**
 月
 */
@property (nonatomic,assign,readonly) NSUInteger selectMonth;
/**
 日
 */
@property (nonatomic,assign,readonly) NSUInteger selectDay;
/**
 时
 */
@property (nonatomic,assign,readonly) NSUInteger selectHour;
/**
 分
 */
@property (nonatomic,assign,readonly) NSUInteger selectMinute;
/**
 秒
 */
@property (nonatomic,assign,readonly) NSUInteger selectSecond;

@end

NS_ASSUME_NONNULL_END
