//
//  ViewController.m
//  WaterfallLayout
//
//  Created by yxhe on 16/11/2.
//  Copyright © 2016年 tashaxing. All rights reserved.
//
// ---- 简单瀑布流的实现 ---- //

#import "ViewController.h"
#import "WaterfallFlowLayout.h"
#import "WaterfallCollectionViewCell.h"

#define kWaterfallCell @"WaterfallCell"

@interface ViewController ()<UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>
{
    NSMutableArray *picArray; // 图片数组
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 数据
    picArray = [NSMutableArray array];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"pic.plist" ofType:nil];
    NSArray *imageDicts = [NSArray arrayWithContentsOfFile:path];
    for (NSDictionary *imageDict in imageDicts)
    {
        NSString *imgURL = [imageDict objectForKey:@"img"];
        [picArray addObject:imgURL];
    }

    // 格子控件
    WaterfallFlowLayout *flowLayout = [[WaterfallFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) collectionViewLayout:flowLayout];
    collectionView.backgroundColor = [UIColor greenColor];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    
    [collectionView registerClass:[WaterfallCollectionViewCell class] forCellWithReuseIdentifier:kWaterfallCell];
    [self.view addSubview:collectionView];
    [collectionView reloadData];
}

#pragma mark - collectionview代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return picArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WaterfallCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kWaterfallCell forIndexPath:indexPath];
    if (!cell)
    {
        cell = [[WaterfallCollectionViewCell alloc] init];
    }
    
    // 设置网络图片
//    NSString *urlStr = picArray[indexPath.item]; // 得到该section里面的索引
//    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlStr]];
//    cell.cellImage = [UIImage imageWithData:data];
    
    // 设置本地图片
    NSString *localPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%ld.jpg", indexPath.item + 1] ofType:nil];
    cell.cellImage = [UIImage imageNamed:localPath];
    
    return cell;
}


#pragma mark - flowlayout代理
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 网络图片
//    NSString *urlStr = picArray[indexPath.item];
//    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlStr]];
//    UIImage *img = [UIImage imageWithData:data];
    
    // 本地图片
    NSString *localPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%ld.jpg", indexPath.item + 1] ofType:nil];
    UIImage *img = [UIImage imageNamed:localPath];
    
    // 根据内容尺寸调整
    CGFloat itemWidth = collectionView.frame.size.width / kColNum;
    CGFloat itemHeight = img.size.height / img.size.width * itemWidth;
    
    return CGSizeMake(itemWidth, itemHeight);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    UIEdgeInsets edgeInsets = {5,5,5,5};
    return edgeInsets;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
