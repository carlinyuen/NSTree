//
//  NSTreeExampleCapacityRatios.m
//  NSTreeExampleCapacityRatios
//
//  Created by . Carlin on 12/20/13.
//  Copyright (c) 2013 Carlin Creations. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "NSTree.h"

    #define NUM_ELEMENTS 100000
    
@interface NSTreeExampleCapacityRatios : XCTestCase

    @property (nonatomic, strong) NSMutableArray *trees;
    @property (nonatomic, strong) NSMutableArray *data; 
    
@end

@implementation NSTreeExampleCapacityRatios

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // Setup data
    self.data = [NSMutableArray new]; 
    for (int i = 1; i <= NUM_ELEMENTS; ++i) {
        [self.data addObject: @(arc4random() % NUM_ELEMENTS)];
    }   
    NSLog(@"Data count: %i", self.data.count);
    
    // Setup trees
    self.trees = [NSMutableArray new];
    for (int i = 3; i <= NUM_ELEMENTS; i *= 10) {
        NSLog(@"Capacity: %i", i);
        [self.trees addObject:[[NSTree alloc] initWithNodeCapacity:i]];
    }
    NSLog(@"# trees: %i", self.trees.count);
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testTreeInsert
{
    NSDate *start;
    for (NSTree *tree in self.trees) {
        NSLog(@"Inserting into tree with capcity: %i", tree.nodeCapacity);
        start = [NSDate date];
        for (id object in self.data) { 
            [tree addObject:object];
        }
        NSLog(@"Completed in %f", -[start timeIntervalSinceNow]);
    }
}

- (void)testTreeSearch
{
    // Populate first
    for (NSTree *tree in self.trees) {
        for (id object in self.data) { 
            [tree addObject:object];
        }
    }
    
    // Search
    NSDate *start;
    for (NSTree *tree in self.trees) {
        NSLog(@"Searching tree with capcity: %i", tree.nodeCapacity);
        start = [NSDate date];
        for (id object in self.data) { 
            [tree containsObject:object];
        }
        NSLog(@"Completed in %f", -[start timeIntervalSinceNow]);
    }
}

- (void)testTreeDelete
{
    // Populate first
    for (NSTree *tree in self.trees) {
        for (id object in self.data) { 
            [tree addObject:object];
        }
    }
    
    // Delete
    NSDate *start;
    for (NSTree *tree in self.trees) {
        NSLog(@"Deleting from tree with capcity: %i", tree.nodeCapacity);
        start = [NSDate date];
        for (id object in self.data) { 
            [tree removeObject:object];
        }
        NSLog(@"Completed in %f", -[start timeIntervalSinceNow]);
        XCTAssertEqual(tree.count, 0, @"%i Tree count %i not 0!", tree.nodeCapacity, tree.count);
        XCTAssertEqual([tree trueCount], 0, @"%i True count %i not 0!", tree.nodeCapacity, [tree trueCount]); 
    }
    
}

@end
