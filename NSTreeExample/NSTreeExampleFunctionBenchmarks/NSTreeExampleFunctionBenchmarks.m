//
//  NSTreeExampleFunctionBenchmarks.m
//  NSTreeExampleFunctionBenchmarks
//
//  Created by . Carlin on 11/18/13.
//  Copyright (c) 2013 Carlin Creations. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "NSTree.h"

@interface NSTreeExampleFunctionBenchmarks : XCTestCase

    @property (nonatomic, strong) NSTree *tree3;
    @property (nonatomic, strong) NSTree *tree30;
    @property (nonatomic, strong) NSTree *tree300; 
    
    @property (nonatomic, strong) NSMutableArray *array10;
    @property (nonatomic, strong) NSMutableArray *array1000; 
    @property (nonatomic, strong) NSMutableArray *array1000000; 
    
    @property (nonatomic, strong) NSMutableDictionary *dict10;
    @property (nonatomic, strong) NSMutableDictionary *dict1000; 
    @property (nonatomic, strong) NSMutableDictionary *dict1000000; 
       
    @property (nonatomic, strong) NSMutableArray *data10;
    @property (nonatomic, strong) NSMutableArray *data1000; 
    @property (nonatomic, strong) NSMutableArray *data1000000;  
    
@end

@implementation NSTreeExampleFunctionBenchmarks

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
   
        // Trees
        self.tree3 = [[NSTree alloc] initWithNodeCapacity:3 withSortedObjects:self.data10];   
        self.tree30 = [[NSTree alloc] initWithNodeCapacity:30 withSortedObjects:self.data1000];  
        self.tree300 = [[NSTree alloc] initWithNodeCapacity:300 withSortedObjects:self.data1000000];  
        
        // Arrays
        self.array10 = [[NSMutableArray alloc] initWithArray:self.data10];
        self.array1000 = [[NSMutableArray alloc] initWithArray:self.data1000]; 
        self.array1000000 = [[NSMutableArray alloc] initWithArray:self.data1000000];
        
        // Dictionaries
        self.dict10 = [NSMutableDictionary new];  
        for (id object in self.data10) {
            [self.dict10 setObject:object forKey:[object description]];
        }
        self.dict1000 = [NSMutableDictionary new];  
        for (id object in self.data1000) {
            [self.dict1000 setObject:object forKey:[object description]];
        } 
        self.dict1000000 = [NSMutableDictionary new]; 
        for (id object in self.data1000000) {
            [self.dict1000000 setObject:object forKey:[object description]];
        } 
    } 
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}

@end
