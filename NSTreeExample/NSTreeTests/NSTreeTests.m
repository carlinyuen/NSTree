//
//  NSTreeTests.m
//  NSTreeTests
//
//  Created by . Carlin on 10/16/13.
//  Copyright (c) 2013 Carlin Creations. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "NSTree.h"

#define NODE_CAPACITY 2

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

- (void)testAddOne
{
    XCTAssertTrue([self.tree addObject:[NSNumber numberWithInt:1]], @"Failed to add");
    XCTAssertEqual(self.tree.count, 1, @"Count is not 1");
    XCTAssertNotNil([self.tree minimum], @"Min is nil");
    XCTAssertNotNil([self.tree maximum], @"Max is nil");  
}

- (void)testSearchInRoot
{
    [self.tree addObject:[NSNumber numberWithInt:5]];
    XCTAssertTrue([self.tree containsObject:[NSNumber numberWithInt:5]], @"Couldn't find number 5");
}

- (void)testSearchInTwoLevels
{
    for (int i = 1; i <= NODE_CAPACITY; ++i) {
        [self.tree addObject:[NSNumber numberWithInt:i]];
    }
    XCTAssertTrue([self.tree containsObject:[NSNumber numberWithInt:2]], @"Couldn't find number 2");
}

- (void)testRemoveOne
{
    [self.tree addObject:[NSNumber numberWithInt:1]];
    XCTAssertTrue([self.tree removeObject:[NSNumber numberWithInt:1]], @"Failed to remove");
    XCTAssertEqual(self.tree.count, 0, @"Count is not zero");
    XCTAssertNil([self.tree minimum], @"Min is not nil");
    XCTAssertNil([self.tree maximum], @"Max is not nil");  
}

- (void)testRemoveWhenEmpty
{
    XCTAssertFalse([self.tree removeObject:[NSNumber numberWithInt:1]], @"Remove worked even when empty");
    XCTAssertEqual(self.tree.count, 0, @"Count is not zero");
    XCTAssertNil([self.tree minimum], @"Min is not nil");
    XCTAssertNil([self.tree maximum], @"Max is not nil");  
}

@end
