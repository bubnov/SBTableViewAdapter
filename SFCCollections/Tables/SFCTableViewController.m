//
//  SFCTableViewController.m
//  SFCCollections
//
//  Created by Bubnov Slavik on 28/07/14.
//  Copyright (c) 2014 Bubnov Slavik, bubnovslavik@gmail.com. All rights reserved.
//

#import "SFCTableViewController.h"
#import "SFCTableItem.h"
#import "SFCTableViewCell.h"
#import "NSObject+SFCSafeKVO.h"
#import "SFObjCExtensions.h"
#import "SFProxyDelegate.h"


NSString * const kDefaultCellIdentifier = @"kDefaultCellIdentifier";


@interface SFCTableViewController ()

@property (strong, nonatomic) NSMutableArray *mutableSections;
@property (strong, nonatomic) NSMutableDictionary *fakeCells;
@property (strong, nonatomic) SFProxyDelegate *dataSourceProxy;
@property (strong, nonatomic) SFProxyDelegate *delegateProxy;
@property (nonatomic) UITableViewStyle tableViewStyle;

@end


@implementation SFCTableViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
   if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
      _animation = UITableViewRowAnimationAutomatic;
      _insertionAnimation = UITableViewRowAnimationAutomatic;
      _removalAnimation = UITableViewRowAnimationAutomatic;
   }
   return self;
}


- (void)viewDidLoad {
   [super viewDidLoad];
   
   if (self.tableViewClass) {
      UIViewAutoresizing autoresizingMask = self.tableView.autoresizingMask;
      self.tableView = [[self.tableViewClass alloc] initWithFrame:self.view.frame style:self.tableView.style];
      self.tableView.autoresizingMask = autoresizingMask;
   }
   
   [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kDefaultCellIdentifier];
   
   typeof(self) __weak weakSelf = self;
   
   [self.tableView sfc_observeKeyPath:@"delegate" block:^(NSString *keyPath, id object, NSDictionary *change) {
      if (weakSelf.tableView.delegate != self && [weakSelf.tableView.delegate class] != [SFProxyDelegate class]) {
         weakSelf.delegateProxy = [SFProxyDelegate proxyDelegate:weakSelf.tableView.delegate withDelegate:self];
         weakSelf.delegateProxy.shouldForwardAllMethods = YES;
         weakSelf.tableView.delegate = (id)weakSelf.delegateProxy;
      }
   }];
   
   [self.tableView sfc_observeKeyPath:@"dataSource" block:^(NSString *keyPath, id object, NSDictionary *change) {
      if (weakSelf.tableView.dataSource != self && [weakSelf.tableView.dataSource class] != [SFProxyDelegate class]) {
         weakSelf.dataSourceProxy = [SFProxyDelegate proxyDelegate:weakSelf.tableView.dataSource withDelegate:self];
         weakSelf.dataSourceProxy.shouldForwardAllMethods = YES;
         weakSelf.tableView.dataSource = (id)weakSelf.dataSourceProxy;
      }
   }];
}


- (void)viewDidLayoutSubviews {
   [super viewDidLayoutSubviews];

   if ([self respondsToSelector:@selector(topLayoutGuide)]) {
      CGFloat top = self.ignoreTopLayoutGuide ? 0 : ({
         self.parentViewController ? self.parentViewController.topLayoutGuide.length : self.topLayoutGuide.length;
      });

      self.tableView.contentInset = ({
         UIEdgeInsets insets = self.tableView.contentInset;
         insets.top = top;
         insets;
      });
      
      self.tableView.scrollIndicatorInsets = ({
         UIEdgeInsets insets = self.tableView.scrollIndicatorInsets;
         insets.top = top;
         insets;
      });
   }
}


- (void)viewWillAppear:(BOOL)animated {
   [super viewWillAppear:animated];
   [self.tableView reloadData];
}


- (void)addSection:(NSObject<SFCCollectionSection> *)section {
   if ( ! section) {
      return;
   }
   
   if ( ! self.mutableSections) {
      self.mutableSections = [NSMutableArray array];
   }
   
   if ( ! [self.mutableSections containsObject:section]) {
      [self.mutableSections addObject:section];
   }
   
   [self bindCollectionSection:section];
}


- (NSUInteger)sectionIndexOfCollectionSection:(NSObject<SFCCollectionSection> *)section {
   return section ? [self.mutableSections indexOfObject:section] : NSNotFound;
}


