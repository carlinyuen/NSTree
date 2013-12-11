//
//  NSTreeTests.m
//  NSTreeTests
//
//  Created by . Carlin on 10/16/13.
//  Copyright (c) 2013 Carlin Creations. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "NSTree.h"

#define NODE_CAPACITY 3

@interface NSTreeTests : XCTestCase
    @property (nonatomic, strong) NSTree *tree;
@end

@implementation NSTreeTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    self.tree = [[NSTree alloc] initWithNodeCapacity:NODE_CAPACITY];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCleanStatus
{
    XCTAssertEqual(self.tree.count, 0, @"Count is not zero");
    XCTAssertNil([self.tree minimum], @"Min is not nil");
    XCTAssertNil([self.tree maximum], @"Max is not nil"); 
}

- (void)testAddNil
{
    XCTAssertFalse([self.tree addObject:nil], @"Added nil");
    XCTAssertEqual(self.tree.count, 0, @"Count is not 0");
    XCTAssertNil([self.tree minimum], @"Min is not nil");
    XCTAssertNil([self.tree maximum], @"Max is not nil");  
}

- (void)testAddOne
{
    XCTAssertTrue([self.tree addObject:@1], @"Failed to add");
    XCTAssertEqual(self.tree.count, 1, @"Count is not 1");
    XCTAssertNotNil([self.tree minimum], @"Min is nil");
    XCTAssertNotNil([self.tree maximum], @"Max is nil");  
}

- (void)testSearchInRoot
{
    [self.tree addObject:@5];
    XCTAssertTrue([self.tree containsObject:@5], @"Couldn't find number 5");
    XCTAssertFalse([self.tree containsObject:@2], @"Shouldn't have found number 2"); 
}

- (void)testSearchInTwoLevels
{
    for (int i = 1; i <= NODE_CAPACITY; ++i) {
        [self.tree addObject:@(i)];
    }
    XCTAssertTrue([self.tree containsObject:@2], @"Couldn't find number 2");
    XCTAssertFalse([self.tree containsObject:@6], @"Shouldn't have found number 6");  
    XCTAssertEqual(self.tree.count, NODE_CAPACITY, @"Count is not at node capacity"); 
}

- (void)testTrueCount
{
    [self.tree addObject:@1];
    XCTAssertEqual([self.tree trueCount], 1, @"Count is not 1");  
    XCTAssertEqual([self.tree trueCount], self.tree.count, @"trueCount != count");     
    
    [self.tree addObject:@2];
    [self.tree addObject:@3]; 
    XCTAssertEqual([self.tree trueCount], 3, @"Count is not 3");   
    XCTAssertEqual([self.tree trueCount], self.tree.count, @"trueCount != count");    
    
    [self.tree addObject:@4];
    [self.tree addObject:@5]; 
    XCTAssertEqual([self.tree trueCount], 5, @"Count is not 5");   
    XCTAssertEqual([self.tree trueCount], self.tree.count, @"trueCount != count"); 
}

- (void)testRemoveOne
{
    [self.tree addObject:@1];
    XCTAssertTrue([self.tree removeObject:@1], @"Failed to remove");
    XCTAssertEqual(self.tree.count, 0, @"Count is not zero");
    XCTAssertNil([self.tree minimum], @"Min is not nil");
    XCTAssertNil([self.tree maximum], @"Max is not nil");  
}

- (void)testRemoveWhenEmpty
{
    XCTAssertFalse([self.tree removeObject:@1], @"Remove worked even when empty");
    XCTAssertEqual(self.tree.count, 0, @"Count is not zero");
    XCTAssertNil([self.tree minimum], @"Min is not nil");
    XCTAssertNil([self.tree maximum], @"Max is not nil");  
}

- (void)testSearchAndRemoveInTwoLevels
{
    for (int i = 1; i <= NODE_CAPACITY; ++i) {
        [self.tree addObject:@(i)];
    }
    XCTAssertTrue([self.tree containsObject:@2], @"Couldn't find number 2");
    XCTAssertFalse([self.tree containsObject:@6], @"Shouldn't have found number 6");  
    XCTAssertEqual(self.tree.count, NODE_CAPACITY, @"Count is not at node capacity");
    XCTAssertTrue([self.tree removeObject:@1], @"Failed to remove 1"); 
    XCTAssertEqual(self.tree.count, NODE_CAPACITY - 1, @"Count is not node capacity - 1");  
    XCTAssertTrue([self.tree containsObject:@2], @"Couldn't find number 2"); 
    XCTAssertFalse([self.tree containsObject:@1], @"Shouldn't find number 1"); 
}

- (void)testAdd10
{
    int addAmount = 10;
    for (int i = 1; i <= addAmount; ++i) {
        [self.tree addObject:@(i)];
    }
    XCTAssertEqual(self.tree.count, addAmount, @"Count is not 10");   
    
    NSNumber *min = [self.tree minimum];
    NSNumber *max = [self.tree maximum]; 
    XCTAssertNotNil(min, @"Min is nil");
    XCTAssertNotNil(max, @"Max is nil");   
    XCTAssertEqual(min, @1, @"Min is not 1");
    XCTAssertEqual(max, @(addAmount), @"Max is not 10"); 
    
    NSLog(@"TREE: \n%@", [self.tree printTree]); 
}

