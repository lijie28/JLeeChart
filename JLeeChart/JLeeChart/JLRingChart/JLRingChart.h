//
//  JLDoubleRingChart.h
//  JLNewRingChart
//
//  Created by 李杰 on 2016/11/17.
//  Copyright © 2016年 JackLee. All rights reserved.
//


/*             使用示例
 _bigRing = [[JLRingChart alloc]initWithFrame:CGRectMake(0, 0, 230/2, 230/2)];
 _bigRing.center = CGPointMake(200, 300);
 //传入的显示数值，注意总和应等于100%
 _bigRing.valueDataArr = @[@"0.1",@"0.2",@"0.3",@"0.3",@"0.1"];//必须有
 //设置圆环的宽度
 _bigRing.ringWidth = 26;
 //设置圆环的中间点显示角度
 _bigRing.angle = 0;
 //传入所需值后开始画图层
 [_bigRing startToDrawLayer];//必须有
 [self.view addSubview:_bigRing];
 */


#import <UIKit/UIKit.h>

#define kColor(R,G,B,A) [UIColor colorWithRed:R/255.f green:G/255.f blue:B/255.f alpha:A]
//十个自带颜色
#define RING_COLOR_ARR(R) @[kColor(204, 40, 44, R),kColor(242, 144, 75, R),kColor(255, 211, 57, R),kColor(112, 184, 71, R),kColor(0, 164, 171, R),kColor(0, 121, 176, R),kColor(49, 58, 134, R),kColor(139, 42, 125, R),kColor(228, 55, 117, R),kColor(45, 103, 51, R)]


@interface JLRingChart : UIView

//数据源
@property (nonatomic, strong) NSArray *valueDataArr;

//填充颜色
@property (nonatomic, strong) NSArray *fillColorArray;

//环的宽度
@property (nonatomic, assign) CGFloat ringWidth;

//环图间隔 单位为π
@property (nonatomic, assign) CGFloat itemsSpace;

//显示的item中线所在角度
@property (nonatomic, assign) CGFloat angle;

//显示的item中间点
@property (nonatomic, strong, readonly) NSMutableArray *midValueArr;

//圆环底图层
@property (nonatomic, strong, readonly) CALayer *mylayer;

//选中的item，以便KVO观察
@property (nonatomic, assign ) NSInteger theOne;

//开始画圆环图层
- (void)startToDrawLayer;

//重新加载数据
- (void)reloadDatas;

//圆环转到哪个item
- (void)annomationMoveTo:(NSInteger)item;



@end
