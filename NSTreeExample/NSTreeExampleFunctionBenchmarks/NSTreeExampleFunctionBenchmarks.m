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

    #define NUM_ELEMENTS 1000000    // This is extremely slow on CoreData functions
//    #define NUM_ELEMENTS 1000

    #define TREE 0
    #define ARRAY 0
    #define DICT 0
    #define CORE 1

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
    int numCriteria = MAX(1, NUM_ELEMENTS / 1000);
    for (int i = 0; i < numCriteria; ++i) {
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
    }
    if (ARRAY) {
        NSLog(@"Creating Array"); 
        array = [[NSMutableArray alloc] initWithArray:data];
    }
    if (DICT) {
        NSLog(@"Creating Dict");  
        dict = [NSMutableDictionary new]; 
        for (id object in data) {
            [dict setObject:object forKey:[object description]];
        } 
    }
    
    if (CORE) {
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
        
        // Persistent Store - use in-memory
        NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
        NSError *error = nil;
    //    [psc addPersistentStoreWithType:NSInMemoryStoreType
    //        configuration:nil URL:nil options:nil error:&error]; 
        NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent: @"NSTreeExampleFunctionBenchmarks.sqlite"];
        NSURL *url = [NSURL fileURLWithPath:path];
        [psc addPersistentStoreWithType:NSSQLiteStoreType 
            configuration:nil URL:url options:nil error:&error];
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
}

+ (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


#pragma mark - Insertion

#ifdef TREE
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
#endif

#ifdef ARRAY
- (void)testInsertArray {
    for (id object in insertCriteria) {
        [array insertObject:object atIndex:[array indexOfObject:object inSortedRange:NSMakeRange(0, array.count - 1) options:NSBinarySearchingInsertionIndex usingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [obj1 compare:obj2];
        }]];
    }
}
#endif

#ifdef DICT
- (void)testInsertDict {
    for (id object in insertCriteria) {
        [dict setObject:object forKey:[object description]];
    }
}
#endif

#ifdef CORE
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
#endif


#pragma mark - Deletion

#ifdef TREE
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
#endif

#ifdef ARRAY
- (void)testDeleteArrayBulk {
    [array removeObjectsInArray:deleteCriteria];
}

- (void)testDeleteArray {
    for (id object in deleteCriteria) {
        [array removeObject:object];
    }
}
#endif

#ifdef DICT
- (void)testDeleteDict {
    for (id object in deleteCriteria) {
        [dict removeObjectForKey:[object description]];  
    }
}

- (void)testDeleteDictBulk {
    [dict removeObjectsForKeys:deleteCriteria];
    NSLog(@"Delete Bulk Dict Count: %i", dict.count);
}
#endif

#ifdef CORE
// This is really slow if done with multiple deleteCriteria
- (void)testDeleteCoreData {
    NSFetchRequest *fetch = [[NSFetchRequest alloc] initWithEntityName:@"Entry"]; 
    NSError *error; 
    NSArray *results;
    for (id object in deleteCriteria) {
        [fetch setPredicate:[NSPredicate predicateWithFormat:@"value == %@", object]];
         
        results = [moc executeFetchRequest:fetch error:&error]; 
        if (error) {
            NSLog(@"Error fetching criteria: %@", error);
        }
        NSLog(@"Results: %@", results); 
         
        // Delete
        for (id object in results) {
            [moc deleteObject:object];
        }
               
        // This is incredibly slow on coredata and will take forever
        if (searchCriteria.count > 5) {
            break;
        } 
    }
    
    if (![moc save:&error]) {
        NSLog(@"Error deleting from core data: %@", error); 
    }
}
#endif


#pragma mark - Search

#ifdef TREE
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
#endif

#ifdef ARRAY
- (void)testSearchArray {
    for (id object in searchCriteria) {
        [array containsObject:object];
    }
}
#endif

#ifdef DICT
- (void)testSearchDict {
    for (id object in searchCriteria) {
        [dict objectForKey:[object description]];  
    }
}
#endif

#ifdef CORE
// Extremely slow when doing on a lot of items
- (void)testSearchCoreData {
    NSFetchRequest *fetch = [[NSFetchRequest alloc] initWithEntityName:@"Entry"]; 
    NSError *error; 
    NSMutableArray *results = [NSMutableArray new];
    NSArray *temp;
    for (id object in searchCriteria) {
        [fetch setPredicate:[NSPredicate predicateWithFormat:@"value == %@", object]];
        temp = [moc executeFetchRequest:fetch error:&error]; 
        NSLog(@"Fetched: %@", temp);
        [results addObjectsFromArray:temp];
        if (error) {
            NSLog(@"Error fetching criteria: %@", error);
        }
        
        // This is incredibly slow on coredata and will take forever
        if (searchCriteria.count > 5) {
            break;
        }
    }
}
#endif

@end
