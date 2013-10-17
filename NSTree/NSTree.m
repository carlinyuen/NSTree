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

/** @brief Initialize with parent node */
- (id)initWithParent:(NSTreeNode *)parent
{
    self = [super init];
    if (self) {
        _parent = parent;
        _data = [NSMutableArray new];
        _children = [NSMutableArray new];  
    }
    return self;
}

- (NSString *)description 
{
    return [[self.data valueForKey:@"description"] componentsJoinedByString:@""];
}

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
    
    return [self addObject:object withChild:nil
        toNode:[self getLeafNodeForObject:object inNode:self.root]];
}

/** @brief Remove object from tree, returns false if not in tree */
- (bool)removeObject:(id)object
{
    if (!object || self.root.data.count <= 0) {
        return false;
    }
    
    return [self removeObject:object 
        fromNode:[self getNodeThatContains:object inBranch:self.root]];
}

/** @brief Search for object in tree, returns false if not found */
- (bool)containsObject:(id)object
{
    if (!object || self.root.data.count <= 0) {
        return false;
    }
    
    return ([self getNodeThatContains:object inBranch:self.root] != nil); 
}

/** @brief Returns true if tree is empty */
- (bool)isEmpty
{
    return (self.root.data.count == 0);
}

/** @brief Returns minimum element, or nil if none */
- (id)minimum
{
    if (self.root.data.count) {
        return [[[self getLeftMostNode] data] objectAtIndex:0];
    }
    
    return nil;
}

/** @brief Returns maximum element, or nil if none */
- (id)maximum
{
    if (self.root.data.count) {
        return [[[self getRightMostNode] data] objectAtIndex:0]; 
    }
    
    return nil;
}

/** @brief Returns number of elements in tree */
- (int)count
{
    static NSString *KEY_COUNT = @"total";
    
    if (self.root.data.count) {
        NSDictionary *data = @{
            KEY_COUNT: [NSNumber numberWithInt:0]
        };
        [self traverse:^(NSTreeNode *node, id data) {
            [data setObject:[NSNumber 
                numberWithInt:node.data.count + [data[KEY_COUNT] intValue]] 
                     forKey:KEY_COUNT];
        } extraData:data onTree:self.root withAlgorithm:NSTreeTraverseAlgorithmInorder];
        return [data[KEY_COUNT] intValue];
    }
    
    return 0;
}

/** @brief Returns object at index, or nil if none / out of bounds */
- (id)objectAtIndex:(int)index
{
    if (index < 0) {
        return nil;
    }
   
    // TODO
    return nil;
}

/** @brief Traverse the tree in sorted order while executing block on every element */
- (void)traverse:(NSTreeTraverseBlock)block extraData:(id)data onTree:(NSTreeNode *)root withAlgorithm:(NSTreeTraverseAlgorithm)algo
{
    // Return condition
    if (!root) {
        return;
    }
    
    // If Breadth First traversal
    if (algo == NSTreeTraverseAlgorithmBreadthFirst)
    {
        // Go through data
        for (int i = 0; i < root.data.count; ++i) {
            block(root.data[i], data);
        } 
        
        // Go to next sibling node, or next level's leftmost node
        if (root.next) {
            [self traverse:block extraData:data onTree:root.next withAlgorithm:algo]; 
        } 
        else  // Find next level's leftmost node
        {
            // Go to leftmost node in current level
            NSTreeNode *node = root;
            while (node.previous) {
                node = node.previous;   
            }
            
            // Start traversal on it's leftmost child
            if (node.children.count) {
                [self traverse:block extraData:data onTree:node.children[0] withAlgorithm:algo];  
            } else {
                NSLog(@"End of Breadth First Traversal");
                return;
            }
        }
    }
    else    // Depth First traversal
    {
        if (algo == NSTreeTraverseAlgorithmPostorder) 
        {
            for (int i = 0; i < root.children.count; ++i) {
                [self traverse:block extraData:data onTree:root.children[i] withAlgorithm:algo];
            }
        }
      
        // Process data, note the <= count for subtree traversal
        for (int i = 0; i <= root.data.count; ++i)
        {
            // Process subtrees in order
            if (algo == NSTreeTraverseAlgorithmInorder 
                && i < root.children.count) {
                [self traverse:block extraData:data onTree:root.children[i] withAlgorithm:algo]; 
            }
            
            // Process data in order
            if (i < root.data.count) {
                block(root.data[i], data);
            }
        }
      
        if (algo == NSTreeTraverseAlgorithmPreorder) 
        {
            for (int i = 0; i < root.children.count; ++i) {
                [self traverse:block extraData:data onTree:root.children[i] withAlgorithm:algo];
            }
        }
    }
}


