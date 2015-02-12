//
//  HotelService.h
//  CoreDataHotels
//
//  Created by Alexandra Norcross on 2/11/15.
//  Copyright (c) 2015 Alexandra Norcross. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreDataStack.h"
#import "Guest.h"
#import "Reservation.h"
#import "Room.h"

@interface HotelService : NSObject

@property (strong, nonatomic) CoreDataStack *coreDataStack;

+(id) sharedService;

- (instancetype) init;
- (instancetype) initForTesting;
- (Reservation *) bookReservationForGuest: (Guest *)guest inRoom:(Room *)room startingOn:(NSDate *)startDate endingOn:(NSDate *)endDate;
- (void) deleteReservation:(Reservation *)reservation;

@end
