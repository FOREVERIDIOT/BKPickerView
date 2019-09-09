//
//  BKPickerView.h
//  BKPickerView
//
//  Created by zhaolin on 2019/1/23.
//  Copyright © 2019年 BIKE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

//! Project version number for BKPickerView.
FOUNDATION_EXPORT double BKPickerViewVersionNumber;

//! Project version string for BKPickerView.
FOUNDATION_EXPORT const unsigned char BKPickerViewVersionString[];

//普通格式
typedef NS_ENUM(NSUInteger, BKPickerStyle) {
    BKPickerStyleSingle,                //单选
    BKPickerStyleMultilevelLinkage      //多级联动
};

//时间格式
typedef NS_OPTIONS(NSUInteger, BKPickerDateStyle) {
    BKPickerDateStyleDisplayYear = 1 << 0,          //显示年
    BKPickerDateStyleDisplayMonth = 1 << 1,         //显示月
    BKPickerDateStyleDisplayDay = 1 << 2,           //显示日
    BKPickerDateStyleDisplayHour = 1 << 3,          //显示时
    BKPickerDateStyleDisplayMinute = 1 << 4,        //显示分
    BKPickerDateStyleDisplaySecond = 1 << 5,        //显示秒
};

NS_ASSUME_NONNULL_BEGIN

@interface BKPickerView : UIView

#pragma mark - 普通格式

/**
 创建方法(普通格式)
 
 @param dataArr 数据
 当传一维数组时 例子@[@"",@"",@""] BKPickerStyle == BKPickerStyleSingle
 当传二维数组时 例子@[@[@"",@"",@""], @[@"",@"",@""], @[@"",@"",@""]] BKPickerStyle == BKPickerStyleMultilevelLinkage
 @param remind 选取器提示
 @return 选取器
 */
-(instancetype)initWithPickerDataArr:(NSArray*)dataArr remind:(NSString*)remind;

/**
 显示数据
 */
@property (nonatomic,copy,readonly) NSArray * dataArr;

#pragma mark - 普通格式 - BKPickerStyleSingle

/**
 当前选取索引
 当BKPickerStyle == BKPickerStyleSingle时有效
 */
@property (nonatomic,assign) NSInteger selectIndex;
/**
 完成选择返回索引回调
 当BKPickerStyle == BKPickerStyleSingle时有效
 */
@property (nonatomic,copy) void (^confirmSelectCallback)(NSInteger selectIndex);

#pragma mark - 普通格式 - BKPickerStyleMultilevelLinkage

/**
 当前选取索引数组 传一维数组 例子@[@(),@(),@()]
 当BKPickerStyle == BKPickerStyleMultilevelLinkage时有效
 */
@property (nonatomic,copy) NSArray<NSNumber*> * selectIndexArr;
/**
 切换选择返回索引数组回调 用于修改数据源 返回一维数组 例子@[@(),@(),@()]
 提示 修改了当前滑动component的index 大于当前component后的index置为0
 当BKPickerStyle == BKPickerStyleMultilevelLinkage时有效
 */
@property (nonatomic,copy) NSArray * (^changeSelectIndexsCallback)(BKPickerView * pickerView, NSArray<NSNumber*> * selectIndexArr);
/**
 完成选择返回索引数组回调 返回一维数组 例子@[@(),@(),@()]
 当BKPickerStyle == BKPickerStyleMultilevelLinkage时有效
 */
@property (nonatomic,copy) void (^confirmSelectIndexsCallback)(NSArray<NSNumber*> * selectIndexArr);

#pragma mark - 时间格式

/**
 创建方法(时间格式)
 
 @param pickerDateStyle 选取器格式
 @param selectDate 当前选取日期
 @param maxDate 最大日期
 @param minDate 最小日期
 @param remind 选取器提示
 @return 选取器
 */
-(instancetype)initWithPickerDateStyle:(BKPickerDateStyle)pickerDateStyle selectDate:(nullable NSDate *)selectDate maxDate:(nullable NSDate *)maxDate minDate:(nullable NSDate *)minDate remind:(nonnull NSString *)remind;

/**
 确认选取时间返回
 */
@property (nonatomic,copy) void (^confirmSelectDateCallback)(NSDate * date);

#pragma mark - 显示方法

/**
 显示方法
 */
-(void)show;

@end

NS_ASSUME_NONNULL_END
