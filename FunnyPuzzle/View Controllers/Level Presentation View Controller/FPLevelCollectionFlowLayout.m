//
//  FPLevelCollectionFlowLayout.m
//  FunnyPuzzle
//
//  Created by Misha on 29.05.14.
//  Copyright (c) 2014 Mobilez365. All rights reserved.
//

#import "FPLevelCollectionFlowLayout.h"

@implementation FPLevelCollectionFlowLayout
-(CGSize)itemSize
{
    CGSize itemSize = CGSizeZero;
    CGSize collectionSize = self.collectionView.frame.size;
    itemSize.height = (collectionSize.height/2)-5;
    itemSize.width = (collectionSize.width/2)-10;
    return itemSize;
}
- (CGFloat)minimumInteritemSpacing
{
    return 2.5f;
}

@end
