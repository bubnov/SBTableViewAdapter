//
//  SFCTableItem.m
//  SFCCollections
//
//  Created by Bubnov Slavik on 29/07/14.
//  Copyright (c) 2014 Bubnov Slavik, bubnovslavik@gmail.com. All rights reserved.
//

#import "SFCTableItem.h"


@interface SFCTableItem ()

@property (nonatomic) BOOL isSeparatorInsetsOverrided;

@end


@implementation SFCTableItem

+ (instancetype)itemWithCellID:(NSString *)cellID {
   SFCTableItem *item = [self new];
   item.cellID = cellID;
   return item;
}


- (instancetype)init {
   if (self = [super init]) {
      self.selectionStyle = UITableViewCellSelectionStyleDefault;
      self.accessoryType = UITableViewCellAccessoryNone;
      self.editingStyle = UITableViewCellEditingStyleNone;
   }
   return self;
}


- (void)setSeparatorInset:(UIEdgeInsets)separatorInset {
   _separatorInset = separatorInset;
   self.isSeparatorInsetsOverrided = YES;
}

@end
