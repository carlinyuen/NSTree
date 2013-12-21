//
//  NSTree.h
//  NSTree
//
//  Created by . Carlin on 10/16/13.
//  Copyright (c) 2013 Carlin Creations. All rights reserved.
//

#import <Foundation/Foundation.h>

/*  IMPORTANT NOTES
    Objects you store in the NSTree must implement a compare: function, see Apple developer docs for an example in NSNumber <https://developer.apple.com/library/mac/documentation/cocoa/reference/foundation/classes/nsnumber_class/Reference/Reference.html#//apple_ref/occ/instm/NSNumber/compare:>. I use compare instead of isE
*/

#pragma mark - NSTreeNode

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
    
    /** @brief Print entire tree */
    - (NSString *)printTree;
    
    /** @brief Prints and checks for pointer discrepancies in children, returns TRUE if all children have appropriate pointers to each other and their parent. Does not include the childrens' children. */
    - (bool)hasValidPointerStructure;

@end


#pragma mark - NSTree

typedef enum {
    /** Traverses data in sorted order */
    NSTreeTraverseAlgorithmInorder,
    
    /** Traverses node data first in order, then its branches in order */ 
    NSTreeTraverseAlgorithmPreorder, 
    
    /** Traverses node branches first in order, then its data */  
    NSTreeTraverseAlgorithmPostorder, 
    
    /** Traverses tree one level at a time, in order */   
    NSTreeTraverseAlgorithmBreadthFirst, 
    
} NSTreeTraverseAlgorithm;

/** @brief Traversal block for calling a function on data as we traverse through the tree.
    @param node Node on which the data currently resides
    @param data Object data stored in tree that we are traversing over
    @param extra Extra object data passed by user in the call to the traverse: method, this is useful for doing things like aggregate calculations.
    @return bool TRUE to continue traversing, FALSE to stop.
*/
typedef bool (^NSTreeTraverseBlock)(NSTreeNode *node, id data, id extra);

@interface NSTree : NSObject<NSFastEnumeration, NSCopying>
    @property (nonatomic, assign, readonly) int count;
    @property (nonatomic, assign, readonly) int nodeCapacity; 
    @property (nonatomic, assign, readonly) bool cacheOutdated;  

    /** @brief Create tree with a certain number of allowable children */
    - (id)initWithNodeCapacity:(int)nodeCapacity;
    
    /** @brief Create tree with a certain number of allowable children using the given sorted array of objects as its base data */
    - (id)initWithNodeCapacity:(int)nodeCapacity withSortedObjects:(NSArray *)data;

    /** @brief Add object to tree
        @param object An id that must implement compare: function
        @return bool TRUE if successful
    */
    - (bool)addObject:(id)object;

    /** @brief Remove object from tree
        @param object An id that must implement compare: function
        @return bool FALSE if not found or not removed
    */ 
    - (bool)removeObject:(id)object;

    /** @brief Search for object in tree
        @param object An id that must implement compare: function 
        @return bool FALSE if not found
        */
    - (bool)containsObject:(id)object;

    /** @brief Returns true if tree is empty */
    - (bool)isEmpty;

    /** @brief Returns minimum element, or nil if none */
    - (id)minimum;

    /** @brief Returns maximum element, or nil if none */
    - (id)maximum;
   
    /** @brief Returns sorted array of tree contents */
    - (NSArray *)toArray;
    
    /** @brief Rebuild cache for fast access, returns false if cache could not be refreshed (probably due to someone iterating over it) */
    - (bool)rebuildCache;

    /** @brief Returns number of elements in tree */
    - (int)trueCount;
    
    /** @brief Returns printout of the tree */
    - (NSString *)printTree;

    /** @brief Returns object at index, or nil if none / out of bounds */
    - (id)objectAtIndex:(int)index;

    /** @brief Traverse the tree in sorted order while executing block on every element
        @param block Traversal block to be called on data as we traverse 
        @param extra User defined object that will be passed to block to help do things like aggregate calculations.
        @param algo Traversal algorithm: inorder, postorder, preorder, bfs
        @return bool TRUE if traversed through entire tree, FALSE if cut short by traversal block
    */
    - (bool)traverse:(NSTreeTraverseBlock)block 
           extraData:(id)extra 
       withAlgorithm:(NSTreeTraverseAlgorithm)algo;

@end
