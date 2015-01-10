//
//  SFCTableHeaderItem.m
//  Pods
//
//  Created by Bubnov Slavik on 06/01/15.
//
//

#import "SFCTableHeaderItem.h"


@implementation SFCTableHeaderItem

+ (instancetype)itemWithViewID:(NSString *)viewID text:(NSString *)text {
   SFCTableHeaderItem *item = [self new];
   item.viewID = viewID;
   item.text = text;
   return item;
}

@end
