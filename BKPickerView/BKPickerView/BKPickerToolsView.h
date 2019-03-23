//
//  BKPickerToolsView.h
//  BKPickerView
//
//  Created by zhaolin on 2019/1/24.
//  Copyright © 2019年 BIKE. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BKPickerToolsView : UIView

@property (nonatomic,copy) NSString * remind;

@property (nonatomic,copy) void (^clickCancelBtnCallBack)(void);
@property (nonatomic,copy) void (^clickConfirmBtnCallBack)(void);

@end

NS_ASSUME_NONNULL_END