- (void)bindCollectionSection:(NSObject<SFCCollectionSection> *)section {
   typeof(self) __weak weakSelf = self;
   
   void (^reloadSection)(NSObject<SFCCollectionSection> *) = ^ (NSObject<SFCCollectionSection> *section) {
      NSUInteger sectionIndex = [weakSelf sectionIndexOfCollectionSection:section];
      if (sectionIndex != NSNotFound) {
         [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:weakSelf.animation];
      }
   };
   
   [section sfc_observeKeyPath:@"header" block:^(NSString *keyPath, id object, NSDictionary *change) {
      reloadSection(object);
   } token:@"header"];
   
   [section sfc_observeKeyPath:@"footer" block:^(NSString *keyPath, id object, NSDictionary *change) {
      reloadSection(object);
   } token:@"footer"];
   
   [section sfc_observeKeyPath:@"items" block:^(NSString *keyPath, id object, NSDictionary *change) {
      NSKeyValueChange kind = [change[@"kind"] unsignedIntegerValue];
      NSIndexSet *indexes = change[@"indexes"];
      NSUInteger sectionIndex = [weakSelf sectionIndexOfCollectionSection:section];
      if (sectionIndex == NSNotFound) {
         SFAssert(0, @"sectionIndex is not found!");
         return;
      }
      
      if (indexes) {
         NSMutableArray *indexArray = [NSMutableArray array];
         [indexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
            [indexArray addObject:[NSIndexPath indexPathForRow:idx inSection:sectionIndex]];
         }];
         
         switch (kind) {
            case NSKeyValueChangeInsertion: {
               [weakSelf.tableView insertRowsAtIndexPaths:indexArray withRowAnimation:weakSelf.insertionAnimation];
            } break;
               
            case NSKeyValueChangeRemoval: {
               [weakSelf.tableView deleteRowsAtIndexPaths:indexArray withRowAnimation:weakSelf.removalAnimation];
            } break;
               
            case NSKeyValueChangeReplacement: {
               [weakSelf.tableView reloadRowsAtIndexPaths:indexArray withRowAnimation:weakSelf.animation];
            } break;
               
            default: break;
         }
      } else {
         reloadSection(object);
      }
   } token:@"items"];
}


- (void)unbindCollectionSection:(NSObject<SFCCollectionSection> *)section {
   // TODO: implement!
}


- (NSArray *)sections {
   return [self.mutableSections copy];
}


- (void)addSections:(NSArray *)sections {
   [sections enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
      NSObject<SFCCollectionSection> *section = obj;
      NSAssert([section conformsToProtocol:@protocol(SFCCollectionSection)], @"Section doesn't conform to SFCCollectionSection protocol. %@", section);
      [self addSection:section];
   }];
}


- (void)insertSection:(NSObject<SFCCollectionSection> *)section atIndex:(NSUInteger)index {
   SFAssert(section, @"Section is required!");
   if ( ! section) {
      return;
   }
   
   [self bindCollectionSection:section];
   
   [self.mutableSections insertObject:section atIndex:index];
}


- (void)removeSection:(NSObject<SFCCollectionSection> *)section {
   // TODO: implement!
}


- (void)performBatchUpdates:(void (^)(void))updates completion:(void (^)(BOOL finished))completion {
   if ( ! updates) return;
   
   [CATransaction begin];
   [CATransaction setCompletionBlock:^{
      if (completion) {
         completion(YES);
      }
   }];
   
   [self.tableView beginUpdates];
   updates();
   [self.tableView endUpdates];
   
   [CATransaction commit];
}


- (SFCCollectionSection *)_sectionAtIndexPath:(NSIndexPath *)indexPath {
   if (indexPath.section < [self.mutableSections count]) {
      return self.mutableSections[indexPath.section];
   }
   return nil;
}


- (id)_objectAtIndexPath:(NSIndexPath *)indexPath {
   SFCCollectionSection *section = [self _sectionAtIndexPath:indexPath];
   if (section && indexPath.row < [section.items count]) {
      return section.items[indexPath.row];
   }
   return nil;
}


- (SFCTableItem *)_itemAtIndexPath:(NSIndexPath *)indexPath {
   return safe_cast(SFCTableItem, [self _objectAtIndexPath:indexPath]);
}


