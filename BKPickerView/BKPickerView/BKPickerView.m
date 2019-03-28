//
//  BKPickerView.m
//  BKPickerView
//
//  Created by zhaolin on 2019/1/23.
//  Copyright © 2019年 BIKE. All rights reserved.
//

#import "BKPickerView.h"
#import "UIView+BKPickerView.h"
#import "BKPickerConstant.h"
#import "BKPickerToolsView.h"
#import "NSDate+BKPickerView.h"
#import "BKPickerReusingModel.h"
#import "BKPickerSelectDateTools.h"

typedef NS_ENUM(NSUInteger, BKPickerDisplayStyle) {
    BKPickerDisplayStyleNormal = 0,              //普通样式
    BKPickerDisplayStyleDate,                    //时间样式
};

@interface BKPickerView()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic,assign) BKPickerDisplayStyle pickerDisplayStyle;//显示样式
@property (nonatomic,assign) BKPickerStyle pickerStyle;//普通样式
@property (nonatomic,assign) BKPickerDateStyle pickerDateStyle;//时间样式

@property (nonatomic,strong) NSDate * selectDate;//当前选取日期
@property (nonatomic,strong) NSDate * maxDate;//最大选取日期
@property (nonatomic,strong) NSDate * minDate;//最小选取日期
@property (nonatomic,strong) BKPickerSelectDateTools * selectDateTools;//选取日期工具
@property (nonatomic,copy) NSArray<NSString*> * dateTypes;//时间格式数组 如@[@"年",@"月",@"日",@"时",@"分",@"秒"]
@property (nonatomic,assign) NSUInteger daysOfMonth;//时间样式中当月天数

@property (nonatomic,copy) NSString * remind;//提示

@property (nonatomic,strong) UIView * shadowView;//阴影
@property (nonatomic,strong) UIView * alertView;//弹框
@property (nonatomic,strong) BKPickerToolsView * toolsView;//工具栏
@property (nonatomic,weak) UIPickerView * pickerView;//选取器
@property (nonatomic,copy) NSArray<BKPickerReusingModel*> * pickerReusingArr;//pickerView复用数据

@end

@implementation BKPickerView

#pragma mark - 普通格式Setter方法

-(void)setDataArr:(NSArray * _Nonnull)dataArr
{
    _dataArr = dataArr;
}

-(void)setSelectIndex:(NSInteger)selectIndex
{
    _selectIndex = selectIndex;
    [self.pickerView selectRow:_selectIndex inComponent:0 animated:NO];
}

-(void)setSelectIndexArr:(NSArray<NSNumber *> *)selectIndexArr
{
    _selectIndexArr = selectIndexArr;
    for (int i = 0; i < [_selectIndexArr count]; i++) {
        [self.pickerView selectRow:[_selectIndexArr[i] integerValue] inComponent:i animated:NO];
    }
}

#pragma mark - 时间格式选中Setter方法

-(void)setSelectDate:(NSDate *)selectDate
{
    _selectDate = selectDate;
    if (!self.selectDateTools) {
        self.selectDateTools = [[BKPickerSelectDateTools alloc] init];
    }
    [self.selectDateTools changeSelectDate:_selectDate];
}

#pragma mark - 创建方法

