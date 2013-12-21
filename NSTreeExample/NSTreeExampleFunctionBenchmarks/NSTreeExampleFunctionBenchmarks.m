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

    // # objects to preload structure with
    #define NUM_ELEMENTS 100000
    
    // # objects to search / insert / delete
    #define NUM_CRITERIA 100 

    #define TREE 1
    #define ARRAY 1
    #define DICT 1
    #define CORE 1

@interface NSTreeExampleFunctionBenchmarks : XCTestCase
@end

static NSTree *tree3;       // Tree of node capacity 3
static NSTree *tree30;      // Tree of node capacity 30
static NSTree *tree300;     // Tree of node capacity 300
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
    
    // For timing purposes
    NSDate *startDate = [NSDate date];
     
    // Setup data
    data = [NSMutableArray new]; 
    for (int i = 1; i <= NUM_ELEMENTS; ++i) {
        [data addObject: @(i)];
    }
    
    // Criteria
    NSLog(@"# to Search / Delete / Insert: %i", NUM_CRITERIA);
    searchCriteria = [NSMutableArray new];  
    insertCriteria = [NSMutableArray new];  
    deleteCriteria = [NSMutableArray new]; 
    for (int i = 0; i < NUM_CRITERIA; ++i) {
       [searchCriteria addObject:@(arc4random() % data.count)];
       [insertCriteria addObject:@(arc4random() % data.count)];  
       [deleteCriteria addObject:@(arc4random() % data.count)];   
    }

    // Data Structures
    if (TREE) {
        NSLog(@"Creating Trees");
        tree3 = [[NSTree alloc] initWithNodeCapacity:3 withSortedObjects:data];   
        tree30 = [[NSTree alloc] initWithNodeCapacity:30 withSortedObjects:data];  
        tree300 = [[NSTree alloc] initWithNodeCapacity:300 withSortedObjects:data];  
        NSLog(@"Tree3 Count: %i", tree3.count);  
        NSLog(@"Tree30 Count: %i", tree30.count);   
        NSLog(@"Tree300 Count: %i", tree300.count);   
    }
    if (ARRAY) {
        NSLog(@"Creating Array"); 
        array = [[NSMutableArray alloc] initWithArray:data];
        NSLog(@"Array Count: %i", array.count); 
    }
    if (DICT) {
        NSLog(@"Creating Dict");  
        dict = [NSMutableDictionary new]; 
        for (id object in data) {
            [dict setObject:object forKey:[object description]];
        } 
        NSLog(@"Dict Count: %i", dict.count);
    }
    
    if (CORE) 
    {
        NSLog(@"Creating Core Data");   
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
        
        // Persistent Store - use sqlite because in-mem is too slow
        NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
        NSError *error = nil;
    //    [psc addPersistentStoreWithType:NSInMemoryStoreType
    //        configuration:nil URL:nil options:nil error:&error]; 
        NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent: @"NSTreeExampleFunctionBenchmarks.sqlite"];
        [psc addPersistentStoreWithType:NSSQLiteStoreType 
            configuration:nil URL:[NSURL fileURLWithPath:path] 
            options:nil error:&error];
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
        
        NSFetchRequest *fetch = [[NSFetchRequest alloc] initWithEntityName:@"Entry"]; 
        error = nil;
        NSArray *results = [moc executeFetchRequest:fetch error:&error]; 
        if (error) {
            NSLog(@"Fetching from Core Data Failed: %@", error); 
        }
        NSLog(@"Core Data Entry Count: %i", results.count); 
    }
    
    // End timer
    NSLog(@"Setup Time Completion: %f", -[startDate timeIntervalSinceNow]);
}

+ (void)tearDown
{
    if (CORE)
    {
        // Cleanup Core Data
        NSError *error;
        [[NSFileManager defaultManager] removeItemAtPath:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent: @"NSTreeExampleFunctionBenchmarks.sqlite"] error:&error];
        if (error) {
            NSLog(@"ERROR : Deleting Core Data Store : %@", error);
        } else {
            NSLog(@"Successful cleanup of Core Data Store");
        }
    }

    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

#pragma mark - Insertion

- (void)testInsertTree3 {
    if (!TREE) return;
    for (id object in insertCriteria) {
        [tree3 addObject:object];
    }
}

- (void)testInsertTree30 {
    if (!TREE) return;
    for (id object in insertCriteria) {
        [tree30 addObject:object];
    }
}

- (void)testInsertTree300 {
    if (!TREE) return;
    for (id object in insertCriteria) {
        [tree300 addObject:object];
    }
}

- (void)testInsertArray {
    if (!ARRAY) return;
    for (id object in insertCriteria) {
        [array insertObject:object atIndex:[array indexOfObject:object inSortedRange:NSMakeRange(0, array.count - 1) options:NSBinarySearchingInsertionIndex usingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [obj1 compare:obj2];
        }]];
    }
}

