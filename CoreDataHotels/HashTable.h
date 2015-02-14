//
//  HashTable.h
//  CoreDataHotels
//
//  Created by Alexandra Norcross on 2/12/15.
//  Copyright (c) 2015 Alexandra Norcross. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HashTable : NSObject
- (instancetype) initForSize: (NSInteger)count;
- (void) addItem: (id)item forKey:(NSString *)key;
- (void) removeItemForKey: (NSString *)key;
- (id) getItemForKey: (NSString *)key;
@end