-(instancetype)initWithPickerDateStyle:(BKPickerDateStyle)pickerDateStyle selectDate:(nullable NSDate *)selectDate maxDate:(nullable NSDate *)maxDate minDate:(nullable NSDate *)minDate remind:(nonnull NSString *)remind
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        _pickerDisplayStyle = BKPickerDisplayStyleDate;
        _pickerDateStyle = pickerDateStyle;
        self.maxDate = maxDate;
        self.minDate = minDate;
        self.selectDate = selectDate;
        NSUInteger maxDateSp = [self.maxDate timeIntervalSince1970];
        NSUInteger minDateSp = [self.minDate timeIntervalSince1970];
        if (self.maxDate && self.minDate) {
            NSAssert(minDateSp < maxDateSp, @"最大时间小于最小时间");
        }
        if (!self.selectDate) {
            if (self.maxDate) {
                self.selectDate = self.maxDate;
            }else if (self.minDate) {
                self.selectDate = self.minDate;
            }
        }
        _remind = remind;
        
        NSMutableArray * types = [NSMutableArray array];
        NSMutableArray * reusings = [NSMutableArray array];
        if (pickerDateStyle & BKPickerDateStyleDisplayYear) {
            [types addObject:@"年"];
            BKPickerReusingModel * model = [[BKPickerReusingModel alloc] init];
            [reusings addObject:model];
        }
        if (pickerDateStyle & BKPickerDateStyleDisplayMonth) {
            [types addObject:@"月"];
            BKPickerReusingModel * model = [[BKPickerReusingModel alloc] init];
            [reusings addObject:model];
        }
        if (pickerDateStyle & BKPickerDateStyleDisplayDay) {
            [types addObject:@"日"];
            BKPickerReusingModel * model = [[BKPickerReusingModel alloc] init];
            [reusings addObject:model];
            NSUInteger year = [_selectDate bk_transformYear];
            NSUInteger month = [_selectDate bk_transformMonth];
            self.daysOfMonth = [self getDaysWithYear:year month:month];
        }
        if (pickerDateStyle & BKPickerDateStyleDisplayHour) {
            [types addObject:@"时"];
            BKPickerReusingModel * model = [[BKPickerReusingModel alloc] init];
            [reusings addObject:model];
        }
        if (pickerDateStyle & BKPickerDateStyleDisplayMinute) {
            [types addObject:@"分"];
            BKPickerReusingModel * model = [[BKPickerReusingModel alloc] init];
            [reusings addObject:model];
        }
        if (pickerDateStyle & BKPickerDateStyleDisplaySecond) {
            [types addObject:@"秒"];
            BKPickerReusingModel * model = [[BKPickerReusingModel alloc] init];
            [reusings addObject:model];
        }
        self.dateTypes = [types copy];
        self.pickerReusingArr = [reusings copy];
        
        [self addSubview:self.shadowView];
        [self addSubview:self.alertView];
        
        [self scrollDatePickerViewWithDate:self.selectDate animated:NO];
    }
    return self;
}

-(instancetype)initWithPickerDataArr:(NSArray *)dataArr remind:(NSString *)remind
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        _pickerDisplayStyle = BKPickerDisplayStyleNormal;
        _dataArr = dataArr;
        _remind = remind;
        
        __block Class contentClass = nil;
        [_dataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            Class nextContentClass = [obj class];
            if (!contentClass) {
                contentClass = nextContentClass;
            }else {
                NSAssert([[nextContentClass superclass] isSubclassOfClass:[contentClass superclass]], @"初始化选取器数据数组中元素格式不统一");
            }
        }];
        
        
        if ([contentClass isSubclassOfClass:[NSString class]]) {
            _pickerStyle = BKPickerStyleSingle;
            _selectIndex = 0;
            BKPickerReusingModel * model = [[BKPickerReusingModel alloc] init];
            self.pickerReusingArr = @[model];
        }else if ([contentClass isSubclassOfClass:[NSArray class]]) {
            _pickerStyle = BKPickerStyleMultilevelLinkage;
            __block NSMutableArray * selectIndexs = [NSMutableArray array];
            __block NSMutableArray * reusings = [NSMutableArray array];
            [_dataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [selectIndexs addObject:@(0)];
                BKPickerReusingModel * model = [[BKPickerReusingModel alloc] init];
                [reusings addObject:model];
            }];
            self.selectIndexArr = [selectIndexs copy];
            self.pickerReusingArr = [reusings copy];
        }
        
        [self addSubview:self.shadowView];
        [self addSubview:self.alertView];
    }
    return self;
}

-(void)dealloc
{
    NSLog(@"释放");
}

#pragma mark - 隐藏/显示

-(void)show
{
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    if (!window.userInteractionEnabled) {
        return;
    }
    window.userInteractionEnabled = NO;
    [window addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.shadowView.alpha = 1;
        self.alertView.bk_y = self.bk_height - BKPicker_alertHeight();
    } completion:^(BOOL finished) {
        window.userInteractionEnabled = YES;
    }];
}

-(void)hiddenComplete:(void (^)(void))complete
{
    if (!self.userInteractionEnabled) {
        return;
    }
    self.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.shadowView.alpha = 0;
        self.alertView.bk_y = self.bk_height;
    } completion:^(BOOL finished) {
        self.userInteractionEnabled = YES;
        if (complete) {
            complete();
        }
    }];
}

