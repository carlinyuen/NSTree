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

//    @property (nonatomic, strong) NSTree *tree3;
//    @property (nonatomic, strong) NSTree *tree30;
//    @property (nonatomic, strong) NSTree *tree300; 
//    
//    @property (nonatomic, strong) NSMutableArray *array10;
//    @property (nonatomic, strong) NSMutableArray *array1000; 
//    @property (nonatomic, strong) NSMutableArray *array1000000; 
//    
//    @property (nonatomic, strong) NSMutableDictionary *dict10;
//    @property (nonatomic, strong) NSMutableDictionary *dict1000; 
//    @property (nonatomic, strong) NSMutableDictionary *dict1000000; 
//       
//    @property (nonatomic, strong) NSMutableArray *data10;
//    @property (nonatomic, strong) NSMutableArray *data1000; 
//    @property (nonatomic, strong) NSMutableArray *data1000000;  
    
@end

static NSTree *tree3;
static NSTree *tree30;
static NSTree *tree300; 

static NSMutableArray *array10;
static NSMutableArray *array1000; 
static NSMutableArray *array1000000; 

static NSMutableDictionary *dict10;
static NSMutableDictionary *dict1000; 
static NSMutableDictionary *dict1000000; 
   
static NSMutableArray *data10;
static NSMutableArray *data1000; 
static NSMutableArray *data1000000;  

@implementation NSTreeExampleFunctionBenchmarks

+ (void)setUp
{
    [super setUp];
     
    // Setup data
    data10 = [NSMutableArray new];
    data1000 = [NSMutableArray new]; 
    data1000000 = [NSMutableArray new]; 
    for (int i = 1; i <= 1000000; ++i) {
        if (i <= 10) {[data10 addObject: @(i)];}
        if (i <= 1000) {[data1000 addObject: @(i)];} 
        [data1000000 addObject: @(i)];
    }   

    // Trees
    tree3 = [[NSTree alloc] initWithNodeCapacity:3 withSortedObjects:data10];   
    tree30 = [[NSTree alloc] initWithNodeCapacity:30 withSortedObjects:data1000];  
    tree300 = [[NSTree alloc] initWithNodeCapacity:300 withSortedObjects:data1000000];  
    
    // Arrays
    array10 = [[NSMutableArray alloc] initWithArray:data10];
    array1000 = [[NSMutableArray alloc] initWithArray:data1000]; 
    array1000000 = [[NSMutableArray alloc] initWithArray:data1000000];
    
    // Dictionaries
    dict10 = [NSMutableDictionary new];  
    for (id object in data10) {
        [dict10 setObject:object forKey:[object description]];
    }
    dict1000 = [NSMutableDictionary new];  
    for (id object in data1000) {
        [dict1000 setObject:object forKey:[object description]];
    } 
    dict1000000 = [NSMutableDictionary new]; 
    for (id object in data1000000) {
        [dict1000000 setObject:object forKey:[object description]];
    } 
}

+ (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

#pragma mark - Insertion

- (void)testInsertTree3 {
    id object = @(data10.count / 2.0);
    [tree3 addObject:object];
}

- (void)testInsertArray10 {
    id object = @(data10.count / 2.0);
    [array10 insertObject:object atIndex:[array10 indexOfObject:object inSortedRange:NSMakeRange(0, array10.count - 1) options:NSBinarySearchingInsertionIndex usingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2];
    }]];
}

- (void)testInsertDict10 {
    id object = @(data10.count / 2.0);
    [dict10 setObject:object forKey:[object description]];
}

- (void)testInsertTree30 {
    id object = @(data1000.count / 2.0);
    [tree30 addObject:object];
}

- (void)testInsertArray1000 {
    id object = @(data1000.count / 2.0);
    [array1000 insertObject:object atIndex:[array1000 indexOfObject:object inSortedRange:NSMakeRange(0, array1000.count - 1) options:NSBinarySearchingInsertionIndex usingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2];
    }]];
}

- (void)testInsertDict1000 {
    id object = @(data1000.count / 2.0);
    [dict1000 setObject:object forKey:[object description]];
}

- (void)testInsertTree300 {
    id object = @(data1000000.count / 2.0);
    [tree300 addObject:object];
}

- (void)testInsertArray1000000 {
    id object = @(data1000000.count / 2.0);
    [array1000000 insertObject:object atIndex:[array1000000 indexOfObject:object inSortedRange:NSMakeRange(0, array1000000.count - 1) options:NSBinarySearchingInsertionIndex usingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2];
    }]];
}

- (void)testInsertDict1000000 {
    id object = @(data1000000.count / 2.0);
    [dict1000000 setObject:object forKey:[object description]];
}


#pragma mark - Deletion

- (void)testDeleteTree3 {
    id object = @(data10.count / 2.0);
    [tree3 removeObject:object];
}

- (void)testDeleteArray10 {
    id object = @(data10.count / 2.0);
    [array10 removeObject:object];
}

- (void)testDeleteDict10 {
    id object = @(data10.count / 2.0);
    [dict10 removeObjectForKey:[object description]];
}

- (void)testDeleteTree30 {
    id object = @(data1000.count / 2.0);
    [tree30 removeObject:object];
}

- (void)testDeleteArray1000 {
    id object = @(data1000.count / 2.0);
    [array1000 removeObject:object];
}

- (void)testDeleteDict1000 {
    id object = @(data1000.count / 2.0);
    [dict1000 removeObjectForKey:[object description]]; 
}

- (void)testDeleteTree300 {
    id object = @(data1000000.count / 2.0);
    [tree300 removeObject:object];
}

- (void)testDeleteArray1000000 {
    id object = @(data1000000.count / 2.0);
    [array1000000 removeObject:object];
}

- (void)testDeleteDict1000000 {
    id object = @(data1000000.count / 2.0);
    [dict1000000 removeObjectForKey:[object description]];  
}

@end
