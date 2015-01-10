//
//  SFCTableViewHeaderFooterView.m
//  Pods
//
//  Created by Bubnov Slavik on 06/01/15.
//
//

#import "SFCTableViewHeaderFooterView.h"
#import "SFCTableHeaderItem.h"


@interface SFCTableViewHeaderFooterView ()

@property (strong, nonatomic) id object;

@end


@implementation SFCTableViewHeaderFooterView

- (void)prepareForReuse {
   [super prepareForReuse];
   self.object = nil;
}


- (void)setObject:(id)object {
   [self setObject:object heightCalculation:NO];
}


- (void)setObject:(id)object heightCalculation:(BOOL)calculation {
   _object = object;
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
   SFCTableHeaderItem *item = self.object;
   if ([item isKindOfClass:[SFCTableHeaderItem class]] && item.actionHandler) {
      item.actionHandler(self, kSFCTableViewHeaderFooterActionDidSelect, nil);
   }
   
   [super touchesEnded:touches withEvent:event];
}

@end


NSString * const kSFCTableViewHeaderFooterActionDidSelect = @"didSelect";