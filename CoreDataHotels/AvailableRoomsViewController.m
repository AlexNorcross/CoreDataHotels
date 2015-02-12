//
//  AvailableRoomsViewController.m
//  CoreDataHotels
//
//  Created by Alexandra Norcross on 2/11/15.
//  Copyright (c) 2015 Alexandra Norcross. All rights reserved.
//

#import "AvailableRoomsViewController.h"
#import "HotelService.h"
#import "Hotel.h"
#import "Room.h"
#import "RoomBookViewController.h"

@interface AvailableRoomsViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableRooms;
@property (strong, nonatomic) NSMutableArray *hotelNames;
@property (strong, nonatomic) NSMutableArray *hotelRooms;
@end

@implementation AvailableRoomsViewController

//Setup
- (void)viewDidLoad {
  [super viewDidLoad];
  
  //Title
  self.title = @"Available Rooms";
  
  //Table
  _tableRooms.dataSource = self;
  _tableRooms.delegate = self;

  //Hotels
  NSManagedObjectContext *context = [[HotelService sharedService] coreDataStack].managedObjectContext;
  NSFetchRequest *requestHotels = [[NSFetchRequest alloc] initWithEntityName:@"Hotel"];
  NSSortDescriptor *sortHotels = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
  [requestHotels setSortDescriptors:@[sortHotels]];
  NSError *fetchError;
  NSArray *fetchResults = [context executeFetchRequest:requestHotels error:&fetchError];
  if (fetchError == nil) {
    //Hotels with availability
    _hotelNames = [[NSMutableArray alloc] init];
    _hotelRooms = [[NSMutableArray alloc] init];
    for (Hotel *hotel in fetchResults) {
      //Hotel name
      [_hotelNames addObject:hotel.name];
      //Find hotel's rooms
      NSMutableArray *currentHotelRooms = [[NSMutableArray alloc] init];
      for (Room *room in _rooms) {
        if (room.hotel.name == hotel.name) {
          [currentHotelRooms addObject:room];
        } //end if
      } //end for
      [_hotelRooms addObject:currentHotelRooms]; //array of room arrays
    } //end for
  } //end if
} //end func

#pragma mark - table view data source

//Number of sections
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
  return _hotelNames.count;
} //end func

//Section title
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  NSString *hotelName = _hotelNames[section];
  return hotelName;
} //end for

//Number of rows
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  NSArray *currentHotelRooms = _hotelRooms[section];
  return currentHotelRooms.count;
} //end func

//Cell content
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  //Room
  NSArray *currentHotelRooms = _hotelRooms[indexPath.section];
  Room *newRoom = currentHotelRooms[indexPath.row];
  //Cell
  UITableViewCell *newCell = [tableView dequeueReusableCellWithIdentifier:@"CELL_ROOM" forIndexPath:indexPath];
  newCell.textLabel.text = [NSString stringWithFormat:@"%s %@", "room", newRoom.number];
  newCell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %s", newRoom.numberOfBeds, "beds"];
  //Return cell
  return newCell;
} //end func

//Table header height
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  return 40;
} //end func

#pragma mark - table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  RoomBookViewController *vcRoomBook = [self.storyboard instantiateViewControllerWithIdentifier:@"VC_ROOM_BOOK"];
  NSArray *currentHotelRooms = _hotelRooms[indexPath.section];
  Room *newRoom = currentHotelRooms[indexPath.row];
  vcRoomBook.selectedRoom = newRoom;
  [self.navigationController pushViewController:vcRoomBook animated:true];
} //end func
@end
