//
//  Bucket.h
//  CoreDataHotels
//
//  Created by Alexandra Norcross on 2/12/15.
//  Copyright (c) 2015 Alexandra Norcross. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Bucket : NSObject
@property (strong, nonatomic) NSString *key;
@property (strong, nonatomic) id data;
@property (strong, nonatomic) Bucket *next;
@end
