//
//  NewChartView.m
//  JLChartLine
//
//  Created by 李杰 on 16/11/3.
//  Copyright © 2016年 JackLee. All rights reserved.
//


#import "JLColumnChart.h"
//#import "theSelectedColunm.h"




@interface JLColumnChart ()<UIScrollViewDelegate>

//X轴方向的偏移
@property (nonatomic, assign) CGFloat Xmargin;
//Y轴方向的偏移
@property (nonatomic, assign) CGFloat Ymargin;

@property (nonatomic, assign) NSInteger num;

@property (nonatomic, strong) UIScrollView *chartScrollView;
/** 承载柱型图的背景图 */
@property (nonatomic, strong) UIView *bgView;
/** 数据源          */
@property (nonatomic, strong) NSMutableArray *pointArr;
/** 柱的数组         */
@property (nonatomic, strong) NSMutableArray *tscArr;

@property (nonatomic, strong) theSelectedColunm *tsc;


@end

@implementation JLColumnChart


-(UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc]initWithFrame:CGRectMake((self.frame.size.width )/2 -view_distance, LAB_HEIGHT, (_num-1)*_Xmargin, self.chartScrollView.frame.size.height-LAB_HEIGHT)];
    }
    
    return _bgView;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.pointArr = [NSMutableArray array];
        self.tscArr = [NSMutableArray array];
        
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame andTheXmargin:(CGFloat)x {
    if (self = [super initWithFrame:frame]) {
        
        _Xmargin = x;
        self.pointArr = [NSMutableArray array];
        self.tscArr = [NSMutableArray array];
        
    }
    
    return self;
    
    
}

//*******************数据源************************//

- (void)setDataArr:(NSArray *)dataArr{
    
    _dataArr = dataArr;
    
    [self setupTheContentView];
}

- (void)setNameArr:(NSArray *)nameArr{
    
    
    
    _nameArr = nameArr;
    
    [self setupTheContentView];
}

- (void)setupTheContentView
{
    if (_dataArr&&_nameArr&&(_dataArr.count == _nameArr.count)&&_Xmargin) {
        
        _num = [[NSNumber numberWithInteger:_nameArr.count]intValue] ;
        
        self.theOne = [[NSNumber numberWithFloat:_nameArr.count/2]intValue]  ;
        
        [self addDetailViews];
        
        CGFloat magrginHeight = (self.bgView.bounds.size.height)/5;
        
        _Ymargin = magrginHeight;
        
        
        [self addDataPointWith:self.bgView andArr:_dataArr];//添加点
    }
    
    
    
}


//*******************分割线************************//
-(void)addDetailViews{
    
    
    self.chartScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(view_distance, 0, self.bounds.size.width - 2*view_distance, self.bounds.size.height)];
    
    self.chartScrollView.contentOffset = CGPointMake((self.theOne)*_Xmargin, 0);
    self.chartScrollView.backgroundColor = [UIColor clearColor];
    self.chartScrollView.delegate = self;
    self.chartScrollView.showsHorizontalScrollIndicator = NO;
    self.chartScrollView.contentSize = CGSizeMake((_num-1)*_Xmargin +self.chartScrollView.frame.size.width, 0);
    
    [self addSubview:self.chartScrollView];
    
    
    [self.chartScrollView addSubview:self.bgView];
    
    UIView *viewLine = [[UIView alloc]initWithFrame:CGRectMake(self.frame.size.width/2 -LAB_WIDTH/2, self.frame.size.height -1, LAB_WIDTH, 1)];
    viewLine.backgroundColor = CHANGE_COLOR;
    [self addSubview:viewLine];
}


