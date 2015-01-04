//
//  SFCCollectionSection.m
//  SFCCollections
//
//  Created by Bubnov Slavik on 28/07/14.
//  Copyright (c) 2014 Bubnov Slavik, bubnovslavik@gmail.com. All rights reserved.
//

#import "SFCCollectionSection.h"


@implementation SFCCollectionSection

@synthesize
header = _header,
footer = _footer,
items = _items;


+ (instancetype)sectionWithHeader:(id)header footer:(id)footer items:(NSArray *)items {
   SFCCollectionSection *section = [self new];
   section.header = header;
   section.footer = footer;
   section.items = [(items ? : @[]) mutableCopy];
   return section;
}


- (NSString *)description {
   return [NSString stringWithFormat:@"<%@ %p header=%@ footer=%@ items=%@>",
           [self class],
           self,
           self.header,
           self.footer,
           self.items];
}


- (id)copyWithZone:(NSZone *)zone {
   SFCCollectionSection *copy = [[self class] new];
   copy.header = [self.header copy];
   copy.footer = [self.footer copy];
   copy.items = [[NSMutableArray alloc] initWithArray:self.items copyItems:YES];
   return copy;
}


- (NSMutableArray *)itemsProxy {
   return [self mutableArrayValueForKey:@"items"];
}

@end