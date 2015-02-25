//
//  SFCTableViewCell.m
//  SFCCollections
//
//  Created by Bubnov Slavik on 30/07/14.
//  Copyright (c) 2014 Bubnov Slavik, bubnovslavik@gmail.com. All rights reserved.
//

#import "SFCTableViewCell.h"
#import "SFCTableItem.h"


@interface SFCTableViewCell ()

@property (strong, nonatomic) id object;

@end


@implementation SFCTableViewCell

- (void)prepareForReuse {
   [super prepareForReuse];
   self.object = nil;
}


- (void)setObject:(id)object {
   [self setObject:object heightCalculation:NO];
}


- (void)setObject:(id)object heightCalculation:(BOOL)calculation {
   _object = object;
   
   if ([self.object isKindOfClass:[SFCTableItem class]]) {
      self.selectionStyle = [object selectionStyle];
      self.accessoryType = [object accessoryType];
      self.editingAccessoryType = [object editingAccessoryType];
      self.shouldIndentWhileEditing = [object shouldIndentWhileEditing];
      if ([object isSeparatorInsetsOverrided]) {
         self.separatorInset = [object separatorInset];
      }
   }
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
   if (self.editingStyle != UITableViewCellEditingStyleDelete) {
      SFCTableItem *item = self.object;
      if ([item isKindOfClass:[SFCTableItem class]] && item.actionHandler) {
         item.actionHandler(self, kSFCTableViewCellActionDidSelect, nil);
      }
   }
   
   [super touchesEnded:touches withEvent:event];
}

@end


NSString * const kSFCTableViewCellActionDidSelect = @"didSelect";