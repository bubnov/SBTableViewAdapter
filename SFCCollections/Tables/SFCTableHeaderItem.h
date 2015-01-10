//
//  SFCTableHeaderItem.h
//  Pods
//
//  Created by Bubnov Slavik on 06/01/15.
//
//

#import <Foundation/Foundation.h>
#import "SFCTableViewHeaderFooterView.h"


@interface SFCTableHeaderItem : NSObject

@property (copy, nonatomic) void (^actionHandler)(UITableViewHeaderFooterView<SFCTableViewHeaderFooterView> *view, id action, id userInfo);
@property (nonatomic) BOOL useOffscreenHeightCalculation;
@property (nonatomic) CGFloat viewHeight;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSString *viewID;

+ (instancetype)itemWithViewID:(NSString *)viewID text:(NSString *)text;

// Declare in the sake of xcode autocompletion correctness
- (void)setActionHandler:(void (^)(UITableViewHeaderFooterView<SFCTableViewHeaderFooterView> *view, id action, id userInfo))actionHandler;

@end
