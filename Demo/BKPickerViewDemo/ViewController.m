//
//  ViewController.m
//  BKPickerViewDemo
//
//  Created by zhaolin on 2019/9/9.
//  Copyright © 2019 BIKE. All rights reserved.
//

#import "ViewController.h"
#import <BKPickerView/BKPickerView.h>

/**
 是否是iPhone X系列
 */
NS_INLINE CGFloat isIPhoneXSeries() {
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

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,copy) NSArray * titles;

@property (nonatomic,copy) NSArray * arr1;
@property (nonatomic,copy) NSArray * arr2;

@end

@implementation ViewController

#pragma mark - viewDidLoad

-(void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titles = @[@"单选", @"多选", @"年月日", @"年月日时分秒"];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    CGFloat y = isIPhoneXSeries() ? 44 : 20;
    self.tableView.frame = CGRectMake(0, y, self.view.frame.size.width, self.view.frame.size.height);
}

#pragma mark - UITableView

-(UITableView*)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.rowHeight = 50;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.titles count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.textLabel.text = self.titles[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BKPickerView * picker = nil;
    switch (indexPath.row) {
        case 0:
        {
            picker = [[BKPickerView alloc] initWithPickerDataArr:@[@"1", @"3", @"2", @"4", @"5"] remind:@"单选"];
        }
            break;
        case 1:
        {
            self.arr1 = @[@"11", @"13", @"12", @"14", @"15"];
            self.arr2 = @[@"31", @"33", @"32", @"34", @"35"];
            picker = [[BKPickerView alloc] initWithPickerDataArr:@[@[@"1", @"3", @"2", @"4", @"5"],
                                                                   self.arr1,
                                                                   @[@"121", @"123", @"122", @"124", @"125"]] remind:@"多选"];
            __weak typeof(self) weakSelf = self;
            [picker setChangeSelectIndexsCallback:^NSArray * _Nonnull(BKPickerView * _Nonnull pickerView, NSArray<NSNumber *> * _Nonnull selectIndexArr) {
                NSLog(@"选中的索引数组%@", selectIndexArr);
                NSMutableArray * nDataArr = [NSMutableArray arrayWithArray:pickerView.dataArr];
                if ([[selectIndexArr firstObject] integerValue] == 2) {
                    [nDataArr replaceObjectAtIndex:1 withObject:weakSelf.arr2];
                }else {
                    [nDataArr replaceObjectAtIndex:1 withObject:weakSelf.arr1];
                }
                return [nDataArr copy];
            }];
        }
            break;
        case 2:
        {
            //2019-08-14 14:22:18 1565763738
            picker = [[BKPickerView alloc] initWithPickerDateStyle:BKPickerDateStyleDisplayYear | BKPickerDateStyleDisplayMonth | BKPickerDateStyleDisplayDay selectDate:[NSDate dateWithTimeIntervalSince1970:1565763738] maxDate:nil minDate:nil remind:@"年月日"];
        }
            break;
        case 3:
        {
            //2011-12-15 17:13:14 1323940394
            //2024-08-16 00:13:57 1723738437
            picker = [[BKPickerView alloc] initWithPickerDateStyle:BKPickerDateStyleDisplayYear | BKPickerDateStyleDisplayMonth | BKPickerDateStyleDisplayDay | BKPickerDateStyleDisplayHour | BKPickerDateStyleDisplayMinute | BKPickerDateStyleDisplaySecond selectDate:nil maxDate:[NSDate dateWithTimeIntervalSince1970:1723738437] minDate:[NSDate dateWithTimeIntervalSince1970:1323940394] remind:@"年月日时分秒"];
        }
            break;
        default:
        {
            return;
        }
            break;
    }
    [picker setConfirmSelectCallback:^(NSInteger selectIndex) {
        NSLog(@"单选选中:%ld", selectIndex);
    }];
    [picker setConfirmSelectIndexsCallback:^(NSArray<NSNumber *> * _Nonnull selectIndexArr) {
        NSLog(@"多选选中:%@", selectIndexArr);
    }];
    [picker setConfirmSelectDateCallback:^(NSDate * _Nonnull date) {
        NSLog(@"日期选中%@", date);
    }];
    [picker show];
}

@end
