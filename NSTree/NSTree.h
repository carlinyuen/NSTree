//
//  NSTree.h
//  NSTree
//
//  Created by . Carlin on 10/16/13.
//  Copyright (c) 2013 Carlin Creations. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTreeNode : NSObject<NSCopying>
    @property (nonatomic, weak) NSTreeNode *parent;
    @property (nonatomic, weak) NSTreeNode *previous;
    @property (nonatomic, weak) NSTreeNode *next;
    @property (nonatomic, strong) NSMutableArray *data;
    @property (nonatomic, strong) NSMutableArray *children;

    /** @brief Initialize with parent node */
    - (id)initWithParent:(NSTreeNode *)parent;

    /** @brief Get index of node in children array */
    - (NSUInteger)indexOfChildNode:(NSTreeNode *)child;

    /** @brief Get index of object in data array */
    - (NSUInteger)indexOfDataObject:(id)object;

@end

typedef enum {
    /** Traverses data in sorted order */
    NSTreeTraverseAlgorithmInorder,
    
    /** Traverses node data first, then its branches in order */ 
    NSTreeTraverseAlgorithmPreorder, 
    
    /** Traverses node branches first, then its data */  
    NSTreeTraverseAlgorithmPostorder, 
    
    /** Traverses tree one level at a time, in order */   
    NSTreeTraverseAlgorithmBreadthFirst, 
    
} NSTreeTraverseAlgorithm;

typedef void(^NSTreeTraverseBlock)(NSTreeNode *node, id data);

@interface NSTree : NSObject<NSFastEnumeration, NSCopying>
    @property (nonatomic, assign, readonly) int count;

    /** @brief Create tree with a certain number of allowable children */
    - (id)initWithNodeCapacity:(int)nodeCapacity;

    /** @brief Add object to tree, true if successful */
    - (bool)addObject:(id)object;

    /** @brief Remove object from tree, returns false if not in tree */
    - (bool)removeObject:(id)object;

    /** @brief Search for object in tree, returns false if not found */
    - (bool)containsObject:(id)object;

    /** @brief Returns true if tree is empty */
    - (bool)isEmpty;

    /** @brief Returns minimum element, or nil if none */
    - (id)minimum;

    /** @brief Returns maximum element, or nil if none */
    - (id)maximum;

    /** @brief Returns number of elements in tree */
    - (int)trueCount;

    /** @brief Returns object at index, or nil if none / out of bounds */
    - (id)objectAtIndex:(int)index;

    /** @brief Traverse the tree in sorted order while executing block on every element */
- (void)traverse:(NSTreeTraverseBlock)block 
       extraData:(id)data 
          onTree:(NSTreeNode *)root 
   withAlgorithm:(NSTreeTraverseAlgorithm)algo;

@end
