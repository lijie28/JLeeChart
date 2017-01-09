//
//  LingChartViewController.m
//  JLeeChart
//
//  Created by 李杰 on 2017/1/9.
//  Copyright © 2017年 李杰. All rights reserved.
//

#import "LingChartViewController.h"

#import "JLLineChart.h"

@interface LingChartViewController ()

@property (nonatomic, strong)JLLineChart *lineChart;

@end

@implementation LingChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    NSLog(@"LingChartViewController");
    
    _lineChart = [[JLLineChart alloc]initWithFrame:CGRectMake(0, 350, self.view.bounds.size.width, 150) andTheXmargin:122/2 ];
    _lineChart.backgroundColor = [UIColor clearColor];
    
    //等于12月份
    _lineChart.nameArr = @[@"金",@"木",@"水",@"火",@"木",@"水",@"火",@"木"];
    _lineChart.dataArr =  @[@"0.4",@"0.4",@"0.5",@"0.2",@"0.4",@"0.5",@"0.2",@"0.4"];
    
    [self.view addSubview:_lineChart];
}


@end
