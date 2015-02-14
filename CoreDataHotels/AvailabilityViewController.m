//
//  AvailabilityViewController.m
//  CoreDataHotels
//
//  Created by Alexandra Norcross on 2/10/15.
//  Copyright (c) 2015 Alexandra Norcross. All rights reserved.
//

#import "AvailabilityViewController.h"
#import "HotelService.h"
#import "Reservation.h"
#import "AvailableRoomsViewController.h"

@interface AvailabilityViewController ()
@property (weak, nonatomic) IBOutlet UIDatePicker *startDatePicker;
@property (weak, nonatomic) IBOutlet UIDatePicker *endDatePicker;
@property (strong, nonatomic) NSManagedObjectContext *context;
@end

@implementation AvailabilityViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  //Context
  _context = [[HotelService sharedService] coreDataStack].managedObjectContext;
  
  //Title
  self.title = @"Check Availability";

  //Start date
  NSDate *today = [NSDate date];
  NSDateComponents *startDateComp = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:today];
  startDateComp.day++;
  NSDate *startDate = [[NSCalendar currentCalendar] dateFromComponents:startDateComp];
  [_startDatePicker setDate:startDate];
  
  //End date
  NSDateComponents *endDateComp = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:startDate];
  endDateComp.day++;
  NSDate *endDate = [[NSCalendar currentCalendar] dateFromComponents:endDateComp];
  [_endDatePicker setDate:endDate];
} //end func

//Check availability
- (IBAction)pressedCheckAvailability:(id)sender {
  NSDate *today = [NSDate date];
  NSDate *checkStartDateOld = [_startDatePicker.date earlierDate:today];
  if (today == checkStartDateOld) {
    NSDate *selStartDate = [_startDatePicker.date earlierDate:_endDatePicker.date];
    if (_startDatePicker.date == selStartDate) { //dates are ordered; check availability
      //End date:
      NSDate *selEndDate = _endDatePicker.date;
      
      //Fetch request - w/ predicate to check availability a room at specified dates
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
        for (Reservation *currentReservation in fetchReservationResults) {
          [roomsNotAvail addObject:currentReservation.room];
        } //end for
        
        //Fetch request - w/ predicate to exclude rooms not available
        NSFetchRequest *fetchRoomsAvail = [[NSFetchRequest alloc] initWithEntityName:@"Room"];
        NSPredicate *predicateRoomsAvail = [NSPredicate predicateWithFormat:@"NOT self in %@", roomsNotAvail];
        fetchRoomsAvail.predicate = predicateRoomsAvail;
        
        //Sort by hotel, by room
        NSSortDescriptor *sortByHotel = [[NSSortDescriptor alloc] initWithKey:@"hotel" ascending:YES];
        NSSortDescriptor *sortByRoom = [[NSSortDescriptor alloc] initWithKey:@"number" ascending:YES];
        [fetchRoomsAvail setSortDescriptors:@[sortByHotel, sortByRoom]];
        
        //Fetch request
        NSError *fetchErrorRoomsAvail;
        NSArray *fetchRoomAvail = [_context executeFetchRequest:fetchRoomsAvail error:&fetchErrorRoomsAvail];
        
        //Check fetch results
        if (fetchErrorRoomsAvail == nil) { //rooms available
          NSLog(@"%lu %s", (unsigned long)fetchRoomAvail.count, "rooms are available");
          
          //Show available rooms
          AvailableRoomsViewController *vcAvailableRooms = [[self storyboard] instantiateViewControllerWithIdentifier:@"VC_AVAILABLE_ROOMS"];
          vcAvailableRooms.rooms = fetchRoomAvail;
          [self.navigationController pushViewController:vcAvailableRooms animated:true];
        } else {
          NSLog(@"error checking room availability");
        } //end if
      } else {
        NSLog(@"error checking reservation availability");
      } //end if    
    } else {
      NSLog(@"reorder dates");
    } //end if
  } else {
    NSLog(@"dates are old");
  } //end if
} //end func
@end
