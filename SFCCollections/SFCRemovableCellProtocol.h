//
//  SFCRemovableCellProtocol.h
//  SFCCollections
//
//  Created by Bubnov Slavik on 19/12/14.
//  Copyright (c) 2014 Bubnov Slavik, bubnovslavik@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol SFCRemovableCell <NSObject>

@property (nonatomic, getter=isShowingDeleteConfirmation) BOOL showingDeleteConfirmation;
@property (weak, nonatomic) IBOutlet UIView *deleteConfirmationView;

@end