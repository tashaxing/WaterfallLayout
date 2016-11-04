//
//  WaterfallFlowLayout.m
//  WaterfallLayout
//
//  Created by yxhe on 16/11/3.
//  Copyright © 2016年 tashaxing. All rights reserved.
//

#import "WaterfallFlowLayout.h"



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
    // 通过代理传回边距和尺寸d
    UIEdgeInsets edgeInsets = [delegate collectionView:self.collectionView
                                                layout:self
                                insetForSectionAtIndex:indexPath.row];
    CGSize itemSize = [delegate collectionView:self.collectionView
                                        layout:self
                        sizeForItemAtIndexPath:indexPath];
    
    // 找到高度最小的列
    int minCol = 0;
    float minHeight = [colHeightArray[minCol] floatValue];
    
    for (int i = 1; i < colHeightArray.count; i++)
    {
        float tempHeight = [colHeightArray[minCol] floatValue];
        if (tempHeight < minHeight)
        {
            minHeight = tempHeight;
            minCol = i;
        }
    }
    
    // 确定cell的frame
    CGRect frame = CGRectMake(edgeInsets.left + minCol * (edgeInsets.left + itemSize.width), minHeight + edgeInsets.top, itemSize.width, itemSize.height);
    // 存入字典
    [cellAttributeDict setObject:indexPath forKey:NSStringFromCGRect(frame)];
    
    // 更新列高
    [colHeightArray replaceObjectAtIndex:minCol withObject:[NSNumber numberWithFloat:minHeight + edgeInsets.top + itemSize.height]];
}

- (NSArray *)indexPathsOfItem:(CGRect)rect
{
    //遍历布局字典通过CGRectIntersectsRect方法确定每个cell的rect与传入的rect是否有交集，如果结果为true，则此cell应该显示，将布局字典中对应的indexPath加入数组
    NSMutableArray *array = [NSMutableArray array];
    for (NSString *rectStr in cellAttributeDict)
    {
        //每个cell的frame对应一个indexPath，放入在字典_attributeDict中
        CGRect cellRect = CGRectFromString(rectStr);
        if (CGRectIntersectsRect(cellRect, rect))
        {
            NSIndexPath *indexPath = cellAttributeDict[rectStr];
            [array addObject:indexPath];
        }
    }
    return array;
}

#pragma mark - layout代理实现
// 得到cell的总个数，为每个cell确定自己的位置
- (void)prepareLayout
{
    [super prepareLayout];
    
    // 初始化
    colHeightArray = [NSMutableArray array];
    cellAttributeDict = [NSMutableDictionary dictionary];
    
    // 把代理挂到collectionview
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

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *muArr = [NSMutableArray array];
    // indexPathsOfItem方法，根据传入的frame值计算当前应该显示的cell
    NSArray *indexPaths = [self indexPathsOfItem:rect];
    for (NSIndexPath *indexPath in indexPaths)
    {
        UICollectionViewLayoutAttributes *attribute = [self layoutAttributesForItemAtIndexPath:indexPath];
        [muArr addObject:attribute];
    }
    return muArr;
}

- (CGSize)collectionViewContentSize
{
    CGSize contentSize = self.collectionView.frame.size;
    float maxHeight = [[colHeightArray objectAtIndex:0] floatValue];
    //查找最高的列的高度
    for (int i = 0; i < colHeightArray.count; i++)
    {
        float tempHeight = [[colHeightArray objectAtIndex:i] floatValue];
        if (tempHeight > maxHeight)
        {
            maxHeight = tempHeight;
        }
    }
    contentSize.height = maxHeight;
    return contentSize;
}

@end
