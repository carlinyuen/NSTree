//
//  NSTreeExampleLoadBenchmarks.m
//  NSTreeExampleLoadBenchmarks
//
//  Created by . Carlin on 11/18/13.
//  Copyright (c) 2013 Carlin Creations. All rights reserved.
//

#import <XCTest/XCTest.h>

#import <CoreData/CoreData.h>

#import "NSTree.h"

    #define NUM_ELEMENTS 1000000

@interface NSTreeExampleLoadBenchmarks : XCTestCase

    @property (nonatomic, strong) NSTree *tree3;
    @property (nonatomic, strong) NSTree *tree30;
    @property (nonatomic, strong) NSTree *tree300; 
    @property (nonatomic, strong) NSMutableArray *array;
    @property (nonatomic, strong) NSMutableDictionary *dict;
    @property (nonatomic, strong) NSMutableArray *data;  
    @property (nonatomic, strong) NSManagedObjectModel *mom;
    @property (nonatomic, strong) NSManagedObjectContext *moc; 
    
@end

@implementation NSTreeExampleLoadBenchmarks

- (void)setUp
{
    [super setUp];
    
    // Setup data
    self.data = [NSMutableArray new]; 
    for (int i = 1; i <= NUM_ELEMENTS; ++i) {
        [self.data addObject: @(i)];
    }   
    
    // Structures
    self.tree3 = [[NSTree alloc] initWithNodeCapacity:3];   
    self.tree30 = [[NSTree alloc] initWithNodeCapacity:30];  
    self.tree300 = [[NSTree alloc] initWithNodeCapacity:300];  
    self.array = [NSMutableArray new];
    self.dict = [NSMutableDictionary new]; 
       
    // For timing purposes
    NSDate *startDate = [NSDate date]; 
    
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
    self.mom = [[NSManagedObjectModel alloc] init]; 
    [self.mom setEntities:@[runEntity]]; 
      
    // Persistent Store - use sqlite because in-mem is too slow
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.mom];
    NSError *error = nil;
//    [psc addPersistentStoreWithType:NSInMemoryStoreType
//        configuration:nil URL:nil options:nil error:&error]; 
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent: @"NSTreeExampleLoadBenchmarks.sqlite"];
    [psc addPersistentStoreWithType:NSSQLiteStoreType 
        configuration:nil URL:[NSURL fileURLWithPath:path] 
        options:nil error:&error];
    if (error) {
        NSLog(@"Error creating persistent store: %@", error);
    }
    
    // Managed Object Context
    self.moc = [[NSManagedObjectContext alloc] init];
    self.moc.persistentStoreCoordinator = psc;
     
    // End timer
    NSLog(@"Setup Time Completion: %f", -[startDate timeIntervalSinceNow]); 
}

- (void)tearDown
{
    // Cleanup Core Data
    NSError *error;
    [[NSFileManager defaultManager] removeItemAtPath:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent: @"NSTreeExampleLoadBenchmarks.sqlite"] error:&error];
    if (error) {
        NSLog(@"ERROR : Deleting Core Data Store : %@", error);
    } else {
        NSLog(@"Successful cleanup of Core Data Store");
    }
    
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

- (void)testLoadCoreData
{
    NSManagedObject *mo;
    for (id object in self.data) {
        mo = [NSEntityDescription 
            insertNewObjectForEntityForName:@"Entry" 
            inManagedObjectContext:self.moc]; 
        [mo setValue:object forKey:@"value"]; 
    }
    NSError *error = nil;
    if (![self.moc save:&error]) {
        NSLog(@"Populating CoreData Failed: %@", error);
    }
 
    NSFetchRequest *fetch = [[NSFetchRequest alloc] initWithEntityName:@"Entry"]; 
    error = nil;
    NSArray *results = [self.moc executeFetchRequest:fetch error:&error]; 
    if (error) {
        NSLog(@"Fetching from Core Data Failed: %@", error); 
    }
    NSLog(@"Core Data Entry Count: %i", results.count); 
}


@end
