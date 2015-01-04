//
//  SFCCollectionSection.h
//  SFCCollections
//
//  Created by Bubnov Slavik on 28/07/14.
//  Copyright (c) 2014 Bubnov Slavik, bubnovslavik@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol SFCCollectionSection <NSCopying>

@property (strong, nonatomic) id header;
@property (strong, nonatomic) id footer;
@property (strong, nonatomic) NSMutableArray *items;
@property (strong, nonatomic, readonly) NSMutableArray *itemsProxy;

+ (instancetype)sectionWithHeader:(id)header footer:(id)footer items:(NSArray *)items;

@end



@interface SFCCollectionSection : NSObject <SFCCollectionSection>

@end