#pragma mark - 阴影

-(UIView *)shadowView
{
    if (!_shadowView) {
        _shadowView = [[UIView alloc] initWithFrame:self.bounds];
        _shadowView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        _shadowView.alpha = 0;
        
        UITapGestureRecognizer * shadowTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shadowTap)];
        [_shadowView addGestureRecognizer:shadowTap];
    }
    return _shadowView;
}

-(void)shadowTap
{
    [self cancel];
}

#pragma mark - 弹框

-(UIView *)alertView
{
    if (!_alertView) {
        _alertView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bk_height, self.bk_width, BKPicker_alertHeight())];
        _alertView.backgroundColor = BK_PICKER_BACKGROUND_COLOR;
        
        [_alertView addSubview:self.toolsView];
        
        //UIPickerView不能设置全局 否则刷新时有刷新数据显示不变bug
        UIPickerView * pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.toolsView.frame), self.alertView.bk_width, self.alertView.bk_height - CGRectGetMaxY(self.toolsView.frame) - BKPicker_bottom_offset())];
        pickerView.delegate = self;
        pickerView.dataSource = self;
        pickerView.backgroundColor = [UIColor clearColor];
        [_alertView addSubview:pickerView];
        self.pickerView = pickerView;
        
        //UIPickerView系统线的高度是0.5
        CGFloat sysLineH = 0.5;
        
        UIImageView * topLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_toolsView.frame) + (_pickerView.bk_height - kPickerContentRowHeight)/2 - sysLineH - BK_PICKER_ONE_PIXEL, _alertView.bk_width, BK_PICKER_ONE_PIXEL)];
        topLine.backgroundColor = BK_PICKER_MAGNIFY_LINE_COLOR;
        [_alertView addSubview:topLine];
        
        UIImageView * bottomLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_toolsView.frame) + (_pickerView.bk_height + kPickerContentRowHeight)/2 + sysLineH , _alertView.bk_width, BK_PICKER_ONE_PIXEL)];
        bottomLine.backgroundColor = BK_PICKER_MAGNIFY_LINE_COLOR;
        [_alertView addSubview:bottomLine];
    }
    return _alertView;
}

#pragma mark - 工具栏

-(BKPickerToolsView *)toolsView
{
    if (!_toolsView) {
        _toolsView = [[BKPickerToolsView alloc] initWithFrame:CGRectMake(0, 0, self.alertView.bk_width, kPickerToolsViewHeight)];
        _toolsView.remind = self.remind;
        BK_PICKER_WEAK_SELF(self);
        [_toolsView setClickCancelBtnCallBack:^{
            [weakSelf cancel];
        }];
        [_toolsView setClickConfirmBtnCallBack:^{
            [weakSelf confirm];
        }];
    }
    return _toolsView;
}

-(void)cancel
{
    [self hiddenComplete:^{
        [self removeFromSuperview];
    }];
}

-(void)confirm
{
    if (self.pickerDisplayStyle == BKPickerDisplayStyleNormal) {
        if (self.pickerStyle == BKPickerStyleSingle) {
            if (self.confirmSelectCallback) {
                self.confirmSelectCallback(self.selectIndex);
            }
        }else if (self.pickerStyle == BKPickerStyleMultilevelLinkage) {
            if (self.confirmSelectIndexsCallback) {
                self.confirmSelectIndexsCallback(self.selectIndexArr);
            }
        }
    }else if (self.pickerDisplayStyle == BKPickerDisplayStyleDate) {
        if (self.confirmSelectDateCallback) {
            self.confirmSelectDateCallback(self.selectDate);
        }
    }
    
    [self cancel];
}

#pragma mark - UIPickerViewDelegate, UIPickerViewDataSource

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (self.pickerDisplayStyle == BKPickerDisplayStyleNormal) {
        if (self.pickerStyle == BKPickerStyleSingle) {
            return 1;
        }else {
            return [self.dataArr count];
        }
    }else {
        return [self.dateTypes count];
    }
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (self.pickerDisplayStyle == BKPickerDisplayStyleNormal) {
        if (self.pickerStyle == BKPickerStyleSingle) {
            return [self.dataArr count];
        }else {
            return [self.dataArr[component] count];
        }
    }else {
        return kBKDatePickerMaxRow;
    }
}

