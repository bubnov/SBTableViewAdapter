//
//  SFCCollectionViewCell.h
//  SFCCollections
//
//  Created by Bubnov Slavik on 17/11/14.
//  Copyright (c) 2014 Bubnov Slavik, bubnovslavik@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol SFCCollectionViewCell <NSObject>

@property (strong, nonatomic, readonly) id object;

- (void)setObject:(id)object;
- (void)setObject:(id)object heightCalculation:(BOOL)calculation;

@optional

- (CGSize)calculateCellSize;

@end


@interface SFCCollectionViewCell : UICollectionViewCell <SFCCollectionViewCell>

@end
