//
//  SFCTableViewController.h
//  SFCCollections
//
//  Created by Bubnov Slavik on 28/07/14.
//  Copyright (c) 2014 Bubnov Slavik, bubnovslavik@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFCCollectionSection.h"


@interface SFCTableViewController : UITableViewController

@property (nonatomic) BOOL ignoreTopLayoutGuide; // NO by default
@property (nonatomic) BOOL unselectRowWhenPressed;
@property (nonatomic) Class tableViewClass;
@property (nonatomic) UITableViewRowAnimation animation;
@property (nonatomic) UITableViewRowAnimation insertionAnimation;
@property (nonatomic) UITableViewRowAnimation removalAnimation;
@property (nonatomic, getter=isSectionTitleAutoCapitalizationEnabled) BOOL sectionTitleAutoCapitalizationEnabled;

- (NSArray *)sections;
- (void)addSection:(NSObject<SFCCollectionSection> *)section;
- (void)addSections:(NSArray *)sections;
- (void)insertSection:(NSObject<SFCCollectionSection> *)section atIndex:(NSUInteger)index;
- (void)removeSection:(NSObject<SFCCollectionSection> *)section;
- (void)performBatchUpdates:(void (^)(void))updates completion:(void (^)(BOOL finished))completion;

@end


extern NSString * const kTableViewCellActionDelete;
extern NSString * const kDefaultCellIdentifier;