-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (self.pickerDisplayStyle == BKPickerDisplayStyleDate) {
        if (self.pickerDisplayStyle & BKPickerDateStyleDisplayYear) {
            NSString * type = self.dateTypes[component];
            //UIPickerView每列有间距 不知道多少 为了使年宽一点 多平分一份
            CGFloat width = self.bk_width / ([self.dateTypes count] + 1);
            if ([type isEqualToString:@"年"]) {
                return width * 1.5;//使年宽一点
            }else {
                return width;
            }
        }else {
            //UIPickerView每列有间距 不知道多少 所有宽*0.95
            CGFloat width = self.bk_width / [self.dateTypes count] * 0.95;
            return width;
        }
    }else {
        if (self.pickerStyle == BKPickerStyleSingle) {
            //UIPickerView每列有间距 不知道多少 所有宽*0.95
            return self.bk_width * 0.95;
        }else {
            //UIPickerView每列有间距 不知道多少 所有宽*0.95
            CGFloat width = self.bk_width / [self.dataArr count] * 0.95;
            return width;
        }
    }
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return kPickerContentRowHeight;
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view
{
    //隐藏系统分割线
    for (UIView * subview in pickerView.subviews) {
        if (subview.bk_height <= 1) {
            subview.backgroundColor = [UIColor clearColor];
        }
    }
    
//    reusingView一直为nil... 复用自己做了
    BKPickerReusingModel * model = self.pickerReusingArr[component];
//    发现不能复用正在显示的titleLab，会出现不显示bug。
//    __block BKPickerReusingViewModel * displayReusingViewModel = nil;//对应行是否正在显示
    [model.visible enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(BKPickerReusingViewModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.titleLab superview] == nil) {//没父视图，代表不显示
            //不显示行数归为-1
            obj.row = -1;
            [model.visible removeObject:obj];
            [model.cache addObject:obj];
        }
//        else if (obj.row == row) {//如果正在显示
//            displayReusingViewModel = obj;
//        }
    }];
    
    BKPickerReusingViewModel * reusingViewModel = nil;
//    if (displayReusingViewModel) {//正在显示
//        reusingViewModel = displayReusingViewModel;
//    }else
    if ([model.cache count] > 0) {//不显示，缓存数大于0，从缓存取
        reusingViewModel = [model.cache lastObject];
        reusingViewModel.row = row;
        [model.visible addObject:reusingViewModel];
        [model.cache removeLastObject];
    }else {//不显示，缓存数等于0，创建
        UILabel * titleLab = [[UILabel alloc] init];
        titleLab.font = [UIFont systemFontOfSize:kPickerContentTitleFontSize];
        titleLab.textColor = [UIColor blackColor];
        titleLab.textAlignment = NSTextAlignmentCenter;
        
        reusingViewModel = [[BKPickerReusingViewModel alloc] init];
        reusingViewModel.titleLab = titleLab;
        reusingViewModel.row = row;
        [model.visible addObject:reusingViewModel];
    }
    
    [self assignDataWithTitleLab:reusingViewModel.titleLab component:component row:row];
    
    return reusingViewModel.titleLab;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (self.pickerDisplayStyle == BKPickerDisplayStyleNormal) {
        if (self.pickerStyle == BKPickerStyleSingle) {
            self.selectIndex = row;
        }else if (self.pickerStyle == BKPickerStyleMultilevelLinkage) {
            NSMutableArray * selectIndexArr = [self.selectIndexArr mutableCopy];
            [selectIndexArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (component == idx) {
                    [selectIndexArr replaceObjectAtIndex:idx withObject:@(row)];
                }else if (component < idx){
                    [selectIndexArr replaceObjectAtIndex:idx withObject:@(0)];
                }
            }];

            if (self.changeSelectIndexsCallback) {
                self.dataArr = [self.changeSelectIndexsCallback(self, selectIndexArr) copy];
            }
            self.selectIndexArr = [selectIndexArr copy];
            [self.selectIndexArr enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [self.pickerView selectRow:[obj integerValue] inComponent:idx animated:NO];
            }];
            //刷新pickerView
            [self.pickerView reloadAllComponents];
        }
    }else if (self.pickerDisplayStyle == BKPickerDisplayStyleDate) {
        //获取选中日期
        self.selectDate = [self getSelectDateAndCheckToSeeIfDateExists];
        //比较是否超过最大时间
        BOOL isMoreThan = [self isMoreThanMaxDate:self.selectDate];
        if (isMoreThan) {
            //超过 替换
            self.selectDate = self.maxDate;
            //修改当月的最大日数
            NSUInteger year = [self.selectDate bk_transformYear];
            NSUInteger month = [self.selectDate bk_transformMonth];
            self.daysOfMonth = [self getDaysWithYear:year month:month];
            //修改选中
            [self scrollDatePickerViewWithDate:self.selectDate animated:YES];
        }
        //比较是否小于最小时间
        BOOL isLessThan = [self isLessThanMinDate:self.selectDate];
        if (isLessThan) {
            //小于 替换
            self.selectDate = self.minDate;
            //修改当月的最大日数
            NSUInteger year = [self.selectDate bk_transformYear];
            NSUInteger month = [self.selectDate bk_transformMonth];
            self.daysOfMonth = [self getDaysWithYear:year month:month];
            //修改选中
            [self scrollDatePickerViewWithDate:self.selectDate animated:YES];
        }
        //刷新pickerView
        [self reloadPickerView];
    }
}

