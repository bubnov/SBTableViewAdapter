//
//  SFCTableItem.h
//  SFCCollections
//
//  Created by Bubnov Slavik on 29/07/14.
//  Copyright (c) 2014 Bubnov Slavik, bubnovslavik@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFCTableViewCell.h"


@interface SFCTableItem : NSObject

@property (copy, nonatomic) void (^actionHandler)(UITableViewCell<SFCTableViewCell> *cell, id action, id userInfo);
@property (copy, nonatomic) void (^didDisplayCellBlock)(UITableViewCell<SFCTableViewCell> *cell);
@property (copy, nonatomic) void (^willDisplayCellBlock)(UITableViewCell<SFCTableViewCell> *cell);
@property (nonatomic) BOOL shouldIndentWhileEditing;
@property (nonatomic) BOOL useOffscreenCellHeightCalculation;
@property (nonatomic) CGFloat cellHeight;
@property (nonatomic) CGFloat estimatedCellHeight;
@property (nonatomic) UIEdgeInsets separatorInset NS_AVAILABLE_IOS(7_0);
@property (nonatomic) UITableViewCellAccessoryType accessoryType;
@property (nonatomic) UITableViewCellAccessoryType editingAccessoryType;
@property (nonatomic) UITableViewCellEditingStyle editingStyle;
@property (nonatomic) UITableViewCellSelectionStyle selectionStyle;
@property (nonatomic, readonly) BOOL isSeparatorInsetsOverrided;
@property (strong, nonatomic) NSString *cellID;
@property (strong, nonatomic) id userInfo;

+ (instancetype)itemWithCellID:(NSString *)cellID;

// Declare in the sake of xcode autocompletion correctness
- (void)setActionHandler:(void (^)(UITableViewCell<SFCTableViewCell> *cell, id action, id userInfo))actionHandler;
- (void)setWillDisplayCellBlock:(void (^)(UITableViewCell<SFCTableViewCell> *cell))willDisplayCellBlock;
- (void)setDidDisplayCellBlock:(void (^)(UITableViewCell<SFCTableViewCell> *cell))didDisplayCellBlock;

@end
