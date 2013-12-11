//
//  NSTreeExampleLoadBenchmarks.m
//  NSTreeExampleLoadBenchmarks
//
//  Created by . Carlin on 11/18/13.
//  Copyright (c) 2013 Carlin Creations. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "NSTree.h"

@interface NSTreeExampleLoadBenchmarks : XCTestCase

    @property (nonatomic, strong) NSTree *tree3;
    @property (nonatomic, strong) NSTree *tree30;
    @property (nonatomic, strong) NSTree *tree300; 
    @property (nonatomic, strong) NSMutableArray *array;
    @property (nonatomic, strong) NSMutableDictionary *dict;
    @property (nonatomic, strong) NSMutableArray *data;  
    
@end

@implementation NSTreeExampleLoadBenchmarks

- (void)setUp
{
    [super setUp];
    
    // Setup data
    self.data = [NSMutableArray new]; 
    for (int i = 1; i <= 1000000; ++i) {
        [self.data addObject: @(i)];
    }   
    
    // Structures
    self.tree3 = [[NSTree alloc] initWithNodeCapacity:3];   
    self.tree30 = [[NSTree alloc] initWithNodeCapacity:30];  
    self.tree300 = [[NSTree alloc] initWithNodeCapacity:300];  
    self.array = [NSMutableArray new];
    self.dict = [NSMutableDictionary new]; 
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testLoadTree3
{
    for (id object in self.data) {
        [self.tree3 addObject:object];
    }
}

- (void)testLoadTree3Bulk
{
    self.tree3 = [[NSTree alloc] initWithNodeCapacity:3 withSortedObjects:self.data];
}

- (void)testLoadTree30
{
    for (id object in self.data) {
        [self.tree30 addObject:object];
    }
}

- (void)testLoadTree30Bulk
{
    self.tree30 = [[NSTree alloc] initWithNodeCapacity:30 withSortedObjects:self.data];
}

- (void)testLoadTree300
{
    for (id object in self.data) {
        [self.tree300 addObject:object];
    }
}

- (void)testLoadTree300Bulk
{
    self.tree300 = [[NSTree alloc] initWithNodeCapacity:300 withSortedObjects:self.data];
}

- (void)testLoadArray
{
    for (id object in self.data) {
        [self.array addObject:object];
    }
}

- (void)testLoadArrayBulk
{
    [self.array addObjectsFromArray:self.data];
}

- (void)testLoadDict
{
    for (id object in self.data) {
        [self.dict setObject:object forKey:[object description]];
    }
}


@end
