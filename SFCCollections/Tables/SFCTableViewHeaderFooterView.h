//
//  SFCTableViewHeaderFooterView.h
//  Pods
//
//  Created by Bubnov Slavik on 06/01/15.
//
//

#import <UIKit/UIKit.h>


@protocol SFCTableViewHeaderFooterView <NSObject>

@property (strong, nonatomic, readonly) id object;

- (void)setObject:(id)object;
- (void)setObject:(id)object heightCalculation:(BOOL)calculation;

@optional

- (CGFloat)calculateViewHeight;

@end


@interface SFCTableViewHeaderFooterView : UITableViewHeaderFooterView <SFCTableViewHeaderFooterView>

@end


extern NSString * const kSFCTableViewHeaderFooterActionDidSelect;