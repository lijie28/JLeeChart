//
//  NewChartView.m
//  JLChartLine
//
//  Created by 李杰 on 16/11/3.
//  Copyright © 2016年 JackLee. All rights reserved.
//


#import "JLLineChart.h"


@interface JLLineChart ()<UIScrollViewDelegate>
{
//    CGFloat currentPage;//当前页数
    CGFloat Xmargin;//X轴方向的偏移
    CGFloat Ymargin;//Y轴方向的偏移
    CGPoint lastPoint;//最后一个坐标点
//    UIButton *firstBtn;
    
}

@property (nonatomic,strong)UIScrollView *chartScrollView;
@property (nonatomic,strong)UIView *bgView;//背景图
@property (nonatomic,strong)NSMutableArray *pointArr;//数据源
@property (nonatomic,strong)NSMutableArray *secPointArr;//数据源
@property (nonatomic,strong)NSMutableArray *btnArr;//左边按钮
@property (nonatomic,strong)NSMutableArray *secBtnArr;//左边按钮


@end

@implementation JLLineChart


- (NSInteger)num
{
    if (!_num) {
        _num = [[NSNumber numberWithInteger:_dataArr.count]intValue];
//        self.theOne = [[NSNumber numberWithFloat:_dataArr.count/2]intValue]  ;
    }
    return _num;
}

- (NSInteger)theOne
{
    if (!_theOne) {
        //这里不可懒加载
//        self.num = [[NSNumber numberWithInteger:_dataArr.count]intValue];
//        _theOne = [[NSNumber numberWithFloat:_dataArr.count/2]intValue]  ;
    }
    return _theOne;
}


-(UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc]initWithFrame:CGRectMake((self.frame.size.width )/2 -view_distance - BTN_SIZE/2, 0, (self.num-1)*Xmargin, self.chartScrollView.bounds.size.height-LAB_HEIGHT)];
    }
    
    return _bgView;
}

-(instancetype)initWithFrame:(CGRect)frame andTheXmargin:(CGFloat)x {
    if (self = [super initWithFrame:frame]) {
        
        Xmargin = x;
        self.pointArr = [NSMutableArray array];
        self.btnArr = [NSMutableArray array];
        
        self.secPointArr = [NSMutableArray array];
        self.secBtnArr = [NSMutableArray array];
    }
    
    return self;
    
    
}

//*******************数据源************************//

-(void)setDataArr:(NSArray *)dataArr{
    
    _dataArr = dataArr;
    
    if (_dataArr != nil && _nameArr!= nil) {
        
        
        [self addDetailViews];
        
        
        CGFloat magrginHeight = (self.bgView.bounds.size.height)/5;
        
        Ymargin = magrginHeight;
        
        //添加底部月份
        [self addBottomViewsWith:self.bgView andArr:_nameArr];
        
        [self addDataPointWith:self.bgView andArr:_dataArr];//添加点
        
        [self addBezierPoint:_dataArr];//添加连线
    }
    
}

- (void)setSecDataArr:(NSArray *)secDataArr{
    _secDataArr = secDataArr;
    
    [self addDataPointWith:self.bgView andArr:_secDataArr];//添加点
    
    [self addBezierPoint:_secDataArr];//添加连线
}

-(void)setNameArr:(NSArray *)nameArr{
    
    
    _nameArr = nameArr;
    
    
    if (_dataArr != nil && _nameArr!= nil) {
        
        
        [self addDetailViews];
        
        
        CGFloat magrginHeight = (self.bgView.bounds.size.height)/5;
        
        Ymargin = magrginHeight;
        
        //添加底部月份
        [self addBottomViewsWith:self.bgView andArr:_nameArr];
        
        [self addDataPointWith:self.bgView andArr:_dataArr];//添加点
        
        [self addBezierPoint:_dataArr];//添加连线
    }
}


