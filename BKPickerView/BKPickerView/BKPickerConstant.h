//
//  BKPickerConstant.h
//  BKPickerView
//
//  Created by zhaolin on 2019/1/24.
//  Copyright © 2019年 BIKE. All rights reserved.
//

#ifndef BKPickerConstant_h
#define BKPickerConstant_h

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#define BK_PICKER_HEX_RGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define BK_PICKER_BACKGROUND_COLOR BK_PICKER_HEX_RGB(0xD1D5DB)
#define BK_PICKER_TOOLBAR_COLOR BK_PICKER_HEX_RGB(0xF6F6F6)
#define BK_PICKER_TOOLBAR_BUTTON_TITLE_COLOR BK_PICKER_HEX_RGB(0x1E86FF)
#define BK_PICKER_TOOLBAR_REMIND_TITLE_COLOR BK_PICKER_HEX_RGB(0x999999)
#define BK_PICKER_CONTENT_TITLE_COLOR BK_PICKER_HEX_RGB(0x999999)
#define BK_PICKER_MAGNIFY_LINE_COLOR BK_PICKER_HEX_RGB(0xA8ABB0)
#define BK_PICKER_MAGNIFY_TITLE_COLOR BK_PICKER_HEX_RGB(0x333333)

#define BK_PICKER_POINTS_FROM_PIXELS(__PIXELS) (__PIXELS / [[UIScreen mainScreen] scale])
#define BK_PICKER_ONE_PIXEL BK_PICKER_POINTS_FROM_PIXELS(1.0)

#define BK_PICKER_WEAK_SELF(obj) __weak typeof(obj) weakSelf = obj;
#define BK_PICKER_STRONG_SELF(obj) __strong typeof(obj) strongSelf = weakSelf;

/**
 是否是iPhone X系列
 */
NS_INLINE CGFloat BKPicker_isIPhoneXSeries() {
    BOOL iPhoneXSeries = NO;
    if (UIDevice.currentDevice.userInterfaceIdiom != UIUserInterfaceIdiomPhone) {
        return iPhoneXSeries;
    }
    if (@available(iOS 11.0, *)) {
        UIWindow * window = [[[UIApplication sharedApplication] delegate] window];
        if (window.safeAreaInsets.bottom > 0.0) {
            iPhoneXSeries = YES;
        }
    }
    return iPhoneXSeries;
}

NS_INLINE CGFloat BKPicker_bottom_offset() {
    if (BKPicker_isIPhoneXSeries()) {
        return 83.f - 49.f;
    }
    return 0;
}

/**
 获取picker高度
 */
NS_INLINE CGFloat BKPicker_alertHeight() {
    CGFloat pickerHeight = 280 + BKPicker_bottom_offset();
    return pickerHeight;
}

UIKIT_EXTERN const float kPickerToolsViewHeight;
UIKIT_EXTERN const float kPickerToolsViewBtnTitleFontSize;
UIKIT_EXTERN const float kPickerToolsViewRemindTitleFontSize;
UIKIT_EXTERN const float kPickerContentTitleFontSize;
UIKIT_EXTERN const float kPickerContentRowHeight;

UIKIT_EXTERN const NSUInteger kBKDatePickerMaxRow;//时间格式最大行数

#endif
