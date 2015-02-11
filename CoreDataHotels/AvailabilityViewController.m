//
//  AvailabilityViewController.m
//  CoreDataHotels
//
//  Created by Alexandra Norcross on 2/10/15.
//  Copyright (c) 2015 Alexandra Norcross. All rights reserved.
//

#import "AvailabilityViewController.h"
#import "AppDelegate.h"
#import "Reservation.h"

@interface AvailabilityViewController ()
@property (weak, nonatomic) IBOutlet UIDatePicker *startDatePicker;
@property (weak, nonatomic) IBOutlet UIDatePicker *endDatePicker;
@property (strong, nonatomic) NSManagedObjectContext *context;
@end

@implementation AvailabilityViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  //Context
  AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
  _context = appDelegate.managedObjectContext;
  
  //Title
  self.title = @"Check Availability";
  
  //End date
  NSDate *startDate = _startDatePicker.date;
  NSDateComponents *endDateComp = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:startDate];
  endDateComp.day++;
  NSDate *endDate = [[NSCalendar currentCalendar] dateFromComponents:endDateComp];
  [_endDatePicker setDate:endDate];
} //end func

//Check availability
- (IBAction)pressedCheckAvailability:(id)sender {
  NSDate *selStartDate = [_startDatePicker.date earlierDate:_endDatePicker.date];
  if (_startDatePicker.date == selStartDate) { //dates are ordered; check availability
    //End date:
    NSDate *selEndDate = _endDatePicker.date;
    
    //Fetch request - w/ predicate to check availability a room at specified dates
    //Invalid conditions:
    //startDate <= selStartDate AND endDate <= selEndDate AND endDate >= selStartDate
    //startDate >= selStartDate AND endDate <= selEndDate
    //startDate <= selStartDate AND endDate >= selEndDate
    //startDate >= selStartDate AND endDate >= selEndDate AND startDate <= selEndDate
    
    //Valid condition:
    //selStartDate <= endDate AND selEndDate >= startDate
    NSFetchRequest *fetchReservations = [[NSFetchRequest alloc] initWithEntityName:@"Reservation"];
    NSPredicate *predicateRervations = [NSPredicate predicateWithFormat:@"(startDate <= %@ AND endDate >= %@)", selEndDate, selStartDate];
    fetchReservations.predicate = predicateRervations;
    
    //Fetch request
    NSError *fetchErrorReservations;
    NSArray *fetchReservationResults = [_context executeFetchRequest:fetchReservations error:&fetchErrorReservations];
    
    //Check fetch results
    if (fetchErrorReservations == nil) {
      //Rooms not available:
      NSMutableArray *roomsNotAvail = [[NSMutableArray alloc] init];
      for (Reservation *roomNotAvail in fetchReservationResults) {
        [roomsNotAvail addObject:roomNotAvail];
      } //end for
      
      //Fetch request - w/ predicate to exclude rooms not available
      NSFetchRequest *fetchRoomsAvail = [[NSFetchRequest alloc] initWithEntityName:@"Room"];
      NSPredicate *predicateRoomsAvail = [NSPredicate predicateWithFormat:@"NOT self in %@", roomsNotAvail];
      fetchRoomsAvail.predicate = predicateRoomsAvail;
      
      //Fetch request
      NSError *fetchErrorRoomsAvail;
      NSArray *fetchRoomAvail = [_context executeFetchRequest:fetchRoomsAvail error:&fetchErrorRoomsAvail];
      
      //Check fetch results
      if (fetchErrorRoomsAvail == nil) { //rooms available
        NSLog(@"%lu %s", (unsigned long)fetchRoomAvail.count, "rooms are available");
      } else {
        NSLog(@"error checking room availability");
      } //end if
    } else {
      NSLog(@"error checking reservation availability");
    } //end if    
  } else {
    NSLog(@"reorder dates");
  } //end if
} //end func
@end