-(void)addDataPointWith:(UIView *)view andArr:(NSArray *)dataArr{
    
    
    CGFloat height = self.bgView.bounds.size.height;
    
    //初始点
    NSMutableArray *arr = [NSMutableArray arrayWithArray:dataArr];
    
    
    for (int i = 0; i<arr.count; i++) {
        
        _tsc = [[theSelectedColunm alloc]init];
        
        UIView *viewColumn = [[UIView alloc]initWithFrame:CGRectMake((_Xmargin)*i -kWidth(53/2)/2,(1- [arr[i] floatValue])* height, kWidth(53/2), [arr[i] floatValue]* height)];
        viewColumn.backgroundColor = BASE_COLOR;
        viewColumn.tag = i;
        
        UILabel *labPercentage = [[UILabel alloc]initWithFrame:CGRectMake((_Xmargin)*i - _Xmargin/2,frameY(viewColumn)-kHeight(38/2), _Xmargin, kHeight(38/2))];
        labPercentage.textAlignment = NSTextAlignmentCenter;
        labPercentage.font = [UIFont systemFontOfSize:11.0f];
        labPercentage.textColor = BASE_COLOR;
        labPercentage.text = [NSString stringWithFormat:@"%.0f%s",[arr[i]floatValue] *100,"%" ];
        labPercentage.tag = i ;
        
        
        //底部字体
        UILabel *labTitle = [[UILabel alloc]initWithFrame:CGRectMake(i*_Xmargin-LAB_WIDTH/2, 5*_Ymargin, LAB_WIDTH, LAB_HEIGHT)];
        labTitle.textColor = BASE_COLOR;
        labTitle.backgroundColor= [UIColor clearColor];
        labTitle.font = [UIFont systemFontOfSize:11.0f];
        labTitle.text = _nameArr[i];
        labTitle.textAlignment = NSTextAlignmentCenter;
        
        if (i == self.theOne) {
            viewColumn.backgroundColor = CHANGE_COLOR;
            labPercentage.textColor = CHANGE_COLOR;
            labTitle.textColor = CHANGE_COLOR;
        }
        
        _tsc.viewColumn = viewColumn;
        _tsc.percentage = labPercentage;
        _tsc.title = labTitle;
        
        [self.tscArr addObject:_tsc];
    }
    
    
    for (int i = 0; i<self.tscArr.count; i++) {
        theSelectedColunm *view = self.tscArr [i] ;
        [self.bgView addSubview:view.percentage];
        [self.bgView addSubview:view.viewColumn];
        [self.bgView addSubview:view.title];
    }
}






#pragma mark - scrollView 代理事件

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //    NSLog(@"停步拖动了");
    
//    _theOne = 0 ;
    for (int i = 0; i<_num; i++) {
        
        if (scrollView.contentOffset.x >=(i)*_Xmargin +_Xmargin/2  && scrollView.contentOffset.x< (i+1)*_Xmargin) {
            
            [scrollView setContentOffset:CGPointMake((i+1) * _Xmargin, 0) animated:YES];
            self.theOne = i+1;
        }
        else if (scrollView.contentOffset.x >=(i)*_Xmargin   && scrollView.contentOffset.x< (i)*_Xmargin +_Xmargin/2) {
            
            [scrollView setContentOffset:CGPointMake((i) * _Xmargin, 0) animated:YES];
            self.theOne = i;
        }
    }
    
//    NSLog(@"停止拖动了,到了第%d个 ",self.theOne);
    for (int i = 0; i<self.tscArr.count; i++) {
        theSelectedColunm *view = self.tscArr [i] ;
        if (i == self.theOne) {
            view.percentage.textColor = CHANGE_COLOR;
            view.viewColumn.backgroundColor = CHANGE_COLOR;
            view.title.textColor = CHANGE_COLOR;
            
            //响应代理
            if ([self.delegate respondsToSelector:@selector(columnChart:theSelectedItem:itemName:itemValue:)]) {
                [self.delegate columnChart:self theSelectedItem:self.theOne itemName:view.title.text itemValue:view.percentage.text];
            }
        }else{
            view.percentage.textColor = BASE_COLOR;
            view.viewColumn.backgroundColor = BASE_COLOR;
            view.title.textColor = BASE_COLOR;
            
        }
    }
    
    
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    
//    _theOne = 0 ;
    
    for (int i = 0; i<_num; i++) {
        
        if (scrollView.contentOffset.x >=(i)*_Xmargin +_Xmargin/2  && scrollView.contentOffset.x< (i+1)*_Xmargin) {
            
            [scrollView setContentOffset:CGPointMake((i+1) * _Xmargin, 0) animated:YES];
//            NSLog(@"停止滚动了,到了第%d个 上",i+1);
            self.theOne = i+1;
        }
        else if (scrollView.contentOffset.x >=(i)*_Xmargin   && scrollView.contentOffset.x< (i)*_Xmargin +_Xmargin/2) {
            
            [scrollView setContentOffset:CGPointMake((i) * _Xmargin, 0) animated:YES];
//            NSLog(@"停止滚动了,到了第%d个 下",i);
            self.theOne = i;
        }
    }
    
//    NSLog(@"停止滚动了,到了第%d个 ",self.theOne);
    for (int i = 0; i<self.tscArr.count; i++) {
        theSelectedColunm *view = self.tscArr [i] ;
        if (i == self.theOne) {
            view.percentage.textColor = CHANGE_COLOR;
            view.viewColumn.backgroundColor = CHANGE_COLOR;
            view.title.textColor = CHANGE_COLOR;
            
            //响应代理
            if ([self.delegate respondsToSelector:@selector(columnChart:theSelectedItem:itemName:itemValue:)]) {
                [self.delegate columnChart:self theSelectedItem:self.theOne itemName:view.title.text itemValue:view.percentage.text];
            }
        }else{
            view.percentage.textColor = BASE_COLOR;
            view.viewColumn.backgroundColor = BASE_COLOR;
            view.title.textColor = BASE_COLOR;
        }
    }
    
}

@end



@implementation theSelectedColunm

@end
