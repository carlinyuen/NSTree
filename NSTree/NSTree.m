//
//  NSTree.m
//  NSTree
//
//  Created by . Carlin on 10/16/13.
//  Copyright (c) 2013 Carlin Creations. All rights reserved.
//

#import "NSTree.h"

#define DEFAULT_NODE_CAPACITY 1

#pragma mark - NSTreeNode

@implementation NSTreeNode


@end


#pragma mark - NSTree

@interface NSTree()
@property (nonatomic, assign) int nodeCapacity;
@end


@implementation NSTree


#pragma mark - Constructors

- (id)init
{
    self = [super init];
    if (self) {
        _nodeCapacity = DEFAULT_NODE_CAPACITY;
    }
    return self;
}

- (id)initWithCapacity:(int)nodeCapacity
{
    self = [super init];
    if (self) {
        _nodeCapacity = nodeCapacity;
    }
    return self;
}


#pragma mark - Public Methods


#pragma mark - Tree Methods


@end
