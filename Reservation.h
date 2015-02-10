//
//  Reservation.h
//  CoreDataHotels
//
//  Created by Alexandra Norcross on 2/9/15.
//  Copyright (c) 2015 Alexandra Norcross. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Room;

@interface Reservation : NSManagedObject

@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSDate * endDate;
@property (nonatomic, retain) NSSet *guests;
@property (nonatomic, retain) Room *room;
@end

@interface Reservation (CoreDataGeneratedAccessors)

- (void)addGuestsObject:(NSManagedObject *)value;
- (void)removeGuestsObject:(NSManagedObject *)value;
- (void)addGuests:(NSSet *)values;
- (void)removeGuests:(NSSet *)values;

@end
