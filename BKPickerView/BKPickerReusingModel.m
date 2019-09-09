//
//  BKPickerReusingModel.m
//  BKPickerView
//
//  Created by zhaolin on 2019/3/20.
//  Copyright © 2019年 BIKE. All rights reserved.
//

#import "BKPickerReusingModel.h"

@implementation BKPickerReusingViewModel

@end

@implementation BKPickerReusingModel

-(NSMutableArray<BKPickerReusingViewModel *> *)visible
{
    if (!_visible) {
        _visible = [NSMutableArray array];
    }
    return _visible;
}

-(NSMutableArray<BKPickerReusingViewModel *> *)cache
{
    if (!_cache) {
        _cache = [NSMutableArray array];
    }
    return _cache;
}

@end
