//
//  UIView+BKPickerView.h
//  BKPickerView
//
//  Created by zhaolin on 2019/1/23.
//  Copyright © 2019年 BIKE. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (BKPickerView)

/**
 x
 */
@property (nonatomic,assign) CGFloat bk_x;
/**
 y
 */
@property (nonatomic,assign) CGFloat bk_y;
/**
 width
 */
@property (nonatomic,assign) CGFloat bk_width;
/**
 height
 */
@property (nonatomic,assign) CGFloat bk_height;
/**
 centerX
 */
@property (nonatomic,assign) CGFloat bk_centerX;
/**
 centerY
 */
@property (nonatomic,assign) CGFloat bk_centerY;

@end

NS_ASSUME_NONNULL_END