#pragma mark - 获取选中日期 并且 查看选中日期是不是不存在 如(2019-02-30 00:00:00)

/**
 获取选中日期 并且 查看选中日期是不是不存在 如(2019-02-30 00:00:00)

 @return 日期
 */
-(NSDate*)getSelectDateAndCheckToSeeIfDateExists
{
    NSUInteger year = [self getCurrentCorrespondingValueWithDateStyle:BKPickerDateStyleDisplayYear];
    NSUInteger month = [self getCurrentCorrespondingValueWithDateStyle:BKPickerDateStyleDisplayMonth];
    NSUInteger day = [self getCurrentCorrespondingValueWithDateStyle:BKPickerDateStyleDisplayDay];
    //修改当月的最大日数
    self.daysOfMonth = [self getDaysWithYear:year month:month];
    //回退行数
    NSInteger backRow = 0;
    if (day > self.daysOfMonth) {
        //获取日所在component
        NSInteger dayComponent = -1;
        if ([self.dateTypes containsObject:@"日"]) {
            dayComponent = [self.dateTypes indexOfObject:@"日"];
        }
        NSUInteger row = [self.pickerView selectedRowInComponent:dayComponent];
        backRow = day - self.daysOfMonth;
        //修改选中行数
        [self.pickerView selectRow:row - backRow inComponent:dayComponent animated:YES];
        //转成当月最大日
        day = self.daysOfMonth;
    }
    
    NSMutableString * dateStr = [NSMutableString string];
    [dateStr appendFormat:@"%ld-", year];
    [dateStr appendFormat:@"%ld-", month];
    [dateStr appendFormat:@"%ld ", day];
    [dateStr appendFormat:@"%ld:", [self getCurrentCorrespondingValueWithDateStyle:BKPickerDateStyleDisplayHour]];
    [dateStr appendFormat:@"%ld:", [self getCurrentCorrespondingValueWithDateStyle:BKPickerDateStyleDisplayMinute]];
    [dateStr appendFormat:@"%ld", [self getCurrentCorrespondingValueWithDateStyle:BKPickerDateStyleDisplaySecond]];
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    return [dateFormatter dateFromString:dateStr];
}

#pragma mark - 根据时间格式获取当前对应的值

/**
 根据时间格式获取当前对应的值

 @param dateStyle 时间格式(年月日时分秒)
 @return 值
 */
