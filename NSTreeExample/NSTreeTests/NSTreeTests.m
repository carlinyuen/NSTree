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

- (void)testAddMany
{
    for (int i = 1; i <= 10; ++i) {
        [self.tree addObject:@(i)];
    }
    XCTAssertEqual(self.tree.count, 10, @"Count is not 10");   
    
    NSNumber *min = [self.tree minimum];
    NSNumber *max = [self.tree maximum]; 
    XCTAssertNotNil(min, @"Min is nil");
    XCTAssertNotNil(max, @"Max is nil");   
    XCTAssertEqual(min, @1, @"Min is not 1");
    XCTAssertEqual(max, @10, @"Max is not 10"); 
}

- (void)testRemoveMany
{
    for (int i = 1; i <= 10; ++i) {
        [self.tree addObject:@(i)];
    }
    
    XCTAssertTrue([self.tree removeObject:@1], @"Could not remove 1");
}


@end
