//
//  NSTreeExampleFunctionBenchmarks.m
//  NSTreeExampleFunctionBenchmarks
//
//  Created by . Carlin on 11/18/13.
//  Copyright (c) 2013 Carlin Creations. All rights reserved.
//

#import <XCTest/XCTest.h>

#include <stdlib.h>

#import "NSTree.h"

@interface NSTreeExampleFunctionBenchmarks : XCTestCase

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

static NSMutableArray *searchCriteria10;
static NSMutableArray *searchCriteria1000;
static NSMutableArray *searchCriteria1000000;

static NSMutableArray *insertCriteria10;
static NSMutableArray *insertCriteria1000;
static NSMutableArray *insertCriteria1000000;

static NSMutableArray *deleteCriteria10;
static NSMutableArray *deleteCriteria1000;
static NSMutableArray *deleteCriteria1000000;

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
    
    // Criteria
    searchCriteria10 = [NSMutableArray new];
    searchCriteria1000 = [NSMutableArray new]; 
    searchCriteria1000000 = [NSMutableArray new];  
    insertCriteria10 = [NSMutableArray new];
    insertCriteria1000 = [NSMutableArray new]; 
    insertCriteria1000000 = [NSMutableArray new];  
    deleteCriteria10 = [NSMutableArray new];
    deleteCriteria1000 = [NSMutableArray new]; 
    deleteCriteria1000000 = [NSMutableArray new]; 
    for (int i = 0; i < 1000; ++i) {
        if (i < data10.count / 2) {
            [searchCriteria10 addObject:@(arc4random() % data10.count)];
            [insertCriteria10 addObject:@(arc4random() % data10.count)]; 
            [deleteCriteria10 addObject:@(arc4random() % data10.count)]; 
        }
        if (i < data1000.count / 2) {
            [searchCriteria1000 addObject:@(arc4random() % data1000.count)];
            [insertCriteria1000 addObject:@(arc4random() % data1000.count)]; 
            [deleteCriteria1000 addObject:@(arc4random() % data1000.count)];  
        }
       [searchCriteria1000000 addObject:@(arc4random() % data1000000.count)];
       [insertCriteria1000000 addObject:@(arc4random() % data1000000.count)];  
       [deleteCriteria1000000 addObject:@(arc4random() % data1000000.count)];   
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
    for (id object in insertCriteria10) {
        [tree3 addObject:object];
    }
}

- (void)testInsertArray10 {
    for (id object in insertCriteria10) {
        [array10 insertObject:object atIndex:[array10 indexOfObject:object inSortedRange:NSMakeRange(0, array10.count - 1) options:NSBinarySearchingInsertionIndex usingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [obj1 compare:obj2];
        }]];
    }
}

- (void)testInsertDict10 {
    for (id object in insertCriteria10) {
        [dict10 setObject:object forKey:[object description]];
    }
}

- (void)testInsertTree30 {
    for (id object in insertCriteria1000) {
        [tree30 addObject:object];
    }
}

- (void)testInsertArray1000 {
    for (id object in insertCriteria1000) {
        [array1000 insertObject:object atIndex:[array1000 indexOfObject:object inSortedRange:NSMakeRange(0, array1000.count - 1) options:NSBinarySearchingInsertionIndex usingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [obj1 compare:obj2];
        }]];
    }
}

- (void)testInsertDict1000 {
    for (id object in insertCriteria1000) {
        [dict1000 setObject:object forKey:[object description]];
    }
}

- (void)testInsertTree300 {
    for (id object in insertCriteria1000000) {
        [tree300 addObject:object];
    }
}

- (void)testInsertArray1000000 {
    for (id object in insertCriteria1000000) {
        [array1000000 insertObject:object atIndex:[array1000000 indexOfObject:object inSortedRange:NSMakeRange(0, array1000000.count - 1) options:NSBinarySearchingInsertionIndex usingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [obj1 compare:obj2];
        }]];
    }
}

- (void)testInsertDict1000000 {
    for (id object in insertCriteria1000000) {
        [dict1000000 setObject:object forKey:[object description]];
    }
}


#pragma mark - Deletion

- (void)testDeleteTree3 {
    for (id object in deleteCriteria10) {
        [tree3 removeObject:object];
    }
}

- (void)testDeleteArray10 {
    for (id object in deleteCriteria10) {
        [array10 removeObject:object];
    }
}

- (void)testDeleteDict10 {
    for (id object in deleteCriteria10) {
        [dict10 removeObjectForKey:[object description]];
    }
}

- (void)testDeleteTree30 {
    for (id object in deleteCriteria1000) {
        [tree30 removeObject:object];
    }
}

- (void)testDeleteArray1000 {
    for (id object in deleteCriteria1000) {
        [array1000 removeObject:object];
    }
}

- (void)testDeleteDict1000 {
    for (id object in deleteCriteria1000) {
        [dict1000 removeObjectForKey:[object description]]; 
    }
}

- (void)testDeleteTree300 {
    for (id object in deleteCriteria1000000) {
        [tree300 removeObject:object];
    }
}

- (void)testDeleteArray1000000 {
    for (id object in deleteCriteria1000000) {
        [array1000000 removeObject:object];
    }
}

- (void)testDeleteDict1000000 {
    for (id object in deleteCriteria1000000) {
        [dict1000000 removeObjectForKey:[object description]];  
    }
}


#pragma mark - Search

- (void)testSearchTree3 {
    for (id object in searchCriteria10) {
        [tree3 containsObject:object];
    }
}

- (void)testSearchArray10 {
    for (id object in searchCriteria10) {
        [array10 containsObject:object];
    }
}

- (void)testSearchDict10 {
    for (id object in searchCriteria10) {
        [dict10 objectForKey:[object description]];
    }
}

- (void)testSearchTree30 {
    for (id object in searchCriteria1000) {
        [tree30 containsObject:object];
    }
}

- (void)testSearchArray1000 {
    for (id object in searchCriteria1000) {
        [array1000 containsObject:object];
    }
}

- (void)testSearchDict1000 {
    for (id object in searchCriteria1000) {
        [dict1000 objectForKey:[object description]]; 
    }
}

- (void)testSearchTree300 {
    for (id object in searchCriteria1000000) {
        [tree300 containsObject:object];
    }
}

- (void)testSearchArray1000000 {
    for (id object in searchCriteria1000000) {
        [array1000000 containsObject:object];
    }
}

- (void)testSearchDict1000000 {
    for (id object in searchCriteria1000000) {
        [dict1000000 objectForKey:[object description]];  
    }
}

@end
