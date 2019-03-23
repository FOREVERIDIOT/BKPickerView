//
//  BKPickerSelectDateTools.m
//  BKPickerView
//
//  Created by zhaolin on 2019/3/22.
//  Copyright © 2019年 BIKE. All rights reserved.
//

#import "BKPickerSelectDateTools.h"
#import "NSDate+BKPickerView.h"

@implementation BKPickerSelectDateTools

/**
 切换选中日期
 
 @param date 选中日期
 */
-(void)changeSelectDate:(NSDate*)date
{
    if (date) {
        self.selectYear = [date bk_transformYear];
        self.selectMonth = [date bk_transformMonth];
        self.selectDay = [date bk_transformDay];
        self.selectHour = [date bk_transformHour];
        self.selectMinute = [date bk_transformMinute];
        self.selectSecond = [date bk_transformSecond];
    }else {
        self.selectYear = 1;
        self.selectMonth = 1;
        self.selectDay = 1;
        self.selectHour = 0;
        self.selectMinute = 0;
        self.selectSecond = 0;
    }
}

-(void)setSelectYear:(NSUInteger)selectYear
{
    _selectYear = selectYear;
}

-(void)setSelectMonth:(NSUInteger)selectMonth
{
    _selectMonth = selectMonth;
}

-(void)setSelectDay:(NSUInteger)selectDay
{
    _selectDay = selectDay;
}

-(void)setSelectHour:(NSUInteger)selectHour
{
    _selectHour = selectHour;
}

-(void)setSelectMinute:(NSUInteger)selectMinute
{
    _selectMinute = selectMinute;
}

-(void)setSelectSecond:(NSUInteger)selectSecond
{
    _selectSecond = selectSecond;
}

@end