//*******************分割线************************//
-(void)addDetailViews{
    
    
    
    self.chartScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(view_distance, 0, self.bounds.size.width - 2*view_distance, self.bounds.size.height)];
    
    
    self.chartScrollView.contentOffset = CGPointMake((self.theOne)*Xmargin, 0);
    self.chartScrollView.delegate = self;
    self.chartScrollView.showsHorizontalScrollIndicator = NO;
    self.chartScrollView.contentSize = CGSizeMake((self.num-1)*Xmargin +self.chartScrollView.frame.size.width, 0);
    
    [self addSubview:self.chartScrollView];
    
    
    [self.chartScrollView addSubview:self.bgView];
    
    
    
    
    UIView *viewLine = [[UIView alloc]initWithFrame:CGRectMake(frameW(self)/2 -Xmargin/2, frameH(self) -kHeight(1), Xmargin, kHeight(1))];
    viewLine.backgroundColor = BASE_COLOR;
    [self addSubview:viewLine];
    
}


//添加的坐标线
-(void)addBezierPoint:(NSArray *)dataArr{
    
    if (dataArr == _dataArr) {
        [self firstPointArr];
    }else if (dataArr == _secDataArr) {
        [self secondPointArr];
    }
    
}

- (void)firstPointArr{
    
    //取得起始点
    CGPoint p1 = [[self.pointArr objectAtIndex:0] CGPointValue];
    
//    NSLog(@"起始点 %f %f",p1.x,p1.y);
    
    //直线的连线
    UIBezierPath *beizer = [UIBezierPath bezierPath];
    [beizer moveToPoint:p1];
    
    //遮罩层的形状
    UIBezierPath *bezier1 = [UIBezierPath bezierPath];
    bezier1.lineCapStyle = kCGLineCapRound;
    bezier1.lineJoinStyle = kCGLineJoinMiter;
    [bezier1 moveToPoint:p1];
    
    CGFloat bgViewHeight = self.bgView.bounds.size.height;
    
    for (int i = 0;i<self.pointArr.count;i++ ) {
        
        if (i != 0) {
            
            CGPoint point = [[self.pointArr objectAtIndex:i] CGPointValue];
            
//            NSLog(@"连接到了 %f %f",point.x,point.y);
            [beizer addLineToPoint:point];
            
            [bezier1 addLineToPoint:point];
            
            if (i == self.pointArr.count -1) {
                
                [beizer moveToPoint:CGPointMake(Xmargin * (self.pointArr.count-1), bgViewHeight)];//添加连线
                lastPoint = CGPointMake(Xmargin * (self.pointArr.count-1), bgViewHeight);
            }
        }
        
    }
    
    
    //获取最后一个点的X值
    CGFloat lastPointX = lastPoint.x;
    
    //最后一个点对应的X轴的值
    
    CGPoint lastPointX1 = CGPointMake(lastPointX, bgViewHeight);
    
    [bezier1 addLineToPoint:lastPointX1];
    
    //回到原点
    
    [bezier1 addLineToPoint:CGPointMake(p1.x, bgViewHeight)];
    
    [bezier1 addLineToPoint:p1];
    
    
    //遮罩层
    CAShapeLayer *shadeLayer = [CAShapeLayer layer];
    shadeLayer.path = bezier1.CGPath;
    
    //渐变图层
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(5, 0, 0, self.chartScrollView.bounds.size.height-LAB_HEIGHT);
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    gradientLayer.cornerRadius = 5;
    gradientLayer.masksToBounds = YES;
    gradientLayer.colors = @[(__bridge id)BASE_COVER_COLOR.CGColor,(__bridge id)[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0].CGColor];
    gradientLayer.locations = @[@(0.5f)];
    
    
    CALayer *baseLayer = [CALayer layer];
    [baseLayer addSublayer:gradientLayer];
    [baseLayer setMask:shadeLayer];
    [self.bgView.layer addSublayer:baseLayer];
    
    
    CABasicAnimation *anmi1 = [CABasicAnimation animation];
    anmi1.keyPath = @"bounds";
    anmi1.duration = 0;
    anmi1.toValue = [NSValue valueWithCGRect:CGRectMake(BTN_SIZE, 0, 2*lastPoint.x -BTN_SIZE, self.chartScrollView.bounds.size.height-LAB_HEIGHT)];
    anmi1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    anmi1.fillMode = kCAFillModeForwards;
    anmi1.autoreverses = NO;
    anmi1.removedOnCompletion = NO;
    [gradientLayer addAnimation:anmi1 forKey:@"bounds"];
    
    
    //*****************添加动画连线******************//
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = beizer.CGPath;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.strokeColor = BASE_COLOR.CGColor;
    shapeLayer.lineWidth = 2;
    [self.bgView.layer addSublayer:shapeLayer];
    //
    //
    //    CABasicAnimation *anmi = [CABasicAnimation animation];
    //    anmi.keyPath = @"strokeEnd";
    //    anmi.fromValue = [NSNumber numberWithFloat:0];
    //    anmi.toValue = [NSNumber numberWithFloat:1.0f];
    //    anmi.duration = 5;
    //    anmi.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    //    anmi.autoreverses = NO;
    //
    //    [shapeLayer addAnimation:anmi forKey:@"stroke"];
    
    for (UIButton *btn in self.btnArr) {
        [self.bgView addSubview:btn];
    }

}