- (void)testAdd100
{
    int addAmount = 100;
    for (int i = 1; i <= addAmount; ++i) {
        [self.tree addObject:@(i)];
    }
    XCTAssertEqual(self.tree.count, addAmount, @"Count is not 100");   
    
    NSNumber *min = [self.tree minimum];
    NSNumber *max = [self.tree maximum]; 
    XCTAssertNotNil(min, @"Min is nil");
    XCTAssertNotNil(max, @"Max is nil");   
    XCTAssertEqual(min, @1, @"Min is not 1");
    XCTAssertEqual([max intValue], addAmount, @"Max is not 100"); 
    
    NSLog(@"TREE: \n%@", [self.tree printTree]); 
}

- (void)testAdd10000
{
    int addAmount = 10000;
    for (int i = 1; i <= addAmount; ++i) {
        [self.tree addObject:@(i)];
    }
    XCTAssertEqual(self.tree.count, addAmount, @"Count is not 10000");   
    
    NSNumber *min = [self.tree minimum];
    NSNumber *max = [self.tree maximum]; 
    XCTAssertNotNil(min, @"Min is nil");
    XCTAssertNotNil(max, @"Max is nil");   
    XCTAssertEqual(min, @1, @"Min is not 1");
    XCTAssertEqual([max intValue], addAmount, @"Max is not 10000"); 
}

- (void)testRemoveMany
{
    for (int i = 1; i <= 10; ++i) {
        [self.tree addObject:@(i)];
    }
    
    XCTAssertTrue([self.tree removeObject:@1], @"Could not remove 1");
    NSNumber *min = [self.tree minimum];
    XCTAssertNotNil(min, @"Min is nil");
    XCTAssertEqual(min, @2, @"Min is not 2");
    
    XCTAssertTrue([self.tree removeObject:@4], @"Could not remove 4"); 
    XCTAssertFalse([self.tree containsObject:@4], @"Shouldn't find number 4");  
    
    XCTAssertFalse([self.tree removeObject:@4], @"Should not be able to remove 4");  
    
    XCTAssertTrue([self.tree removeObject:@8], @"Could not remove 8");  
    XCTAssertTrue([self.tree removeObject:@6], @"Could not remove 6");   
    XCTAssertTrue([self.tree removeObject:@9], @"Could not remove 9");   
    
    XCTAssertEqual(self.tree.count, [self.tree trueCount], @"Truecount != count");
    XCTAssertEqual(self.tree.count, 5, @"Count != 5");
}

- (void)testBulkLoad10
{
    NSMutableArray *data = [NSMutableArray new];
    for (int i = 1; i <= 10; ++i) {
        [data addObject:@(i)];
    }
    
    self.tree = [[NSTree alloc] initWithNodeCapacity:NODE_CAPACITY withSortedObjects:data];
    
    XCTAssertTrue(self.tree, @"Tree does not exist");
    XCTAssertEqual(self.tree.count, (int)data.count, @"Tree count != data count"); 
    XCTAssertEqual(self.tree.count, [self.tree trueCount], @"Truecount != count"); 
    
    NSLog(@"TREE: \n%@", [self.tree printTree]);
}

- (void)testBulkLoad100
{
    NSMutableArray *data = [NSMutableArray new];
    for (int i = 1; i <= 100; ++i) {
        [data addObject:@(i)];
    }
    
    self.tree = [[NSTree alloc] initWithNodeCapacity:NODE_CAPACITY withSortedObjects:data];
    
    XCTAssertTrue(self.tree, @"Tree does not exist");
    XCTAssertEqual(self.tree.count, (int)data.count, @"Tree count != data count"); 
    XCTAssertEqual(self.tree.count, [self.tree trueCount], @"Truecount != count"); 
    
    NSLog(@"TREE: \n%@", [self.tree printTree]);
}

- (void)testBulkLoad1000000
{
    NSMutableArray *data = [NSMutableArray new];
    for (int i = 1; i <= 1000000; ++i) {
        [data addObject:@(i)];
    }
    
    self.tree = [[NSTree alloc] initWithNodeCapacity:NODE_CAPACITY withSortedObjects:data];
    
    XCTAssertEqual(self.tree.count, (int)data.count, @"Tree count != data count"); 
    XCTAssertEqual(self.tree.count, [self.tree trueCount], @"Truecount != count"); 
}

- (void)testTraverseInorder
{
    for (int i = 1; i <= 10; ++i) {
        [self.tree addObject:@(i)];
    }
    NSLog(@"Tree: \n%@", [self.tree printTree]);  
    
    NSMutableArray *storage = [NSMutableArray new];
    [self.tree traverse:^bool(NSTreeNode *node, id data, id extra) {
        [(NSMutableArray *)extra addObject:data];
        return true;
    } extraData:storage withAlgorithm:NSTreeTraverseAlgorithmInorder];
    
    XCTAssertEqual((int)storage.count, self.tree.count, @"Tree count != traverse count");
    NSLog(@"Traverse: %@", storage);
}