#pragma mark - Tree Methods

- (bool)addObject:(id)object withChild:(NSTreeNode *)child toNode:(NSTreeNode *)node
{
    if (!object || !node) {
        return false;
    }
   
    // Simple add if empty
    if (!node.data.count) {
        [node.data addObject:object]; 
    }
    else    // Do some math
    {
        // Find index where we should put it, and add it
        int index = [node.data indexOfObject:object 
                               inSortedRange:NSMakeRange(0, node.data.count-1) 
                                     options:NSBinarySearchingInsertionIndex 
                             usingComparator:^NSComparisonResult(id obj1, id obj2) {
                                 return [obj1 compare:obj2];
                             }];
        [node.data insertObject:object atIndex:index];
        
        // Add child if exists, need to add right after data insertion
        if (child) 
        {
            if (index+1 > node.children.count) {
                NSLog(@"Warning! Adding child at index greater than children count for child: %@", child);
            }
            
            // Insert & change parent pointer
            [node.children insertObject:child atIndex:index+1];
            child.parent = node;
            
            // Switch up sibling pointers
            NSTreeNode *sibling = node.children[index];
            if (sibling) {
                child.next = sibling.next;
                child.previous = sibling;
                sibling.next = child;
            } 
            else    // This shouldn't happen, but check other side
            {
                NSLog(@"Warning! Checking next sibling pointer while adding child: %@", child);
                if (node.children.count < index+2) {
                    sibling = node.children[index+2];
                    if (sibling) {
                        child.previous = sibling.previous;
                        child.next = sibling;
                        sibling.previous = child;
                    }
                }
            }
        }
        
        // Rebalance as needed
        [self rebalanceNode:node];
    } 
    
    return true; 
}

- (bool)removeObject:(id)object fromNode:(NSTreeNode *)node
{
    if (!object || !node || node.data.count <= 0) {
        return false;
    }
    
    // If leaf node, simple remove
    if (!node.children.count) 
    {
        if ([node.data containsObject:object]) 
        {
            [node.data removeObject:object];
            
            // Rebalance as needed
            [self rebalanceNode:node];  
            
            return true;
        } 
        else {    // This shouldn't happen
            NSLog(@"Warning! Removing object from node that doesn't contain the object: %@", object);
            return false;
        }
    }
    else    // Deal with replacing separator
    {
        int index = [node.data indexOfObject:object 
                               inSortedRange:NSMakeRange(0, node.data.count-1) 
                                     options:NSBinarySearchingFirstEqual 
                             usingComparator:^NSComparisonResult(id obj1, id obj2) {
                                 return [obj1 compare:obj2];
                             }];
        
        // Replace with largest value from left child
        NSTreeNode *leftChild = node.children[index];
        id replacementObject = leftChild.data[leftChild.data.count-1];
        [node.data replaceObjectAtIndex:index 
            withObject:replacementObject];
        
        // Tell child to remove the replaced object
        return [self removeObject:replacementObject fromNode:leftChild];
    }
}

- (NSTreeNode *)getNodeThatContains:(id)object inBranch:(NSTreeNode *)node
{
    if (!object || !node || !node.data.count) {
        return nil;
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
            return node;
        }
        
        // If subtree doesn't exist at that index
        if (index >= node.children.count) {
            return nil;
        }
        
        // Need to search subtree
        return [self getNodeThatContains:object inBranch:node.children[index]];
    } 
    
    return nil;
}

