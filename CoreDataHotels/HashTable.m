//
//  HashTable.m
//  CoreDataHotels
//
//  Created by Alexandra Norcross on 2/12/15.
//  Copyright (c) 2015 Alexandra Norcross. All rights reserved.
//

#import "HashTable.h"
#import "Bucket.h"

@interface HashTable()
@property (nonatomic) NSMutableArray *hashArray;
@property (nonatomic) NSInteger size;
@end

@implementation HashTable

//Initialize
- (instancetype) initForSize: (NSInteger)count {
  self = [super init];
  if (self) {
    _size = count;
    _hashArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < _size; i++) {
      Bucket *newBucket = [[Bucket alloc] init];
      [_hashArray addObject:newBucket];
    } //end for
  } //end if
  return self;
} //end func

//Hash - convert key to numeric
- (NSInteger) hashKey: (NSString *)key {
  NSInteger total = 0;
  NSInteger keyLength = key.length;
  for (int i = 0; i < keyLength; i++) {
    total = total + [key characterAtIndex:i];
  } //end for
  return total % _size;
} //end func

//Add item
- (void) addItem: (id)item forKey:(NSString *)key {
  //Index
  NSInteger index = [self hashKey:key];
  
  //New bucket
  Bucket *newBucket = [[Bucket alloc] init];
  newBucket.key = key;
  newBucket.data = item;
  
  //Remove old bucket for key
  [self removeItemForKey:key];
  
  //Add
  Bucket *head = _hashArray[index];
  if (head.data != nil) {
    newBucket.next = head; //add bucket to head
    _hashArray[index] = newBucket;
  } else {
    newBucket.next = head;
    _hashArray[index] = newBucket;
  } //end else
} //end func

//Remove item
- (void) removeItemForKey: (NSString *)key {
  //Index
  NSInteger index = [self hashKey:key];
  
  //Buckets
  Bucket *previousBucket;
  Bucket *currentBucket = _hashArray[index]; //containing data for key
  
  //Delete
  while (currentBucket != nil) {
    if ([key isEqualToString:currentBucket.key]) { //at the bucket to delete
      if (previousBucket != nil) { //not at head
        Bucket *nextBucket = currentBucket.next;
        if (nextBucket != nil) {
          previousBucket.next = nextBucket; //skip over bucket to delete
        } else {
          nextBucket = [[Bucket alloc] init];
        } //end if
      } else { //at head
        Bucket *head = currentBucket.next;
        if (head.next == nil) {
          head.next = [[Bucket alloc] init];
        } //end if
        _hashArray[index] = currentBucket.next;
      } //end if
      return;
    } else { //key does not match, go to next bucket
      previousBucket = currentBucket;
      currentBucket = currentBucket.next;
    } //end if
  } //end while
} //end func

//Retrieve item
- (id) getItemForKey: (NSString *)key {
  NSInteger index = [self hashKey:key];
  Bucket *currentBucket = self.hashArray[index];
  
  while (currentBucket != nil) {
    if ([currentBucket.key isEqualToString:key]) {
      return currentBucket.data;
    } else {
      currentBucket = currentBucket.next;
    } //end if
  } //end while
  return nil;
} //end func
@end