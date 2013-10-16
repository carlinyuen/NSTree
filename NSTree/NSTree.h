//
//  NSTree.h
//  NSTree
//
//  Created by . Carlin on 10/16/13.
//  Copyright (c) 2013 Carlin Creations. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTreeNode : NSObject
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) NSArray *children;
@end

@interface NSTree : NSObject
@property (nonatomic, weak) NSTreeNode *root;
- (id)initWithCapacity:(int)nodeCapacity;
@end
