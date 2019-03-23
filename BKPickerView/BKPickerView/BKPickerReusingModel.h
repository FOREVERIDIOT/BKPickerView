//
//  BKPickerReusingModel.h
//  BKPickerView
//
//  Created by zhaolin on 2019/3/20.
//  Copyright © 2019年 BIKE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - 复用view Model

@interface BKPickerReusingViewModel : NSObject

/**
 显示在的行 如果不显示为-1
 */
@property (nonatomic,assign) NSInteger row;
/**
 显示的view
 */
@property (nonatomic,strong,nullable) UILabel * titleLab;

@end

#pragma mark - 复用model

@interface BKPickerReusingModel : NSObject

/**
 可见的titleLab
 */
@property (nonatomic,strong) NSMutableArray<BKPickerReusingViewModel*> * visible;
/**
 缓存的titleLab
 */
@property (nonatomic,strong) NSMutableArray<BKPickerReusingViewModel*> * cache;

@end

NS_ASSUME_NONNULL_END
