//
//  WaterfallCollectionViewCell.m
//  WaterfallLayout
//
//  Created by yxhe on 16/11/3.
//  Copyright © 2016年 tashaxing. All rights reserved.
//

#import "WaterfallCollectionViewCell.h"

@implementation WaterfallCollectionViewCell

// 外部设置图片
- (void)setCellImage:(UIImage *)cellImage
{
    // 重设图片
    if (_cellImage != cellImage)
    {
        _cellImage = cellImage;
    }
    // 重绘
    [self setNeedsDisplay];
}

// 将内容画上去（也可以用addsubview）但是这样比较高效
- (void)drawRect:(CGRect)rect
{
    // 定宽，根据比例缩放图片
//    CGFloat width = self.frame.size.width;
    CGFloat width = kCellWidth;
    CGFloat height = width * _cellImage.size.height / _cellImage.size.width;
    
    // 绘图
    [self.cellImage drawInRect:CGRectMake(0, 0, width, height)];
}

@end