-(NSUInteger)getCurrentCorrespondingValueWithDateStyle:(BKPickerDateStyle)dateStyle
{
    NSString * typeStr = @"";
    switch (dateStyle) {
        case BKPickerDateStyleDisplayYear:
        {
            typeStr = @"年";
        }
            break;
        case BKPickerDateStyleDisplayMonth:
        {
            typeStr = @"月";
        }
            break;
        case BKPickerDateStyleDisplayDay:
        {
            typeStr = @"日";
        }
            break;
        case BKPickerDateStyleDisplayHour:
        {
            typeStr = @"时";
        }
            break;
        case BKPickerDateStyleDisplayMinute:
        {
            typeStr = @"分";
        }
            break;
        case BKPickerDateStyleDisplaySecond:
        {
            typeStr = @"秒";
        }
            break;
    }
    NSInteger component = -1;
    if ([self.dateTypes containsObject:typeStr]) {
        component = [self.dateTypes indexOfObject:typeStr];
    }
    //找到了
    if (component > -1) {
        return [self exportSelectDateInComponent:component];
    }
    //没找到
    switch (dateStyle) {
        case BKPickerDateStyleDisplayYear:
        {
            return self.selectDateTools.selectYear;
        }
            break;
        case BKPickerDateStyleDisplayMonth:
        {
            return self.selectDateTools.selectMonth;
        }
            break;
        case BKPickerDateStyleDisplayDay:
        {
            return self.selectDateTools.selectDay;
        }
            break;
        case BKPickerDateStyleDisplayHour:
        {
            return self.selectDateTools.selectHour;
        }
            break;
        case BKPickerDateStyleDisplayMinute:
        {
            return self.selectDateTools.selectMinute;
        }
            break;
        case BKPickerDateStyleDisplaySecond:
        {
            return self.selectDateTools.selectSecond;
        }
            break;
    }
}

/**
 导出该列选中的时间
 
 @param component 列
 @return 时间
 */
-(NSUInteger)exportSelectDateInComponent:(NSUInteger)component
{
    NSUInteger row = [self.pickerView selectedRowInComponent:component];
    UILabel * titleLab = (UILabel*)[self.pickerView viewForRow:row forComponent:component];
    NSMutableString * dateStr = [titleLab.text mutableCopy];
    [dateStr deleteCharactersInRange:NSMakeRange([titleLab.text length] - 1, 1)];
    NSUInteger date = [dateStr integerValue];
    return date;
}

#pragma mark - 比较最大/最小时间

-(BOOL)isMoreThanMaxDate:(NSDate*)date
{
    if (!self.maxDate) {
        return NO;
    }
    //最小到秒 不计毫秒
    NSUInteger maxDateSp = [self.maxDate timeIntervalSince1970];
    NSUInteger dateSp = [date timeIntervalSince1970];
    NSLog(@"dateSp:%@ maxDateSp:%@",date,self.maxDate);
    if (dateSp > maxDateSp) {
        return YES;
    }
    
    return NO;
}

-(BOOL)isLessThanMinDate:(NSDate*)date
{
    if (!self.minDate) {
        return NO;
    }
    //最小到秒 不计毫秒
    NSUInteger minDateSp = [_minDate timeIntervalSince1970];
    NSUInteger dateSp = [date timeIntervalSince1970];
    if (dateSp < minDateSp) {
        return YES;
    }
    
    return NO;
}

#pragma mark - 时间滚轮转至指定位置

/**
 时间滚轮转至指定位置
 
 @param date 时间
 */
-(void)scrollDatePickerViewWithDate:(NSDate*)date animated:(BOOL)animated
{
    NSUInteger midRow = kBKDatePickerMaxRow / 2;
    [self.dateTypes enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString * type = obj;
        NSUInteger row = 0;
        if ([type isEqualToString:@"年"]) {
            NSUInteger year = [date bk_transformYear];
            row = year - 1;
        }else if ([type isEqualToString:@"月"]) {
            NSUInteger month = [date bk_transformMonth];
            row = midRow - midRow % 12 + month - 1;
        }else if ([type isEqualToString:@"日"]) {
            NSUInteger day = [date bk_transformDay];
            row = midRow - midRow % 31 + day - 1;
        }else if ([type isEqualToString:@"时"]) {
            NSUInteger hour = [date bk_transformHour];
            row = midRow - midRow % 24 + hour;
        }else if ([type isEqualToString:@"分"]) {
            NSUInteger minute = [date bk_transformMinute];
            row = midRow - midRow % 60 + minute;
        }else if ([type isEqualToString:@"秒"]) {
            NSUInteger second = [date bk_transformSecond];
            row = midRow - midRow % 60 + second;
        }
        [self.pickerView selectRow:row inComponent:idx animated:animated];
    }];
}

