//
//  RoomBookViewController.m
//  CoreDataHotels
//
//  Created by Alexandra Norcross on 2/10/15.
//  Copyright (c) 2015 Alexandra Norcross. All rights reserved.
//

#import "RoomBookViewController.h"
#import "Hotel.h"
#import "Reservation.h"
#import "Guest.h"

@interface RoomBookViewController ()
@property (weak, nonatomic) IBOutlet UIDatePicker *startDatePicker;
@property (weak, nonatomic) IBOutlet UIDatePicker *endDatePicker;
@end

@implementation RoomBookViewController

//Setup
- (void)viewDidLoad {
  [super viewDidLoad];
  
  //Title
  self.title = [NSString stringWithFormat:@"%s %@", "Room", _selectedRoom.number];
  
  //End date
  NSDate *startDate = _startDatePicker.date;
  NSDateComponents *endDateComp = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:startDate];
  endDateComp.day++;
  NSDate *endDate = [[NSCalendar currentCalendar] dateFromComponents:endDateComp];
  [_endDatePicker setDate:endDate];
} //end func

//Book room
- (IBAction)pressedRoomBook:(id)sender {
  NSDate *selStartDate = [_startDatePicker.date earlierDate:_endDatePicker.date];
  if (_startDatePicker.date == selStartDate) { //dates are ordered; check room's availability
    //End date:
    NSDate *selEndDate = _endDatePicker.date;
    
    //Fetch request - w/ predicate to check availability for room at specified dates
    //Invalid conditions:
      //startDate <= selStartDate AND endDate <= selEndDate AND endDate >= selStartDate
      //startDate >= selStartDate AND endDate <= selEndDate
      //startDate <= selStartDate AND endDate >= selEndDate
      //startDate >= selStartDate AND endDate >= selEndDate AND startDate <= selEndDate
    NSFetchRequest *fetchRoomDates = [[NSFetchRequest alloc] initWithEntityName:@"Reservation"];
    NSPredicate *predicateRoomDates = [NSPredicate predicateWithFormat:@"self.room.hotel.name == %@ AND self.room.number == %d AND ((startDate <= %@ AND endDate <= %@ AND endDate >= %@) OR (startDate >= %@ AND endDate <= %@) OR (startDate <= %@ AND endDate >= %@) OR (startDate >= %@ AND endDate >= %@ AND startDate <= %@))", _selectedRoom.hotel.name, _selectedRoom.number, selStartDate, selEndDate, selStartDate, selStartDate, selEndDate, selStartDate, selEndDate, selStartDate, selEndDate, selEndDate];
    fetchRoomDates.predicate = predicateRoomDates;
    
    //Fetch request
    NSError *fetchError;
    NSArray *fetchResults = [_selectedRoom.managedObjectContext executeFetchRequest:fetchRoomDates error:&fetchError];
    
    //Check fetch results
    if (fetchError == nil) {
      if (fetchResults.count == 0) { //room is available; save
        //New reservation
        Reservation *newReservation = [NSEntityDescription insertNewObjectForEntityForName:@"Reservation" inManagedObjectContext:_selectedRoom.managedObjectContext];
        newReservation.room = _selectedRoom;
        newReservation.startDate = _startDatePicker.date;
        newReservation.endDate = _endDatePicker.date;

        //New guest
        Guest *newGuest = [NSEntityDescription insertNewObjectForEntityForName:@"Guest" inManagedObjectContext:_selectedRoom.managedObjectContext];
        newGuest.firstName = @"Alexandra";
        newGuest.lastName = @"Norcross";
        newGuest.reservation = newReservation;
        
        //Save
        NSError *saveError;
        [_selectedRoom.managedObjectContext save:&saveError];
        if (saveError != nil) {
          NSLog(@"error saving room reservation");
        } //end if
        
        //Print number of reservations
        NSLog(@"%s %@ %lu", "number of reservations for room #", _selectedRoom.number, (unsigned long)_selectedRoom.reservations.count);
      } else {
        NSLog(@"room is not available");
      } //end if
    } else {
      NSLog(@"error checking room availability");
    } //end if
  } else {
    NSLog(@"reorder dates");
  } //end if
} //end func
@end