- (void)secondPointArr{
    
    //取得起始点
    CGPoint p1 = [[self.secPointArr objectAtIndex:0] CGPointValue];
    
//    NSLog(@"第二个起始点 %f %f %@",p1.x,p1.y,self.secPointArr);
    
    //直线的连线
    UIBezierPath *beizer = [UIBezierPath bezierPath];
    [beizer moveToPoint:p1];
    
    //遮罩层的形状
    UIBezierPath *bezier1 = [UIBezierPath bezierPath];
    bezier1.lineCapStyle = kCGLineCapRound;
    bezier1.lineJoinStyle = kCGLineJoinMiter;
    [bezier1 moveToPoint:p1];
    
    CGFloat bgViewHeight = self.bgView.bounds.size.height;
    
    for (int i = 0;i<self.secPointArr.count;i++ ) {
        
        if (i != 0) {
            
            CGPoint point = [[self.secPointArr objectAtIndex:i] CGPointValue];
            
//            NSLog(@"第二个连接到了 %f %f",point.x,point.y);
            [beizer addLineToPoint:point];
            
            [bezier1 addLineToPoint:point];
            
            if (i == self.secPointArr.count -1) {
                
                [beizer moveToPoint:CGPointMake(Xmargin * (self.secPointArr.count-1), bgViewHeight)];//添加连线
                lastPoint = CGPointMake(Xmargin * (self.secPointArr.count-1), bgViewHeight);
            }
        }
        
    }
    
    
    //获取最后一个点的X值
    CGFloat lastPointX = lastPoint.x;
    
    //最后一个点对应的X轴的值
    
    CGPoint lastPointX1 = CGPointMake(lastPointX, bgViewHeight);
    
    [bezier1 addLineToPoint:lastPointX1];
    
    //回到原点
    
    [bezier1 addLineToPoint:CGPointMake(p1.x, bgViewHeight)];
    
    [bezier1 addLineToPoint:p1];
    
    
    //遮罩层
    CAShapeLayer *shadeLayer = [CAShapeLayer layer];
    shadeLayer.path = bezier1.CGPath;
    
    //渐变图层
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(5, 0, 0, self.chartScrollView.bounds.size.height-LAB_HEIGHT);
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    gradientLayer.cornerRadius = 5;
    gradientLayer.masksToBounds = YES;
    gradientLayer.colors = @[(__bridge id)SEC_BASE_COVER_COLOR.CGColor,(__bridge id)[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0].CGColor];
    gradientLayer.locations = @[@(0.5f)];
    
    
    CALayer *baseLayer = [CALayer layer];
    [baseLayer addSublayer:gradientLayer];
    [baseLayer setMask:shadeLayer];
    [self.bgView.layer addSublayer:baseLayer];
    
    
    CABasicAnimation *anmi1 = [CABasicAnimation animation];
    anmi1.keyPath = @"bounds";
    anmi1.duration = 0;
    anmi1.toValue = [NSValue valueWithCGRect:CGRectMake(BTN_SIZE, 0, 2*lastPoint.x -BTN_SIZE, self.chartScrollView.bounds.size.height-LAB_HEIGHT)];
    anmi1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    anmi1.fillMode = kCAFillModeForwards;
    anmi1.autoreverses = NO;
    anmi1.removedOnCompletion = NO;
    [gradientLayer addAnimation:anmi1 forKey:@"bounds"];
    
    
    //*****************添加动画连线******************//
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = beizer.CGPath;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.strokeColor = SEC_BASE_COLOR.CGColor;
    shapeLayer.lineWidth = 2;
    [self.bgView.layer addSublayer:shapeLayer];
    
    for (UIButton *btn in self.secBtnArr) {
        [self.bgView addSubview:btn];
    }
    
}

