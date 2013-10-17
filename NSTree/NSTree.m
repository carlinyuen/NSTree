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

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    id copy = [[[self class] alloc] init];
    
    if (copy) {
        [copy setData:[self.data copyWithZone:zone]]; 
        [copy setChildren:[self.children copyWithZone:zone]];  
    }
    
    return copy;
}

@end


#pragma mark - NSTree

@interface NSTree()
    @property (nonatomic, strong, readwrite) NSTreeNode *root;
    @property (nonatomic, assign, readwrite) int count;
    @property (nonatomic, assign) int nodeCapacity;
    @property (nonatomic, assign) int nodeMinimum;
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
        _count = 0;
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
        _count = 0; 
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

/** @brief Returns true if tree is empty */
- (bool)isEmpty
{
    return (self.count == 0);
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
    
    // Update count
    self.count++;
    
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


#pragma mark - NSFastEnumeration

// TODO
- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(__unsafe_unretained id *)stackbuf count:(NSUInteger)len
{
    NSUInteger count = 0;
    // This is the initialization condition, so we'll do one-time setup here.
    // Ensure that you never set state->state back to 0, or use another method to detect initialization
    // (such as using one of the values of state->extra).
    if (state->state == 0)
    {
        // We are not tracking mutations, so we'll set state->mutationsPtr to point into one of our extra values,
        // since these values are not otherwise used by the protocol.
        // If your class was mutable, you may choose to use an internal variable that is updated when the class is mutated.
        // state->mutationsPtr MUST NOT be NULL.
        state->mutationsPtr = &state->extra[0];
    }
    // Now we provide items, which we track with state->state, and determine if we have finished iterating.
    if (state->state < self.count)
    {
        // Set state->itemsPtr to the provided buffer.
        // Alternate implementations may set state->itemsPtr to an internal C array of objects.
        // state->itemsPtr MUST NOT be NULL.
        state->itemsPtr = stackbuf;
        // Fill in the stack array, either until we've provided all items from the list
        // or until we've provided as many items as the stack based buffer will hold.
        while((state->state < self.count) && (count < len))
        {
            // For this sample, we generate the contents on the fly.
            // A real implementation would likely just be copying objects from internal storage.
            stackbuf[count] = [NSNumber numberWithInt:state->state];
            state->state++;
            count++;
        }
        
        return count;
    }
    
    return 0;   // Done iterating
}


#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    id copy = [[[self class] alloc] init];
    
    if (copy) {
        [copy setRoot:[self.root copyWithZone:zone]];
        [copy setCount:self.count];
        [copy setNodeCapacity:self.nodeCapacity]; 
        [copy setNodeMinimum:self.nodeMinimum]; 
    }
    
    return copy;
}


@end
