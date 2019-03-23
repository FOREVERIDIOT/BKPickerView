//
//  BKPickerToolsView.m
//  BKPickerView
//
//  Created by zhaolin on 2019/1/24.
//  Copyright © 2019年 BIKE. All rights reserved.
//

#import "BKPickerToolsView.h"
#import "UIView+BKPickerView.h"
#import "BKPickerConstant.h"

@interface BKPickerToolsView()

@property (nonatomic,strong) UILabel * remindLab;
@property (nonatomic,strong) UIButton * confirmBtn;

@end

@implementation BKPickerToolsView

#pragma mark - setter

-(void)setRemind:(NSString *)remind
{
    _remind = remind;
    self.remindLab.text = _remind ? _remind : @"";
}

#pragma mark - init

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = BK_PICKER_TOOLBAR_COLOR;
        [self initUI];
    }
    return self;
}

#pragma mark - initUI

-(void)initUI
{
    UIButton * cancelBtn  = [UIButton buttonWithType:UIButtonTypeSystem];
    cancelBtn.frame = CGRectMake(0, 0, 64, self.bk_height);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:BK_PICKER_TOOLBAR_BUTTON_TITLE_COLOR forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:kPickerToolsViewBtnTitleFontSize];
    [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelBtn];
    
    self.confirmBtn  = [UIButton buttonWithType:UIButtonTypeSystem];
    self.confirmBtn.frame = CGRectMake(self.bk_width - 64, 0, 64, self.bk_height);
    [self.confirmBtn setTitle:@"完成" forState:UIControlStateNormal];
    [self.confirmBtn setTitleColor:BK_PICKER_TOOLBAR_BUTTON_TITLE_COLOR forState:UIControlStateNormal];
    self.confirmBtn.titleLabel.font = [UIFont systemFontOfSize:kPickerToolsViewBtnTitleFontSize];
    [self.confirmBtn addTarget:self action:@selector(confirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.confirmBtn];
    
    self.remindLab = [[UILabel alloc]initWithFrame:CGRectMake(64, 0, self.bk_width - 64*2, self.bk_height)];
    self.remindLab.textColor = BK_PICKER_TOOLBAR_REMIND_TITLE_COLOR;
    self.remindLab.font = [UIFont systemFontOfSize:kPickerToolsViewRemindTitleFontSize];
    self.remindLab.textAlignment = NSTextAlignmentCenter;
    self.remindLab.text = self.remind ? self.remind : @"";
    [self addSubview:self.remindLab];
}

-(void)cancelBtnClick
{
    if (self.clickCancelBtnCallBack) {
        self.clickCancelBtnCallBack();
    }
}

-(void)confirmBtnClick
{
    if (self.clickConfirmBtnCallBack) {
        self.clickConfirmBtnCallBack();
    }
}


@end