- (void)testTraversePreorder
{
    for (int i = 1; i <= 10; ++i) {
        [self.tree addObject:@(i)];
    }
    NSLog(@"Tree: \n%@", [self.tree printTree]);   
    
    NSMutableArray *storage = [NSMutableArray new];
    [self.tree traverse:^bool(NSTreeNode *node, id data, id extra) {
        [(NSMutableArray *)extra addObject:data];
        return true;
    } extraData:storage withAlgorithm:NSTreeTraverseAlgorithmPreorder];
    
    XCTAssertEqual((int)storage.count, self.tree.count, @"Tree count != traverse count");
    NSLog(@"Traverse: %@", storage);
}

- (void)testTraversePostorder
{
    for (int i = 1; i <= 10; ++i) {
        [self.tree addObject:@(i)];
    }
    NSLog(@"Tree: \n%@", [self.tree printTree]); 
    
    NSMutableArray *storage = [NSMutableArray new];
    [self.tree traverse:^bool(NSTreeNode *node, id data, id extra) {
        [(NSMutableArray *)extra addObject:data];
        return true;
    } extraData:storage withAlgorithm:NSTreeTraverseAlgorithmPostorder];
    
    XCTAssertEqual((int)storage.count, self.tree.count, @"Tree count != traverse count");
    NSLog(@"Traverse: %@", storage);
}

- (void)testTraverseBFS
{
    for (int i = 1; i <= 10; ++i) {
        [self.tree addObject:@(i)];
    }
    NSLog(@"Tree: \n%@", [self.tree printTree]);
    
    NSMutableArray *storage = [NSMutableArray new];
    [self.tree traverse:^bool(NSTreeNode *node, id data, id extra) {
        [(NSMutableArray *)extra addObject:data];
        return true;
    } extraData:storage withAlgorithm:NSTreeTraverseAlgorithmBreadthFirst];
    
    XCTAssertEqual((int)storage.count, self.tree.count, @"Tree count != traverse count");
    NSLog(@"Traverse: %@", storage);
}

- (void)testCache
{
    int addAmount = 100;
    for (int i = 1; i <= addAmount; ++i) {
        [self.tree addObject:@(i)];
    }
    
    NSArray *cache = [self.tree toArray];
    XCTAssertEqual((int)cache.count, self.tree.count, @"Tree count != cache count"); 
    XCTAssertEqual((int)cache.count, addAmount, @"Cache count != 10");  
    for (id object in cache) { // Check object contains 
        XCTAssertTrue([self.tree containsObject:object], @"Object not in tree: %@", object);
    }
    
    // Add new object
    [self.tree addObject:@11];
    
    // Check cache is refreshed properly
    cache = [self.tree toArray];
    XCTAssertEqual((int)cache.count, self.tree.count, @"Tree count != cache count"); 
    XCTAssertEqual((int)cache.count, addAmount + 1, @"Cache count != 11");   
    for (id object in cache) { // Check object contains 
        XCTAssertTrue([self.tree containsObject:object], @"Object not in tree: %@", object);
    }
    XCTAssertTrue([self.tree containsObject:@11], @"11 not in tree"); 
}

- (void)testObjectAtIndex
{
    int addAmount = 100;
    for (int i = 1; i <= addAmount; ++i) {
        [self.tree addObject:@(i)];
    }
    
    // Check objects exist and are equal
    for (int i = 0; i < addAmount; ++i) 
    {
        NSNumber *object = [self.tree objectAtIndex:i];
        XCTAssertNotNil(object, @"Object nil at index %i", i);
        XCTAssertEqual([object intValue], i + 1, @"Object not equal at index %i", i);
    }
}

- (void)testFastEnumeration
{
    int addAmount = 100;
    for (int i = 1; i <= addAmount; ++i) {
        [self.tree addObject:@(i)];
    }
     
    // Fast Enum
    int i = 0;
    for (id object in self.tree) {
        NSLog(@"%@", object);
        XCTAssertNotNil(object, @"Object nil in FE at index %i", i);
        XCTAssertEqual([object intValue], i + 1, @"Object not equal in FE at index %i", i); 
        i++;
    }
    
    XCTAssertEqual(i, addAmount, @"Didn't iterate through all elements");
}


- (void)testFastEnumerationBulk
{
    int addAmount = 100;
    NSMutableArray *array = [NSMutableArray new];
    for (int i = 1; i <= addAmount; ++i) {
        [array addObject:@(i)];
    }
    self.tree = [[NSTree alloc] initWithNodeCapacity:NODE_CAPACITY withSortedObjects:array];
     
    // Fast Enum
    int i = 0;
    for (id object in self.tree) {
        NSLog(@"%@", object);
        XCTAssertNotNil(object, @"Object nil in FE at index %i", i);
        XCTAssertEqual([object intValue], i + 1, @"Object not equal in FE at index %i", i); 
        i++;
    }
    
    XCTAssertEqual(i, addAmount, @"Didn't iterate through all elements");
}


@end
