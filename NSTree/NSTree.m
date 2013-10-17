//
//  NSTree.m
//  NSTree
//
//  Created by . Carlin on 10/16/13.
//  Copyright (c) 2013 Carlin Creations. All rights reserved.
//

#import "NSTree.h"

#define DEFAULT_NODE_CAPACITY 2

#pragma mark - NSTreeNode

@implementation NSTreeNode

- (id)init
{
    self = [super init];
    if (self) {
        _data = [NSMutableArray new];
        _children = [NSMutableArray new]; 
    }
    return self;
}

@end


#pragma mark - NSTree

@interface NSTree()
    @property (nonatomic, assign) int nodeCapacity;
    @property (nonatomic, assign) int nodeMinimum;
    @property (nonatomic, strong, readwrite) NSTreeNode *root;
@end


@implementation NSTree


#pragma mark - Constructors

- (id)init
{
    self = [super init];
    if (self) {
        _nodeCapacity = DEFAULT_NODE_CAPACITY;
        _nodeMinimum = _nodeCapacity / 2;
        _root = [NSTreeNode new];
    }
    return self;
}

/** @brief Create tree with a certain number of allowable children */
- (id)initWithNodeCapacity:(int)nodeCapacity
{
    self = [super init];
    if (self) {
        _nodeCapacity = MAX(nodeCapacity, DEFAULT_NODE_CAPACITY);
        _nodeMinimum = _nodeCapacity / 2; 
        _root = [NSTreeNode new]; 
    }
    return self;
}


#pragma mark - Public Methods

/** @brief Add object to tree, true if successful */
- (bool)addObject:(id)object
{
    if (!object) {
        return false;
    }
    
    return [self addObject:object toNode:self.root];
}

/** @brief Remove object from tree, returns false if not in tree */
- (bool)removeObject:(id)object
{
    if (!object) {
        return false;
    }
    
    return [self removeObject:object fromNode:self.root];
}

/** @brief Search for object in tree, returns false if not found */
- (bool)containsObject:(id)object
{
    if (!object) {
        return false;
    }
    
    return [self containsObject:object inNode:self.root]; 
}


#pragma mark - Tree Methods

- (bool)addObject:(id)object toNode:(NSTreeNode *)node
{
    if (!object || !node) {
        return false;
    }
   
    // Add object
    if (node.data.count) 
    {
        // If node has fewer than capacity, can add
        int index = [node.data indexOfObject:object 
                               inSortedRange:NSMakeRange(0, node.data.count-1) 
                                     options:NSBinarySearchingInsertionIndex 
                             usingComparator:^NSComparisonResult(id obj1, id obj2) {
                                 return [obj1 compare:obj2];
                             }];
        
        if (index >= 0 && index < node.data.count) {
            if ([node.data[index] isEqual:object]) {
                
            }
            else {
            }
        }
        
    } 
    else {
        [node.data addObject:object];
    }
    
    // Rebalance
    
    return true; 
}

- (bool)removeObject:(id)object fromNode:(NSTreeNode *)node
{
    if (!object || !node) {
        return false;
    }
    
    return false; 
}

- (bool)containsObject:(id)object inNode:(NSTreeNode *)node
{
    if (!object || !node || !node.data.count) {
        return false;
    }
    
    // Search for item in node data
    int index = [node.data indexOfObject:object 
                           inSortedRange:NSMakeRange(0, node.data.count-1) 
                                 options:NSBinarySearchingInsertionIndex 
                         usingComparator:^NSComparisonResult(id obj1, id obj2) {
                             return [obj1 compare:obj2];
                         }];
    
    // If within bounds of data (note the <= count due to subtree indexing)
    if (index >= 0 && index <= node.data.count) 
    {
        // Check if item is equal at index 
        if ([node.data[index] isEqual:object]) {
            return true;
        }
        
        // If subtree doesn't exist at that index
        if (index >= node.children.count) {
            return false;
        }
        
        // Need to search subtree
        return [self containsObject:object inNode:node.children[index]];
    } 
    
    return false;
}


@end
