//
//  ViewController.m
//  JLeeChart
//
//  Created by 李杰 on 2017/1/9.
//  Copyright © 2017年 李杰. All rights reserved.
//

#import "HomePageViewController.h"
#import "ChartsExample.h"

#import "RingChartViewController.h"
#import "LingChartViewController.h"
#import "ColumnChartViewController.h"

@interface HomePageViewController ()

@property (nonatomic, strong) NSArray *charts;

@end

@implementation HomePageViewController


- (NSArray *)charts
{
    if (!_charts) {
        _charts = [[NSArray alloc] init];
        
        ChartsExample *chart0 = [[ChartsExample alloc]init];
        chart0.vcClass = [RingChartViewController class];
        chart0.title = @"圆环图";
        
        ChartsExample *chart1 = [[ChartsExample alloc]init];
        chart1.vcClass = [LingChartViewController class];
        chart1.title = @"折线图";
        
        ChartsExample *chart2 = [[ChartsExample alloc]init];
        chart2.vcClass = [ColumnChartViewController class];
        chart2.title = @"柱型图";
        
        
        self.charts = @[chart0,chart1,chart2];
    }
    return _charts;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"JLeeChart";
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *ID = @"charts";
    
    
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
     ;
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];

    ChartsExample *chart = self.charts[indexPath.row];
    cell.textLabel.text = chart.title;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"-%@", chart.vcClass];
    
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.charts.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90/2;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChartsExample *chart = self.charts[indexPath.row];
    UIViewController *vc = [[chart.vcClass alloc] init];
    vc.title = chart.title;
    vc.automaticallyAdjustsScrollViewInsets = NO;
    vc.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
