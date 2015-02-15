//
//  HashTableTests.m
//  CoreDataHotels
//
//  Created by Alexandra Norcross on 2/13/15.
//  Copyright (c) 2015 Alexandra Norcross. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "HashTable.h"
#import "Bucket.h"

@interface HashTableTests : XCTestCase
@property (nonatomic) HashTable *hashTable;
@end

@implementation HashTableTests

- (void)setUp {
  [super setUp];
  // Put setup code here. This method is called before the invocation of each test method in the class.
  
  _hashTable = [[HashTable alloc] initForSize:2];
  Bucket *bucket1 = [[Bucket alloc] init];
  Bucket *bucket2 = [[Bucket alloc] init];
  Bucket *bucket3 = [[Bucket alloc] init];
  [_hashTable addItem:bucket1 forKey:@"one"];
  [_hashTable addItem:bucket2 forKey:@"two"];
  [_hashTable addItem:bucket3 forKey:@"three"];
} //end func

- (void)tearDown {
  // Put teardown code here. This method is called after the invocation of each test method in the class.
  [super tearDown];
  
  _hashTable = nil;
}

- (void) testAddItemForKey {
  //Check that item was added.
  XCTAssertNotNil([_hashTable getItemForKey:@"two"], @"ugh!");
} //end func

- (void) testRemoveItemForKey {
  //Add item.
  [_hashTable removeItemForKey:@"two"];
  //Check that item was removed.
  XCTAssertNil([_hashTable getItemForKey:@"two"], @"ugh!");
} //end func

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
