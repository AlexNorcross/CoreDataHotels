//
//  RoomBookViewController.m
//  CoreDataHotels
//
//  Created by Alexandra Norcross on 2/10/15.
//  Copyright (c) 2015 Alexandra Norcross. All rights reserved.
//

#import "RoomBookViewController.h"
#import "HotelService.h"
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

//Book room
- (IBAction)pressedRoomBook:(id)sender {
  //Guest
  Guest *newGuest = [NSEntityDescription insertNewObjectForEntityForName:@"Guest" inManagedObjectContext:[[HotelService sharedService] coreDataStack].managedObjectContext];
  newGuest.firstName = @"Alexandra";
  newGuest.lastName = @"Norcross";
  
  //Dates
  NSDate *startDate = _startDatePicker.date;
  NSDate *endDate = _endDatePicker.date;
  
  //Book room
  Reservation *newReservation = [[HotelService sharedService] bookReservationForGuest:newGuest inRoom:_selectedRoom startingOn:startDate endingOn:endDate];
  if (newReservation != nil) {
    NSLog(@"%s", "room is booked");
  } else {
    NSLog(@"%s", "room is not booked");
  } //end if

  [self.navigationController popViewControllerAnimated:true];
} //end func
@end
