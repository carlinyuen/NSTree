//
//  NSTreeExampleFunctionBenchmarks.m
//  NSTreeExampleFunctionBenchmarks
//
//  Created by . Carlin on 11/18/13.
//  Copyright (c) 2013 Carlin Creations. All rights reserved.
//

#import <XCTest/XCTest.h>

#include <stdlib.h>
#import <CoreData/CoreData.h>

#import "NSTree.h"

    #define NUM_ELEMENTS 1000000

@interface NSTreeExampleFunctionBenchmarks : XCTestCase
@end

static NSTree *tree3;
static NSTree *tree30;
static NSTree *tree300; 
static NSMutableArray *array; 
static NSMutableDictionary *dict; 
static NSMutableArray *data; 
static NSMutableArray *searchCriteria;
static NSMutableArray *insertCriteria;
static NSMutableArray *deleteCriteria;

static NSManagedObjectModel *mom;
static NSManagedObjectContext *moc;

@implementation NSTreeExampleFunctionBenchmarks

+ (void)setUp
{
    [super setUp];
     
    // Setup data
    data = [NSMutableArray new]; 
    for (int i = 1; i <= NUM_ELEMENTS; ++i) {
        [data addObject: @(i)];
    }
    
    // Criteria
    searchCriteria = [NSMutableArray new];  
    insertCriteria = [NSMutableArray new];  
    deleteCriteria = [NSMutableArray new]; 
    for (int i = 0; i < NUM_ELEMENTS / 1000; ++i) {
       [searchCriteria addObject:@(arc4random() % data.count)];
       [insertCriteria addObject:@(arc4random() % data.count)];  
       [deleteCriteria addObject:@(arc4random() % data.count)];   
    }

    // Data Structures
    tree3 = [[NSTree alloc] initWithNodeCapacity:3 withSortedObjects:data];   
    tree30 = [[NSTree alloc] initWithNodeCapacity:30 withSortedObjects:data];  
    tree300 = [[NSTree alloc] initWithNodeCapacity:300 withSortedObjects:data];  
    array = [[NSMutableArray alloc] initWithArray:data];
    dict = [NSMutableDictionary new]; 
    for (id object in data) {
        [dict setObject:object forKey:[object description]];
    } 
    
    // Setup CoreData - simple Entity entry:value
    NSEntityDescription *runEntity = [[NSEntityDescription alloc] init];
    [runEntity setName:@"Entry"];
    [runEntity setManagedObjectClassName:@"Entry"];
     
    NSAttributeDescription *attr= [[NSAttributeDescription alloc] init];
    [attr setName:@"value"];
    [attr setAttributeType:NSInteger32AttributeType];
    [attr setOptional:false];
    [attr setIndexed:true];
    [attr setDefaultValue:@0];
    [runEntity setProperties:@[attr]];
    
    // Managed Object Model
    mom = [[NSManagedObjectModel alloc] init]; 
    [mom setEntities:@[runEntity]]; 
    
    // Persistent Store - use in-memory
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    NSError *error = nil;
    [psc addPersistentStoreWithType:NSInMemoryStoreType
        configuration:nil URL:nil options:nil error:&error];
    if (error) {
        NSLog(@"Error creating persistent store: %@", error);
    }
    
    // Managed Object Context
    moc = [[NSManagedObjectContext alloc] init];
    moc.persistentStoreCoordinator = psc;

    NSManagedObject *mo;
    for (id object in data) {
        mo = [NSEntityDescription 
            insertNewObjectForEntityForName:@"Entry" 
            inManagedObjectContext:moc]; 
        [mo setValue:object forKey:@"value"]; 
    }
    error = nil;
    if (![moc save:&error]) {
        NSLog(@"Error populating core data: %@", error); 
    }
}