- (NSTreeNode *)getLeafNodeForObject:(id)object inNode:(NSTreeNode *)node
{
    if (!object || !node) {
        return nil;
    }
    
    // If there are children, go farther down
    if (node.children.count)
    {
        // Search for item in node data
        int index = [node.data indexOfObject:object 
                               inSortedRange:NSMakeRange(0, node.data.count-1) 
                                     options:NSBinarySearchingInsertionIndex 
                             usingComparator:^NSComparisonResult(id obj1, id obj2) {
                                 return [obj1 compare:obj2];
                             }];
        
        // If within bounds of children
        if (index >= 0 && index < node.children.count) {
            return [self getLeafNodeForObject:object 
                                       inNode:node.children[index]];  
        } else {
            NSLog(@"Warning: could not find leaf node for object: %@", object);
            return nil;     // This shouldn't happen!
        }
    }
    else {  // Found the node
        return node;
    }
}

- (NSTreeNode *)getLeftMostNode
{
    NSTreeNode *node = self.root;
    
    while (node.children.count) {
        node = node.children[0];
    }
    
    return node;
}

- (NSTreeNode *)getRightMostNode
{
    NSTreeNode *node = self.root;
    
    while (node.children.count) {
        node = node.children[node.children.count-1];
    }
    
    return node;
}

- (void)rebalanceNode:(NSTreeNode *)node
{
    // If node is past capacity, need to split
    if (node.data.count > self.nodeCapacity)
    {
        // Create right node to be efficient about removing from arrays
        NSTreeNode *newRightNode = [[NSTreeNode alloc] initWithParent:node.parent];
        int middle = node.data.count / 2; 
        id object = node.data[middle];
        
        // Iterate through data & children and move into new nodes
        for (int i = middle + 1; i < node.data.count; ++i) {
            [newRightNode.data addObject:node.data[i]];
        }
        for (int i = middle + 1; i < node.children.count; ++i) {
            [node.children[i] setParent:newRightNode];
            [newRightNode.children addObject:node.children[i]];
        } 
        
        // Remove old items from left node
        [node.data removeObjectsInRange:NSMakeRange(middle + 1, node.data.count-1)];
        [node.children removeObjectsInRange:NSMakeRange(middle + 1, node.children.count-1)]; 
        
        // Change sibling pointers
        newRightNode.next = node.next;
        newRightNode.previous = node;
        node.next = newRightNode;
        
        // Add to parent, if exists
        if (node.parent) {
            [self addObject:object withChild:newRightNode toNode:node.parent];
        }
        else    // Root node, need to create new root
        {
            NSTreeNode *newRootNode = [NSTreeNode new];
            
            // Set current node's new parent, add as child to new parent
            node.parent = newRootNode;
            [newRootNode.children addObject:node];
            
            // Add data and new right branch to new parent
            [self addObject:object withChild:newRightNode toNode:newRootNode];
            
            // Set new root
            self.root = newRootNode;
        }
    }
    
    // If node is below min capacity (and not the root), need to join
    else if (node != self.root && node.data.count < self.nodeMinimum)
    {
    }
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
        state->mutationsPtr = 0;
        state->extra[0] = [self count];
    }
    // Now we provide items, which we track with state->state, and determine if we have finished iterating.
    if (state->state < state->extra[0])
    {
        // Set state->itemsPtr to the provided buffer.
        // Alternate implementations may set state->itemsPtr to an internal C array of objects.
        // state->itemsPtr MUST NOT be NULL
        state->itemsPtr = stackbuf;
        // Fill in the stack array, either until we've provided all items from the list
        // or until we've provided as many items as the stack based buffer will hold.
        while((state->state < state->extra[0]) && (count < len))
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
        [copy setNodeCapacity:self.nodeCapacity]; 
        [copy setNodeMinimum:self.nodeMinimum]; 
    }
    
    return copy;
}


@end