#pragma mark - 刷新

/**
 刷新
 */
-(void)reloadPickerView
{
    [self.dateTypes enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self reloadComponent:idx];
    }];
}

/**
 刷新列

 @param component 列
 */
-(void)reloadComponent:(NSUInteger)component
{
    BKPickerReusingModel * reusingModel = [self.pickerReusingArr objectAtIndex:component];
    [reusingModel.visible enumerateObjectsUsingBlock:^(BKPickerReusingViewModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self assignDataWithTitleLab:obj.titleLab component:component row:obj.row];
    }];
}

#pragma mark - 给对应行赋值

/**
 给对应行赋值
 
 @param titleLab 标题
 @param component 列
 @param row 行
 */
-(void)assignDataWithTitleLab:(UILabel*)titleLab component:(NSUInteger)component row:(NSUInteger)row
{
    if (self.pickerDisplayStyle == BKPickerDisplayStyleNormal) {
        if (self.pickerStyle == BKPickerStyleMultilevelLinkage) {
            if (component < [self.dataArr count]) {
                NSArray * dataArr = [self.dataArr objectAtIndex:component];
                if (row < [dataArr count]) {
                    titleLab.text = [dataArr objectAtIndex:row];
                }else {
                    titleLab.text = @"";
                }
            }else {
                titleLab.text = @"";
            }
        }else{
            if (row < [self.dataArr count]) {
                titleLab.text = [self.dataArr objectAtIndex:row];
            }else {
                titleLab.text = @"";
            }
        }
    }else if (self.pickerDisplayStyle == BKPickerDisplayStyleDate) {
        NSString * type = self.dateTypes[component];
        NSUInteger value = 0;
        NSUInteger min_year = 1, min_month = 1, min_day = 1, min_hour = 0, min_minute = 0, min_second = 0;
        NSUInteger max_year = 1, max_month = 1, max_day = 1, max_hour = 0, max_minute = 0, max_second = 0;
        if ([type isEqualToString:@"年"]) {
            value = row + 1;
            min_year = value;
            min_month = 12;
            min_day = 31;
            min_hour = 23;
            min_minute = 59;
            min_second = 59;
            max_year = value;
            max_month = 1;
            max_day = 1;
            max_hour = 0;
            max_minute = 0;
            max_second = 0;
            titleLab.text = [NSString stringWithFormat:@"%ld年",value];
        }else if ([type isEqualToString:@"月"]) {
            value = row % 12 + 1;
            NSUInteger year = self.selectDateTools.selectYear;
            NSUInteger maxDay = [self getDaysWithYear:year month:value];
            min_year = year;
            min_month = value;
            min_day = maxDay;
            min_hour = 23;
            min_minute = 59;
            min_second = 59;
            max_year = year;
            max_month = value;
            max_day = 1;
            max_hour = 0;
            max_minute = 0;
            max_second = 0;
            titleLab.text = [NSString stringWithFormat:@"%ld月",value];
        }else if ([type isEqualToString:@"日"]) {
            value = row % 31 + 1;
            NSUInteger year = self.selectDateTools.selectYear;
            NSUInteger month = self.selectDateTools.selectMonth;
            min_year = year;
            min_month = month;
            min_day = value;
            min_hour = 23;
            min_minute = 59;
            min_second = 59;
            max_year = year;
            max_month = month;
            max_day = value;
            max_hour = 0;
            max_minute = 0;
            max_second = 0;
            titleLab.text = [NSString stringWithFormat:@"%ld日",value];
        }else if ([type isEqualToString:@"时"]) {
            value = row % 24;
            NSUInteger year = self.selectDateTools.selectYear;
            NSUInteger month = self.selectDateTools.selectMonth;
            NSUInteger day = self.selectDateTools.selectDay;
            min_year = year;
            min_month = month;
            min_day = day;
            min_hour = value;
            min_minute = 59;
            min_second = 59;
            max_year = year;
            max_month = month;
            max_day = day;
            max_hour = value;
            max_minute = 0;
            max_second = 0;
            titleLab.text = [NSString stringWithFormat:@"%ld时",value];
        }else if ([type isEqualToString:@"分"]) {
            value = row % 60;
            NSUInteger year = self.selectDateTools.selectYear;
            NSUInteger month = self.selectDateTools.selectMonth;
            NSUInteger day = self.selectDateTools.selectDay;
            NSUInteger hour = self.selectDateTools.selectHour;
            min_year = year;
            min_month = month;
            min_day = day;
            min_hour = hour;
            min_minute = value;
            min_second = 59;
            max_year = year;
            max_month = month;
            max_day = day;
            max_hour = hour;
            max_minute = value;
            max_second = 0;
            titleLab.text = [NSString stringWithFormat:@"%ld分",value];
        }else if ([type isEqualToString:@"秒"]) {
            value = row % 60;
            NSUInteger year = self.selectDateTools.selectYear;
            NSUInteger month = self.selectDateTools.selectMonth;
            NSUInteger day = self.selectDateTools.selectDay;
            NSUInteger hour = self.selectDateTools.selectHour;
            NSUInteger minute = self.selectDateTools.selectMinute;
            min_year = year;
            min_month = month;
            min_day = day;
            min_hour = hour;
            min_minute = minute;
            min_second = value;
            max_year = year;
            max_month = month;
            max_day = day;
            max_hour = hour;
            max_minute = minute;
            max_second = value;
            titleLab.text = [NSString stringWithFormat:@"%ld秒",value];
        }
        
        BOOL isLessThan = NO;
        if (self.minDate) {
            NSDate * min_currentDate = [self getDatePickerSelectTimeWithYearValue:min_year monthValue:min_month dayValue:min_day hourValue:min_hour minuteValue:min_minute secondValue:min_second];
            isLessThan = [self isLessThanMinDate:min_currentDate];
        }
        BOOL isMoreThan = NO;
        if (self.maxDate) {
            NSDate * max_currentDate = [self getDatePickerSelectTimeWithYearValue:max_year monthValue:max_month dayValue:max_day hourValue:max_hour minuteValue:max_minute secondValue:max_second];
            isMoreThan = [self isMoreThanMaxDate:max_currentDate];
        }
        if (isMoreThan || isLessThan) {
            titleLab.textColor = [UIColor lightGrayColor];
        }else {
            if ([type isEqualToString:@"日"]) {
                if (value > self.daysOfMonth) {
                    titleLab.textColor = [UIColor lightGrayColor];
                }else {
                    titleLab.textColor = [UIColor blackColor];
                }
            }else {
                titleLab.textColor = [UIColor blackColor];
            }
        }
    }
}

