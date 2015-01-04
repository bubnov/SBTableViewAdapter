//
//  SFCCollectionItem.m
//  SFCCollections
//
//  Created by Bubnov Slavik on 17/11/14.
//  Copyright (c) 2014 Bubnov Slavik, bubnovslavik@gmail.com. All rights reserved.
//

#import "SFCCollectionItem.h"


@interface SFCCollectionItem ()

@end


@implementation SFCCollectionItem

+ (instancetype)itemWithCellID:(NSString *)cellID {
   SFCCollectionItem *item = [self new];
   item.cellID = cellID;
   return item;
}

@end