-(void)addDataPointWith:(UIView *)view andArr:(NSArray *)data{
    
    
    CGFloat height = self.bgView.bounds.size.height;
    
    //初始点
    NSMutableArray *arr = [NSMutableArray arrayWithArray:data];
    
    for (int i = 0; i<arr.count; i++) {
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake((Xmargin)*i - BTN_SIZE/2,(1- [arr[i] floatValue])* height, BTN_SIZE, BTN_SIZE)];
        btn.backgroundColor = BASE_COLOR;
        if (data == _secDataArr) {
            btn.backgroundColor = SEC_BASE_COLOR;
            
//            NSLog(@"第二个按钮颜色");
        }
        btn.layer.cornerRadius = 4;
        btn.layer.masksToBounds = YES;
        btn.tag = i;
        
        NSValue *point = [NSValue valueWithCGPoint:btn.center];
        
        if (data == _dataArr) {
            [self.btnArr addObject:btn];
            
            [self.pointArr addObject:point];
            
//            NSLog(@"第一个数组加点：%@",point);
            
        }else if (data == _secDataArr){
            
            [self.secBtnArr addObject:btn];
            
            [self.secPointArr addObject:point];
            
//            NSLog(@"第二个数组加点：%@",point);
        }
        
        
    }
    
    
}




-(void)addBottomViewsWith:(UIView *)UIView andArr:(NSArray *)bottomArr
{
    
    
    for (int i = 0;i<bottomArr.count ;i++ ) {
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(i*Xmargin-Xmargin/2, 5*Ymargin, Xmargin, LAB_HEIGHT)];
        label.textColor = LAB_COLOR;
//        label.backgroundColor= [UIColor yellowColor];
        label.font = [UIFont systemFontOfSize:10];
        label.text = bottomArr[i];
        label.textAlignment = NSTextAlignmentCenter;
        [UIView addSubview:label];
        
    }
    
}


#pragma mark - SCROLLVIEW代理


-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
//    NSLog(@"scrollView.contentOffset.x:%f",scrollView.contentOffset.x);
    for (int i = 0; i<self.num -1; i++) {
        
            if (scrollView.contentOffset.x >=(i)*Xmargin +Xmargin/2  && scrollView.contentOffset.x< (i+1)*Xmargin) {
                
                [scrollView setContentOffset:CGPointMake((i+1) * Xmargin, 0) animated:YES];
                
                self.theOne = i+1;
                
            }
        
            else if (scrollView.contentOffset.x >=(i)*Xmargin   && scrollView.contentOffset.x< (i)*Xmargin +Xmargin/2) {
                
                [scrollView setContentOffset:CGPointMake((i) * Xmargin, 0) animated:YES];
                
                self.theOne = i ;
                
            }
            else if (scrollView.contentOffset.x < 0) {
                
                [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
                
                self.theOne = 0;
                
                
            }
        
        
    }
    
    NSLog(@"停止拖动了,到了第%ld个 ",(long)self.theOne);
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    for (int i = 0; i<self.num -1; i++) {
        
        if (scrollView.contentOffset.x >=(i)*Xmargin +Xmargin/2  && scrollView.contentOffset.x< (i+1)*Xmargin) {
            
            [scrollView setContentOffset:CGPointMake((i+1) * Xmargin, 0) animated:YES];
            self.theOne = i+1 ;
        }
        else if (scrollView.contentOffset.x >=(i)*Xmargin   && scrollView.contentOffset.x< (i)*Xmargin +Xmargin/2) {
            
            [scrollView setContentOffset:CGPointMake((i) * Xmargin, 0) animated:YES];
            self.theOne = i ;
        }
        else if (scrollView.contentOffset.x < 0) {
            
            [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            
            self.theOne = 0;
            
        }
        
        NSLog(@"停止滚动了,到了第%ld个 ",(long)self.theOne);
    }
    
}

@end
