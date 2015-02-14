//
//  HotelServicesTests.m
//  CoreDataHotels
//
//  Created by Alexandra Norcross on 2/12/15.
//  Copyright (c) 2015 Alexandra Norcross. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "HotelService.h"
#import "Hotel.h"
#import "Room.h"
#import "Reservation.h"
#import "Guest.h"

@interface HotelServicesTests : XCTestCase
@property (strong, nonatomic) HotelService *hotelService;
@property (strong, nonatomic) Hotel *hotel;
@property (strong, nonatomic) Room *room;
@property (strong, nonatomic) Reservation *reservation;
@property (strong, nonatomic) Guest *guest;
@end

@implementation HotelServicesTests

- (void)setUp {
  [super setUp];
  
  // Put setup code here. This method is called before the invocation of each test method in the class.
  
  //Hotel service
  _hotelService = [[HotelService alloc] initForTesting];
  NSManagedObjectContext *context = _hotelService.coreDataStack.managedObjectContext;
  
  //Hotel
  _hotel = [NSEntityDescription insertNewObjectForEntityForName:@"Hotel" inManagedObjectContext:context];
  _hotel.name = @"Hotel Test";
  _hotel.location = @"Eastlake";
  _hotel.stars = @5;
  
  //Room
  _room = [NSEntityDescription insertNewObjectForEntityForName:@"Room" inManagedObjectContext:context];
  _room.number = @1;
  _room.numberOfBeds = @1;
  _room.rate = [[NSDecimalNumber alloc] initWithInt:5];
  _room.hotel = _hotel;
  
  //Guest
  _guest = [NSEntityDescription insertNewObjectForEntityForName:@"Guest" inManagedObjectContext:context];
  _guest.firstName = @"Alex";
  _guest.lastName = @"DiBella";
}

- (void)tearDown {
  // Put teardown code here. This method is called after the invocation of each test method in the class.
  _hotelService = nil;
  _hotel = nil;
  _room = nil;
  _reservation = nil;
  _guest = nil;
  [super tearDown];
}

- (void) testBookReservationForGuest {
  
  //Start date
  NSDate *today = [NSDate date];
  NSDateComponents *startDateComp = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:today];
  startDateComp.day++;
  NSDate *startDate = [[NSCalendar currentCalendar] dateFromComponents:startDateComp];
  
  //End date
  NSDateComponents *endDateComp = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:startDate];
  endDateComp.day++;
  NSDate *endDate = [[NSCalendar currentCalendar] dateFromComponents:endDateComp];
  
  //Test
  Reservation *newReservation = [_hotelService bookReservationForGuest:_guest inRoom:_room startingOn:startDate endingOn:endDate];
  XCTAssertNotNil(newReservation, @" booking did not work");
} //end func

- (void) testDeleteReservation {
  //Start date
  NSDate *today = [NSDate date];
  NSDateComponents *startDateComp = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:today];
  startDateComp.day++;
  NSDate *startDate = [[NSCalendar currentCalendar] dateFromComponents:startDateComp];
  
  //End date
  NSDateComponents *endDateComp = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:startDate];
  endDateComp.day++;
  NSDate *endDate = [[NSCalendar currentCalendar] dateFromComponents:endDateComp];
  
  //Reservation
  Reservation *reservation = [_hotelService bookReservationForGuest:_guest inRoom:_room startingOn:startDate endingOn:endDate];
  //Test
  [_hotelService deleteReservation:reservation];
  XCTAssert("@ booking not deleted");
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