- (void)testInsertDict {
    if (!DICT) return;
    for (id object in insertCriteria) {
        [dict setObject:object forKey:[object description]];
    }
}

- (void)testInsertCoreData {
    if (!CORE) return;
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
    if (!TREE) return;
    for (id object in deleteCriteria) {
        [tree3 removeObject:object];
    }
}

- (void)testDeleteTree30 {
    if (!TREE) return;
    for (id object in deleteCriteria) {
        [tree30 removeObject:object];
    }
}

- (void)testDeleteTree300 {
    if (!TREE) return;
    for (id object in deleteCriteria) {
        [tree300 removeObject:object];
    }
}

- (void)testDeleteArrayBulk {
    if (!ARRAY) return;
    [array removeObjectsInArray:deleteCriteria];
}

- (void)testDeleteArray {
    if (!ARRAY) return;
    for (id object in deleteCriteria) {
        [array removeObject:object];
    }
}

- (void)testDeleteDict {
    if (!DICT) return;
    for (id object in deleteCriteria) {
        [dict removeObjectForKey:[object description]];  
    }
}

- (void)testDeleteDictBulk {
    if (!DICT) return;
    [dict removeObjectsForKeys:deleteCriteria];
}

- (void)testDeleteCoreData {
    if (!CORE) return;
    NSFetchRequest *fetch = [[NSFetchRequest alloc] initWithEntityName:@"Entry"]; 
    NSError *error; 
    NSArray *results;
    for (id object in deleteCriteria) {
        [fetch setPredicate:[NSPredicate predicateWithFormat:@"value == %@", object]];
         
        results = [moc executeFetchRequest:fetch error:&error]; 
        if (error) {
            NSLog(@"Error fetching criteria: %@", error);
        }
         
        // Delete
        for (id object in results) {
            [moc deleteObject:object];
        }
    }
    
    if (![moc save:&error]) {
        NSLog(@"Error deleting from core data: %@", error); 
    }
}

- (void)testDeleteCoreDataBulk {
    if (!CORE) return;
    NSFetchRequest *fetch = [[NSFetchRequest alloc] initWithEntityName:@"Entry"]; 
    NSMutableArray *predicates = [NSMutableArray new];
    for (id object in deleteCriteria) {
        [predicates addObject:[NSPredicate predicateWithFormat:@"value == %@", object]];
    }
    NSError *error;  
    [fetch setPredicate:[NSCompoundPredicate orPredicateWithSubpredicates:predicates]];
    NSArray *results = [moc executeFetchRequest:fetch error:&error]; 
    if (error) {
        NSLog(@"Error fetching criteria: %@", error);
    }
    else  // Delete
    {
        for (id object in results) {
            [moc deleteObject:object];
        } 
           
        if (![moc save:&error]) {
            NSLog(@"Error deleting from core data: %@", error); 
        } 
    }
}


#pragma mark - Search

- (void)testSearchTree3 {
    if (!TREE) return;
    for (id object in searchCriteria) {
        [tree3 containsObject:object];
    }
}

- (void)testSearchTree30 {
    if (!TREE) return;
    for (id object in searchCriteria) {
        [tree30 containsObject:object];
    }
}

- (void)testSearchTree300 {
    if (!TREE) return;
    for (id object in searchCriteria) {
        [tree300 containsObject:object];
    }
}

- (void)testSearchArray {
    if (!ARRAY) return;
    for (id object in searchCriteria) {
        [array containsObject:object];
    }
}

- (void)testSearchDict {
    if (!DICT) return;
    for (id object in searchCriteria) {
        [dict objectForKey:[object description]];  
    }
}

- (void)testSearchCoreData {
    if (!CORE) return;
    NSFetchRequest *fetch = [[NSFetchRequest alloc] initWithEntityName:@"Entry"]; 
    NSError *error; 
    NSMutableArray *results = [NSMutableArray new];
    NSArray *temp;
    for (id object in searchCriteria) {
        [fetch setPredicate:[NSPredicate predicateWithFormat:@"value == %@", object]];
        temp = [moc executeFetchRequest:fetch error:&error]; 
        [results addObjectsFromArray:temp];
        if (error) {
            NSLog(@"Error fetching criteria: %@", error);
        }
    }
}

- (void)testSearchCoreDataBulk {
    if (!CORE) return;
    NSFetchRequest *fetch = [[NSFetchRequest alloc] initWithEntityName:@"Entry"]; 
    NSMutableArray *predicates = [NSMutableArray new];
    for (id object in searchCriteria) {
        [predicates addObject:[NSPredicate predicateWithFormat:@"value == %@", object]];
    }
    [fetch setPredicate:[NSCompoundPredicate orPredicateWithSubpredicates:predicates]];
    NSError *error;  
    NSArray *results = [moc executeFetchRequest:fetch error:&error]; 
    if (error) {
        NSLog(@"Error fetching criteria: %@", error);
    }
}

@end