+ (void)tearDown
{
    NSFetchRequest *fetch = [[NSFetchRequest alloc] initWithEntityName:@"Entry"]; 
    NSError *error = nil;
    NSArray *results = [moc executeFetchRequest:fetch error:&error]; 
    if (error) {
        NSLog(@"Fetching from Core Data Failed: %@", error); 
    }
    NSLog(@"Results: %i", results.count); 

    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

#pragma mark - Insertion

- (void)testInsertTree3 {
    for (id object in insertCriteria) {
        [tree3 addObject:object];
    }
}

- (void)testInsertTree30 {
    for (id object in insertCriteria) {
        [tree30 addObject:object];
    }
}

- (void)testInsertTree300 {
    for (id object in insertCriteria) {
        [tree300 addObject:object];
    }
}

- (void)testInsertArray {
    for (id object in insertCriteria) {
        [array insertObject:object atIndex:[array indexOfObject:object inSortedRange:NSMakeRange(0, array.count - 1) options:NSBinarySearchingInsertionIndex usingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [obj1 compare:obj2];
        }]];
    }
}

- (void)testInsertDict {
    for (id object in insertCriteria) {
        [dict setObject:object forKey:[object description]];
    }
}

- (void)testInsertCoreData {
    NSManagedObject *mo;
    for (id object in insertCriteria) {
        mo = [NSEntityDescription 
              insertNewObjectForEntityForName:@"Entry" 
              inManagedObjectContext:moc]; 
        [mo setValue:object forKey:@"value"]; 
    }
    NSError *error = nil;
    if (![moc save:&error]) {
        NSLog(@"Populating CoreData Failed: %@", error);
    }
}


#pragma mark - Deletion

- (void)testDeleteTree3 {
    for (id object in deleteCriteria) {
        [tree3 removeObject:object];
    }
}

- (void)testDeleteTree30 {
    for (id object in deleteCriteria) {
        [tree30 removeObject:object];
    }
}

- (void)testDeleteTree300 {
    for (id object in deleteCriteria) {
        [tree300 removeObject:object];
    }
}

- (void)testDeleteArray {
    for (id object in deleteCriteria) {
        [array removeObject:object];
    }
}

- (void)testDeleteDict {
    for (id object in deleteCriteria) {
        [dict removeObjectForKey:[object description]];  
    }
}

- (void)testDeleteCoreData {
    NSFetchRequest *fetch = [[NSFetchRequest alloc] initWithEntityName:@"Entry"]; 
    NSPredicate *p = [NSPredicate predicateWithFormat:@"value == %@", [deleteCriteria componentsJoinedByString:@" OR value == "]]; 
    [fetch setPredicate:p]; 
    NSError *error;
    NSArray *results = [moc executeFetchRequest:fetch error:&error]; 
    if (error) {
        NSLog(@"Error fetching criteria: %@", error);
    }
    NSLog(@"Results: %i", results.count); 
    
    // Delete
    for (id object in results) {
        [moc deleteObject:object];
    }
    
    if (![moc save:&error]) {
        NSLog(@"Error deleting from core data: %@", error); 
    }
}


#pragma mark - Search

- (void)testSearchTree3 {
    for (id object in searchCriteria) {
        [tree3 containsObject:object];
    }
}

- (void)testSearchTree30 {
    for (id object in searchCriteria) {
        [tree30 containsObject:object];
    }
}

- (void)testSearchTree300 {
    for (id object in searchCriteria) {
        [tree300 containsObject:object];
    }
}

- (void)testSearchArray {
    for (id object in searchCriteria) {
        [array containsObject:object];
    }
}

- (void)testSearchDict {
    for (id object in searchCriteria) {
        [dict objectForKey:[object description]];  
    }
}

- (void)testSearchCoreData {
    NSFetchRequest *fetch = [[NSFetchRequest alloc] initWithEntityName:@"Entry"]; 
    NSPredicate *p = [NSPredicate predicateWithFormat:@"value == %@", [searchCriteria componentsJoinedByString:@" OR value == "]]; 
    [fetch setPredicate:p]; 
    NSError *error;
    NSArray *results = [moc executeFetchRequest:fetch error:&error]; 
    if (error) {
        NSLog(@"Error fetching criteria: %@", error);
    }
    NSLog(@"Results: %i", results.count); 
}

@end
