//
//  NewChartView.h
//  JLChartLine
//
//  Created by 李杰 on 16/11/3.
//  Copyright © 2016年 JackLee. All rights reserved.
//

#import <UIKit/UIKit.h>

/*    _chartColumn = [[JLChartColumn alloc]initWithFrame:CGRectMake(0, 350, self.view.bounds.size.width, 328/2) andTheXmargin:124/2 ];
 
 _chartColumn.backgroundColor = kLightGrayColor;
 
 
 //等于12月份
 _chartColumn.nameArr = @[@"金",@"木",@"水",@"火",@"土",@"金",@"木",@"水",@"火",@"土"];
 _chartColumn.dataArr =  @[@"0.4",@"0.4",@"0.5",@"0.22",@"0.12",@"0.32",@"0.62",@"0.92",@"0.72",@"0.22"];
 
 
 [self.view addSubview:_chartColumn];
 */


/*
 屏幕适配
 */
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kWidth(R) (R)*(kScreenWidth)/320
#define kHeight(R) ((R)*(kScreenHeight)/568)

//定义大小
#define frameX(R) R.frame.origin.x
#define frameY(R) R.frame.origin.y
#define frameW(R) R.frame.size.width
#define frameH(R) R.frame.size.height

//布局
#define afterX(R) frameX(R)+frameW(R)
#define afterY(R) frameY(R)+frameH(R)
#define inTheViewMidW(V,R) frameW(V)/2 - kWidth(R)/2
#define inTheScreenMidW(R) kScreenWidth/2 - kWidth(R)/2

//十六进制颜色
#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define kColor(R,G,B,A) [UIColor colorWithRed:R/255.f green:G/255.f blue:B/255.f alpha:A]

#define view_distance 8
#define LAB_COLOR UIColorFromRGB(0X6dabd2)
#define BASE_COLOR kColor(118, 209, 255, 0.5)
#define BASE_COVER_COLOR kColor(118, 209, 255, 0.3)
#define SEC_BASE_COLOR kColor(244, 93, 93, 1)
#define SEC_BASE_COVER_COLOR kColor(244, 93, 93, 0.3)
#define BTN_SIZE 7


#define LAB_WIDTH kWidth(60)
#define LAB_HEIGHT kHeight(30)
#define CHANGE_COLOR kColor(118, 209, 255, 1)

@class JLColumnChart;
/**       JLChartColumnDelegate代理       */
@protocol JLChartColumnDelegate <NSObject>

@optional
- (void)columnChart:(JLColumnChart *)columnChart theSelectedItem:(NSInteger)item  itemName:(NSString *)itemName itemValue:(NSString *)itemValue;

@end



@interface theSelectedColunm : NSObject

@property (strong, nonatomic) UIView *viewColumn;
@property (strong, nonatomic) UILabel *percentage;
@property (strong, nonatomic) UILabel *title;

@end


@interface JLColumnChart : UIView

@property (nonatomic, weak)   id<JLChartColumnDelegate> delegate;
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, strong) NSArray *nameArr;
@property (nonatomic, assign) NSInteger theOne;

-(instancetype)initWithFrame:(CGRect)frame andTheXmargin:(CGFloat)x ;



@end

