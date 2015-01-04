//
//  SFCCollectionViewCell.m
//  SFCCollections
//
//  Created by Bubnov Slavik on 17/11/14.
//  Copyright (c) 2014 Bubnov Slavik, bubnovslavik@gmail.com. All rights reserved.
//

#import "SFCCollectionViewCell.h"
#import "SFCCollectionItem.h"


@interface SFCCollectionViewCell ()

@property (strong, nonatomic) id object;

@end


@implementation SFCCollectionViewCell

+ (instancetype)new {
   return [[[UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil] instantiateWithOwner:nil options:nil] firstObject];
}


- (void)prepareForReuse {
   [super prepareForReuse];
   _object = nil;
}


- (void)setObject:(id)object {
   [self setObject:object heightCalculation:NO];
}


- (void)setObject:(id)object heightCalculation:(BOOL)calculation {
   _object = object;
}

@end