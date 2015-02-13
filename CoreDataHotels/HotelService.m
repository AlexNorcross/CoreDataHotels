//
//  HotelService.m
//  CoreDataHotels
//
//  Created by Alexandra Norcross on 2/11/15.
//  Copyright (c) 2015 Alexandra Norcross. All rights reserved.
//

#import "HotelService.h"
#import "CoreDataStack.h"
#import "Hotel.h"
#import "Room.h"
#import "Guest.h"
#import "Reservation.h"

@implementation HotelService

//Singleton
+(id) sharedService {
  static HotelService *mySharedService = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    mySharedService = [[self alloc] init];
  });
  return mySharedService;
} //end class var

//Initialize
- (instancetype) init {
  self = [super init];
  if (self) {
    _coreDataStack = [[CoreDataStack alloc] init];
  } //end if
  return self;
} //end init

//Initialize for testing
- (instancetype) initForTesting {
  self = [super init];
  if (self) {
    _coreDataStack = [[CoreDataStack alloc] initForTesting];
  } //end if
  return self;
} //end init

//Add reservation
- (Reservation *) bookReservationForGuest: (Guest *)guest inRoom:(Room *)room startingOn:(NSDate *)startDate endingOn:(NSDate *)endDate {
  NSDate *today = [NSDate date];
  NSDate *checkStartDateOld = [startDate earlierDate:today];
  if (today == checkStartDateOld) {
    NSDate *checkStartDateOrder = [startDate earlierDate:endDate];
    if (startDate == checkStartDateOrder) { //dates are ordered; check room's availability
      //Fetch request - w/ predicate to check availability for room at specified dates
      NSFetchRequest *fetchRoomDates = [[NSFetchRequest alloc] initWithEntityName:@"Reservation"];
      NSPredicate *predicateRoomDates = [NSPredicate predicateWithFormat:@"self.room == %@ AND (startDate <= %@ AND endDate >= %@)", room, endDate, startDate];
      fetchRoomDates.predicate = predicateRoomDates;
      NSError *fetchError;
      NSArray *fetchResults = [room.managedObjectContext executeFetchRequest:fetchRoomDates error:&fetchError];

      //Check fetch results
      if (fetchError == nil) {
        if (fetchResults.count == 0) { //room is available; save
          //New reservation
          Reservation *newReservation = [NSEntityDescription insertNewObjectForEntityForName:@"Reservation" inManagedObjectContext:_coreDataStack.managedObjectContext];
          newReservation.room = room;
          newReservation.startDate = startDate;
          newReservation.endDate = endDate;
          //Guest
          guest.reservation = newReservation;

          //Save
          NSError *saveError;
          [_coreDataStack.managedObjectContext save:&saveError];
          if (saveError != nil) {
            NSLog(@"error saving room reservation");
          } //end if

          //Print number of reservations
          NSLog(@"%s %@ %lu", "number of reservations for room #", room.number, (unsigned long)room.reservations.count);
          
          //Return value
          return newReservation;
        } else {
          NSLog(@"room is not available");
        } //end if
      } else {
        NSLog(@"error checking room availability");
      } //end if
    } else {
      NSLog(@"reorder dates");
    } //end if
  } else {
    NSLog(@"dates are old");
  } //end if
  return nil;
} //end func

//Delete reservation
- (void) deleteReservation:(Reservation *)reservation {
  //Delete
  [_coreDataStack.managedObjectContext deleteObject:reservation];
  //Save
  NSError *saveError;
  [_coreDataStack.managedObjectContext save:&saveError];
  if (saveError != nil) {
    NSLog(@"error saving room reservation");
  } //end if
} //end func
@end
