//
//  SFCCollectionItem.h
//  SFCCollections
//
//  Created by Bubnov Slavik on 17/11/14.
//  Copyright (c) 2014 Bubnov Slavik, bubnovslavik@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFCCollectionViewCell.h"


@interface SFCCollectionItem : NSObject

@property (copy, nonatomic) void (^actionHandler)(UICollectionViewCell<SFCCollectionViewCell> *cell, id action, id userInfo);
@property (copy, nonatomic) void (^didDisplayCellBlock)(UICollectionViewCell<SFCCollectionViewCell> *cell);
@property (copy, nonatomic) void (^willDisplayCellBlock)(UICollectionViewCell<SFCCollectionViewCell> *cell);
@property (copy, nonatomic) NSString *cellID;
@property (nonatomic) BOOL useOffscreenCellHeightCalculation;
@property (nonatomic) CGSize cellSize;
@property (strong, nonatomic) id userInfo;

+ (instancetype)itemWithCellID:(NSString *)cellID;

// Declare in the sake of xcode autocompletion correctness
- (void)setActionHandler:(void (^)(UICollectionViewCell<SFCCollectionViewCell> *cell, id action, id userInfo))actionHandler;
- (void)setWillDisplayCellBlock:(void (^)(UICollectionViewCell<SFCCollectionViewCell> *cell))willDisplayCellBlock;
- (void)setDidDisplayCellBlock:(void (^)(UICollectionViewCell<SFCCollectionViewCell> *cell))didDisplayCellBlock;

@end
