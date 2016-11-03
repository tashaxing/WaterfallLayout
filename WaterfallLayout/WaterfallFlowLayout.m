//
//  WaterfallFlowLayout.m
//  WaterfallLayout
//
//  Created by yxhe on 16/11/3.
//  Copyright © 2016年 tashaxing. All rights reserved.
//

#import "WaterfallFlowLayout.h"

const int kColNum = 3; // 每行固定列数

@interface WaterfallFlowLayout ()
{
    id<UICollectionViewDelegateFlowLayout> delegate; // 代理
    
    NSInteger totalCellCount;           // cell总数(默认只有一个section)
    NSMutableArray *colHeightArray;      // 每个列的高度
    NSMutableDictionary *cellAttributeDict;   // 每个cell的位置信息
}
@end

@implementation WaterfallFlowLayout


// 为每个cell布局
- (void)layoutItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 通过代理传回
    UIEdgeInsets edgeInsets = [delegate collectionView:self.collectionView
                                                layout:self
                                insetForSectionAtIndex:indexPath.row];
    CGSize itemSize = [delegate collectionView:self.collectionView
                                        layout:self
                        sizeForItemAtIndexPath:indexPath];
}

#pragma mark - layout代理实现
// 得到cell的总个数，为每个cell确定自己的位置
- (void)prepareLayout
{
    [super prepareLayout];
    
    // 初始化
    colHeightArray = [NSMutableArray array];
    cellAttributeDict = [NSMutableDictionary dictionary];
    delegate = (id<UICollectionViewDelegateFlowLayout>)self.collectionView.delegate;
    
    // 获得cell个数
    totalCellCount = [self.collectionView numberOfItemsInSection:0];
    
    for (int i = 0; i < kColNum; i++)
    {
        [colHeightArray addObject:[NSNumber numberWithFloat:0.0f]];
    }
    
    // 循环调用layoutForItemAtIndexPath方法，为每个cell布局，将indexPath传入，作为布局字典的key
    for (int i = 0; i < totalCellCount; i++)
    {
        [self layoutItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
    }
}

@end