#pragma mark - 获取时间选取器中指定的时间

/**
 获取时间选取器中指定的时间

 @param yearValue 年对应的值
 @param monthValue 月对应的值
 @param dayValue 日对应的值
 @param hourValue 时对应的值
 @param minuteValue 分对应的值
 @param secondValue 秒对应的值
 @return 时间
 */
-(NSDate*)getDatePickerSelectTimeWithYearValue:(NSUInteger)yearValue monthValue:(NSUInteger)monthValue dayValue:(NSUInteger)dayValue hourValue:(NSUInteger)hourValue minuteValue:(NSUInteger)minuteValue secondValue:(NSUInteger)secondValue
{
    NSString * dateStr = [NSString stringWithFormat:@"%ld-%ld-%ld %ld:%ld:%ld", yearValue, monthValue, dayValue, hourValue, minuteValue, secondValue];
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    dateFormatter.locale = [NSLocale systemLocale];
    NSDate * date = [dateFormatter dateFromString:dateStr];
    
    return date;
}

#pragma mark - 切换年/月时 获取当月天数

/**
 用年/月获取天数
 
 @param year 年
 @param month 月
 @return 天数
 */
-(NSUInteger)getDaysWithYear:(NSUInteger)year month:(NSUInteger)month
{
    NSUInteger days = 0;//一月几天
    if (month == 2) {
        //闰年:能被4整除但不能被100整除的年份为普通闰年。 能被400整除的为世纪闰年。
        if ((year%4 == 0 && year%100 != 0) || year%400 == 0) {
            days = 29;
        }else {
            days = 28;
        }
    }else if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12) {
        days = 31;
    }else {
        days = 30;
    }
    return days;
}

@end
