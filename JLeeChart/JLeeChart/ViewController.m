//
//  ViewController.m
//  JLeeChart
//
//  Created by 李杰 on 2016/12/14.
//  Copyright © 2016年 李杰. All rights reserved.
//

#import "ViewController.h"
#import "JLRingChart.h"

@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (strong, nonatomic)JLRingChart *bigRing;

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    
    [self setupUICollectionView];

}


- (void)setupUICollectionView{
    //创建一个layout布局类
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    //设置布局方向为垂直流布局
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    //设置每个item的大小为100*100
    layout.itemSize = CGSizeMake(138/2, 41/2);
    
    layout.sectionInset = UIEdgeInsetsMake(29/2 , 13/2,  45/2 , 0);
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,200, 320/2, 420/2) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    //注册item类型
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"firstTypeCell"];
    [_collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    [self.view addSubview:_collectionView];
}
#pragma mark - uicollectionView 代理事件

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"firstTypeCell" forIndexPath:indexPath];
    
    cell.backgroundColor = RING_COLOR_ARR(0.6)[indexPath.row];
    
    return cell;

    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

        
    
    return _bigRing.valueDataArr.count;
        

}


////设置点击 Cell的点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [_bigRing annomationMoveTo:indexPath.row];
    
    
}

@end
