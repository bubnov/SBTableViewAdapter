//
//  SFCTableViewCell.h
//  SFCCollections
//
//  Created by Bubnov Slavik on 30/07/14.
//  Copyright (c) 2014 Bubnov Slavik, bubnovslavik@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol SFCTableViewCell <NSObject>

@property (strong, nonatomic, readonly) id object;

- (void)setObject:(id)object heightCalculation:(BOOL)calculation;

@optional

- (CGFloat)calculateCellHeight;

@end


@interface SFCTableViewCell : UITableViewCell <SFCTableViewCell>

@end


extern NSString * const kSFCTableViewCellActionDidSelect;