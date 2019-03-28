//
//  ViewController.m
//  BKPickerView
//
//  Created by zhaolin on 2019/1/23.
//  Copyright © 2019年 BIKE. All rights reserved.
//

#import "ViewController.h"
#import "BKPickerView.h"

@interface ViewController ()

@property (nonatomic,copy) NSArray * dataArr1;
@property (nonatomic,copy) NSArray * dataArr2;
@property (nonatomic,copy) NSArray * dataArr3;
@property (nonatomic,copy) NSArray * dataArr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.dataArr1 = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0"];
    self.dataArr2 = @[@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"10"];
    self.dataArr3 = @[@"24",@"25",@"26",@"27"];
    self.dataArr = @[self.dataArr1, self.dataArr2 , self.dataArr3];
    
    UIButton * button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame = CGRectMake(0, 100, self.view.frame.size.width, 100);
    [button1 setTitle:@"单选" forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button1.titleLabel.font = [UIFont systemFontOfSize:18];
    [button1 addTarget:self action:@selector(button1Click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
    
    UIButton * button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame = CGRectMake(0, CGRectGetMaxY(button1.frame), self.view.frame.size.width, 100);
    [button2 setTitle:@"多级联动" forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button2.titleLabel.font = [UIFont systemFontOfSize:18];
    [button2 addTarget:self action:@selector(button2Click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
    
    UIButton * button3 = [UIButton buttonWithType:UIButtonTypeCustom];
    button3.frame = CGRectMake(0, CGRectGetMaxY(button2.frame), self.view.frame.size.width, 100);
    [button3 setTitle:@"时间" forState:UIControlStateNormal];
    [button3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button3.titleLabel.font = [UIFont systemFontOfSize:18];
    [button3 addTarget:self action:@selector(button3Click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button3];
}

-(void)button1Click
{
    BKPickerView * picker = [[BKPickerView alloc] initWithPickerDataArr:self.dataArr1 remind:@"单选"];
    picker.selectIndex = 1;
    [picker setConfirmSelectCallback:^(NSInteger selectIndex) {
        NSLog(@"选中了第%ld个,值为:%@", selectIndex, self.dataArr1[selectIndex]);
    }];
    [picker show];
}

-(void)button2Click
{
    BKPickerView * picker = [[BKPickerView alloc] initWithPickerDataArr:self.dataArr remind:@"多级联动"];
    __weak typeof(self) weakSelf = self;
    [picker setChangeSelectIndexsCallback:^NSArray * _Nonnull(BKPickerView * _Nonnull pickerView, NSArray<NSNumber *> * _Nonnull selectIndexArr) {
        NSUInteger ofSelectIndex = [pickerView.selectIndexArr[0] integerValue];
        NSUInteger fSelectIndex = [selectIndexArr[0] integerValue];
        if (ofSelectIndex != fSelectIndex) {
            if (fSelectIndex == 1) {
                weakSelf.dataArr = @[weakSelf.dataArr1, weakSelf.dataArr3 , weakSelf.dataArr3];
            }else {
                weakSelf.dataArr = @[weakSelf.dataArr1, weakSelf.dataArr2 , weakSelf.dataArr3];
            }
        }
        return weakSelf.dataArr;
    }];
    [picker setConfirmSelectIndexsCallback:^(NSArray<NSNumber *> * _Nonnull selectIndexArr) {
        for (int i = 0; i < [selectIndexArr count]; i++) {
            NSUInteger selectIndex = [selectIndexArr[i] integerValue];
            NSLog(@"第%d列选中了第%ld个,值为:%@", i, selectIndex, self.dataArr[i][selectIndex]);
        }
    }];
    [picker show];
}

-(void)button3Click
{
    NSDate * minDate = [NSDate dateWithTimeIntervalSince1970:1490084377];//2017-03-21 16:19:37
    NSDate * maxDate = [NSDate dateWithTimeIntervalSince1970:1582855200];//2020-02-28 10:00:00
    BKPickerView * picker = [[BKPickerView alloc] initWithPickerDateStyle:BKPickerDateStyleDisplayYear | BKPickerDateStyleDisplayMonth | BKPickerDateStyleDisplayDay | BKPickerDateStyleDisplayHour | BKPickerDateStyleDisplayMinute | BKPickerDateStyleDisplaySecond selectDate:[NSDate date] maxDate:maxDate minDate:minDate remind:@"选择时间"];
    [picker setConfirmSelectDateCallback:^(NSDate * _Nonnull date) {
        NSLog(@"选取的时间:%@",date);
    }];
    [picker show];
}

@end
