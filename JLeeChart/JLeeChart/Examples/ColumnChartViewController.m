//
//  ColumnChartViewController.m
//  JLeeChart
//
//  Created by 李杰 on 2017/1/9.
//  Copyright © 2017年 李杰. All rights reserved.
//

#import "ColumnChartViewController.h"
#import "JLColumnChart.h"

@interface ColumnChartViewController ()<JLChartColumnDelegate>

@property (nonatomic, strong) JLColumnChart *columnChart;

@property (nonatomic, strong) UILabel *labValue;
@property (nonatomic, strong) UILabel *labTitle;

@end

@implementation ColumnChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _columnChart = [[JLColumnChart alloc]initWithFrame:CGRectMake(0, 350, self.view.bounds.size.width, 328/2) andTheXmargin:124/2 ];
    
    //等于12月份
    _columnChart.nameArr = @[@"金",@"木",@"水",@"火",@"土",@"金",@"木",@"水",@"火",@"土"];
    _columnChart.dataArr =  @[@"0.4",@"0.4",@"0.5",@"0.22",@"0.12",@"0.32",@"0.62",@"0.92",@"0.72",@"0.22"];
    _columnChart.delegate = self;
    
    [self.view addSubview:_columnChart];
}

-(void)columnChart:(JLColumnChart *)columnChart theSelectedItem:(NSInteger)item itemName:(NSString *)itemName itemValue:(NSString *)itemValue
{
//    NSLog(@"columnChart:%@,item:%ld,itemName:%@,itemValue:%@",columnChart,(long)item,itemName,itemValue);
    self.labTitle.text = [NSString stringWithFormat:@"名称  :  %@",itemName] ;
    self.labValue.text = [NSString stringWithFormat:@"值    :  %@",itemValue] ;;
    
}


- (UILabel *)labTitle
{
    if (!_labTitle) {
        _labTitle = [[UILabel alloc] init];
        _labTitle.frame = CGRectMake(100, 100, 100, 50);
        _labTitle.textColor = CHANGE_COLOR;
        [self.view addSubview:_labTitle];
    }
    return _labTitle;
}


- (UILabel *)labValue
{
    if (!_labValue) {
        _labValue = [[UILabel alloc] init];
        _labValue.frame = CGRectMake(100, 150, 100, 50);
        _labValue.textColor = CHANGE_COLOR;
        [self.view addSubview:_labValue];
    }
    return _labValue;
}
@end
