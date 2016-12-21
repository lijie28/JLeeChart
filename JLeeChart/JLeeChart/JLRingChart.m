//
//  JLDoubleRingChart.m
//  JLNewRingChart
//
//  Created by 李杰 on 2016/11/17.
//  Copyright © 2016年 JackLee. All rights reserved.
//

#import "JLRingChart.h"

@implementation JLRingChart

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self customLayer];
    }
    
    return self;
}


- (void)customLayer{
    
    _mylayer = [CALayer layer];
    _mylayer.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    [self.layer addSublayer:_mylayer];
}


- (void)setValueDataArr:(NSArray *)valueDataArr
{
    
    _valueDataArr = valueDataArr;
    
    _itemsSpace =  (M_PI * 4.0 * 10 / 360)/_valueDataArr.count ;
    
}



- (void)setFillColorArray:(NSArray *)fillColorArray
{
    _fillColorArray = fillColorArray;
}

-(void)setAngle:(CGFloat)angle
{
    _angle = angle;
}

//画环图的图层
- (void)startToDrawLayer
{
    [self colorArrAndRingWidth];

    [self setupRingLayer];
}

//填充颜色和环图的宽度
- (void)colorArrAndRingWidth{
    
    /*        环图的宽度         */
    if (!_ringWidth) {
        _ringWidth = 25.0;
    }
    
    /*        每段环图的填充颜色         */
    if (!_fillColorArray) {
        _fillColorArray = RING_COLOR_ARR(0.8);
    }
    
    if (!_angle) {
        _angle = -1/2;
    }
}

//画圆环的图层
- (void)setupRingLayer{
    
    _midValueArr = [[NSMutableArray alloc ]init];
    
    CGFloat lastBegin = -( [_valueDataArr[0] floatValue] *M_PI*2/2) + M_PI*_angle;
    
    
    NSInteger  i = 0;
    
    for (id obj in _valueDataArr) {
        
        CAShapeLayer *ringLayer = [CAShapeLayer layer] ;
        
        ringLayer.fillColor = [UIColor clearColor].CGColor;
        
        ringLayer.lineWidth = _ringWidth;
        
        ringLayer.fillColor = [UIColor clearColor].CGColor;
        
        if (i<_fillColorArray.count) {
            
            ringLayer.strokeColor =[_fillColorArray[i] CGColor];
            
        }
        
        CGFloat cuttentpace = [obj floatValue]  * (M_PI * 2 - _itemsSpace * _valueDataArr.count);
        
        UIBezierPath *thePath = [UIBezierPath bezierPath];
        
        
        NSNumber *midValue = [NSNumber numberWithFloat: -(lastBegin + cuttentpace/2) + M_PI*_angle];
        
        [_midValueArr addObject: midValue];
        
        [thePath addArcWithCenter:CGPointMake(_mylayer.frame.size.width/2, _mylayer.frame.size.height/2) radius:_mylayer.frame.size.width/2 - _ringWidth/2  startAngle:lastBegin  endAngle:lastBegin  + cuttentpace clockwise:YES];
        
        ringLayer.path = thePath.CGPath;
        
        [_mylayer addSublayer:ringLayer];
        
        lastBegin += (cuttentpace+_itemsSpace);
        
        i++;
        
    }
    
}



- (void)reloadDatas{
    
    if (_mylayer) {
        
        [_mylayer removeFromSuperlayer];
    }
    
    [self customLayer];
    
    [self startToDrawLayer];
    
    [self annomationMoveTo:0];
    
}



- (void)annomationMoveTo:(NSInteger)item
{
    
    for (int i=0 ; i<_midValueArr.count; i++) {
        
        if (item != self.theOne) {
            
            if (item == i) {
                
                _mylayer.transform = CATransform3DMakeRotation([[_midValueArr objectAtIndex:i]floatValue], 0, 0, 1);
                
            }
        }
    }
    
    self.theOne = item;
}



@end
