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
       
    @property (nonatomic, strong) NSMutableArray *data10;
    @property (nonatomic, strong) NSMutableArray *data1000; 
    @property (nonatomic, strong) NSMutableArray *data1000000;  
    
@end

@implementation NSTreeExampleLoadBenchmarks

- (void)setUp
{
    [super setUp];
    
    // Setup data
    if (!self.data10)
    {
        self.data10 = [NSMutableArray new];
        self.data1000 = [NSMutableArray new]; 
        self.data1000000 = [NSMutableArray new]; 
        for (int i = 1; i <= 1000000; ++i) {
            if (i <= 10) {[self.data10 addObject: @(i)];}
            if (i <= 1000) {[self.data1000 addObject: @(i)];} 
            [self.data1000000 addObject: @(i)];
        }   
    }
    
    // Trees
    self.tree3 = [[NSTree alloc] initWithNodeCapacity:3];   
    self.tree30 = [[NSTree alloc] initWithNodeCapacity:30];  
    self.tree300 = [[NSTree alloc] initWithNodeCapacity:300];  
    
    // Comparisons
    self.array = [NSMutableArray new];
    self.dict = [NSMutableDictionary new]; 
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testLoad10Tree3
{
    for (id object in self.data10) {
        [self.tree3 addObject:object];
    }
}

- (void)testload10Tree3Bulk
{
    self.tree3 = [[NSTree alloc] initWithNodeCapacity:3 withSortedObjects:self.data10];
}

- (void)testLoad10Array
{
    for (id object in self.data10) {
        [self.array addObject:object];
    }
}

- (void)testLoad10Dict
{
    for (id object in self.data10) {
        [self.dict setObject:object forKey:[object description]];
    }
}

- (void)testLoad1000Tree30
{
    for (id object in self.data1000) {
        [self.tree30 addObject:object];
    }
}

- (void)testLoad1000Tree30Bulk
{
    self.tree30 = [[NSTree alloc] initWithNodeCapacity:30 withSortedObjects:self.data1000];
}

- (void)testLoad1000Array
{
    for (id object in self.data1000) {
        [self.array addObject:object];
    }
}

- (void)testLoad1000Dict
{
    for (id object in self.data1000) {
        [self.dict setObject:object forKey:[object description]];
    }
}

- (void)testLoad1000000Tree300
{
    for (id object in self.data1000000) {
        [self.tree300 addObject:object];
    }
}

- (void)testLoad1000000Tree300Bulk
{
    self.tree300 = [[NSTree alloc] initWithNodeCapacity:300 withSortedObjects:self.data1000000];
}

- (void)testLoad1000000Array
{
    for (id object in self.data1000000) {
        [self.array addObject:object];
    }
}

- (void)testLoad1000000Dict
{
    for (id object in self.data1000000) {
        [self.dict setObject:object forKey:[object description]];
    }
}


@end