- (CGFloat)_calculateHeightOfCellForItem:(SFCTableItem *)item {
   // http://stackoverflow.com/questions/18746929/using-auto-layout-in-uitableview-for-dynamic-cell-layouts-variable-row-heights
   
   if (safe_cast(SFCTableItem, item) && item.cellID) {
      if ( ! self.fakeCells) {
         self.fakeCells = [NSMutableDictionary dictionary];
      }
      
      UITableViewCell<SFCTableViewCell> *cell = [self.fakeCells objectForKey:item.cellID];
      if ( ! cell) {
         Class cls = [[self.tableView dequeueReusableCellWithIdentifier:item.cellID] class];
         if (cls) {
            cell = [[cls alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            [self.fakeCells setObject:cell forKey:item.cellID];
         }
      }
      
      if ([cell conformsToProtocol:@protocol(SFCTableViewCell)]) {
         // Set the width of the cell to match the width of the table view. This is important so that we'll get the
         // correct cell height for different table view widths if the cell's height depends on its width (due to
         // multi-line UILabels word wrapping, etc). We don't need to do this above in -[tableView:cellForRowAtIndexPath]
         // because it happens automatically when the cell is used in the table view.
         // Also note, the final width of the cell may not be the width of the table view in some cases, for example when a
         // section index is displayed along the right side of the table view. You must account for the reduced cell width.
         if (cell.bounds.size.width != self.tableView.bounds.size.width) {
            cell.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.tableView.bounds), CGRectGetHeight(cell.bounds));
            [cell setNeedsLayout];
            [cell layoutIfNeeded];
         }
         
         [cell prepareForReuse];
         [cell setObject:item heightCalculation:YES];
         
         // Make sure the constraints have been set up for this cell, since it may have just been created from scratch.
         // Use the following lines, assuming you are setting up constraints from within the cell's updateConstraints method:
         [cell setNeedsUpdateConstraints];
         [cell updateConstraintsIfNeeded];
         
         // Do the layout pass on the cell, which will calculate the frames for all the views based on the constraints.
         // (Note that you must set the preferredMaxLayoutWidth on multi-line UILabels inside the -[layoutSubviews] method
         // of the UITableViewCell subclass, or do it manually at this point before the below 2 lines!)
         [cell setNeedsLayout];
         [cell layoutIfNeeded];
         
         // Let cell to calculate its height
         if ([cell respondsToSelector:@selector(calculateCellHeight)]) {
            return [cell calculateCellHeight];
         }
         
         // Get the actual height required for the cell's contentView
         CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
         return height;
      }
   }
   
   return 44;
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   return [[[self _sectionAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]] items] count];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
   return [self.mutableSections count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   NSString *cellID = kDefaultCellIdentifier;
   
   NSObject *object = [self _objectAtIndexPath:indexPath];
   SFCTableItem *item = safe_cast(SFCTableItem, object);
   if (item.cellID) {
      cellID = item.cellID;
   }
   
   UITableViewCell<SFCTableViewCell> *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
   
   if ([cell conformsToProtocol:@protocol(SFCTableViewCell)]) {
      [cell setObject:item heightCalculation:NO];
   } else {
      cell.textLabel.text = [object description];
   }
   
   [cell setNeedsUpdateConstraints];
   [cell updateConstraintsIfNeeded];
   
   if (item.didDisplayCellBlock) {
      item.didDisplayCellBlock(cell);
   }
   
   return cell;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
   return [[self _sectionAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]] header];
}


- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
   return [[self _sectionAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]] footer];
}


- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
   if (self.isSectionTitleAutoCapitalizationEnabled) {
      if ([view isKindOfClass:[UITableViewHeaderFooterView class]]) {
         UITableViewHeaderFooterView *tableViewHeaderFooterView = (UITableViewHeaderFooterView *)view;
         SFCCollectionSection *sectionObject = [self _sectionAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
         tableViewHeaderFooterView.textLabel.text = sectionObject.header;
      }
   }
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
   SFCTableItem *item = [self _itemAtIndexPath:indexPath];
   if (item.actionHandler) {
      NSString *style = editingStyle == UITableViewCellEditingStyleDelete ? kTableViewCellActionDelete : @"undefined";
      UITableViewCell<SFCTableViewCell> *cell = (id)[tableView cellForRowAtIndexPath:indexPath];
      if ([cell conformsToProtocol:@protocol(SFCTableViewCell)]) {
         item.actionHandler(cell, style, nil);
      }
   }
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
   SFCTableItem *item = [self _itemAtIndexPath:indexPath];
   if (item.willDisplayCellBlock && [cell conformsToProtocol:@protocol(SFCTableViewCell)]) {
      item.willDisplayCellBlock((UITableViewCell<SFCTableViewCell> *)cell);
   }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   if (self.unselectRowWhenPressed) {
      [tableView deselectRowAtIndexPath:indexPath animated:YES];
   }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
   SFCTableItem *item = [self _itemAtIndexPath:indexPath];
   if (item.useOffscreenCellHeightCalculation) {
      return [self _calculateHeightOfCellForItem:item];
   }
   return item.cellHeight ? : 44;
}

// TODO: Seems like this iOS shit is a little bit buggy...
//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
//   CGFloat height = [self _itemAtIndexPath:indexPath].estimatedCellHeight ? : UITableViewAutomaticDimension;
//   return height;
//}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
   return [self _itemAtIndexPath:indexPath].editingStyle;
}


- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
   return [self _itemAtIndexPath:indexPath].shouldIndentWhileEditing;
}

@end


NSString * const kTableViewCellActionDelete = @"kTableViewCellActionDelete";
