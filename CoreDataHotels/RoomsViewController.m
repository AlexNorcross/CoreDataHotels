//
//  RoomsViewController.m
//  CoreDataHotels
//
//  Created by Alexandra Norcross on 2/9/15.
//  Copyright (c) 2015 Alexandra Norcross. All rights reserved.
//

#import "RoomsViewController.h"
#import "Hotel.h"
#import "Room.h"
#import "RoomReservationsViewController.h"


@interface RoomsViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableRooms;
@property (strong, nonatomic) NSArray *rooms;
@end

@implementation RoomsViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  //Title
  self.title = _selectedHotel.name;
  
  //Table
  _tableRooms.dataSource = self;
  _tableRooms.delegate = self;
  
  //Rooms
  NSSortDescriptor *sortRooms = [[NSSortDescriptor alloc] initWithKey:@"number" ascending:YES];
  _rooms = [_selectedHotel.rooms sortedArrayUsingDescriptors:@[sortRooms]];
} //end func

#pragma mark - table view data source

//Number of rows
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return _rooms.count;
} //end func

//Cell contents
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  //Room
  Room *newRoom = _rooms[indexPath.row];
  //Cell
  UITableViewCell *newCell = [tableView dequeueReusableCellWithIdentifier:@"CELL_ROOM" forIndexPath:indexPath];
  newCell.textLabel.text = [NSString stringWithFormat:@"%s %@", "room", newRoom.number];
  newCell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %s", newRoom.numberOfBeds, "beds"];
  //Return cell
  return newCell;
} //end func

#pragma mark - table view delegate

//Go to Room
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  RoomReservationsViewController *vcRoomReservations = [self.storyboard instantiateViewControllerWithIdentifier:@"VC_ROOM_RESERVATIONS"];
  vcRoomReservations.selectedRoom = _rooms[indexPath.row];
  [self.navigationController pushViewController:vcRoomReservations animated:true];
} //end func
@end
