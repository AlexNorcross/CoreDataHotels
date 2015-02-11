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
#import "RoomBookViewController.h"


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
  newCell.textLabel.text = [newRoom.number stringValue];
  newCell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %s", newRoom.numberOfBeds, "beds"];
  //Return cell
  return newCell;
} //end func

#pragma mark - table view delegate

//Table header text
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  return @"Room Number";
} //end func

//Table header height
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  return 50;
} //end func

//Go to Room
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  RoomBookViewController *vcRoomBook = [self.storyboard instantiateViewControllerWithIdentifier:@"VC_ROOM_BOOK"];
  vcRoomBook.selectedRoom = _rooms[indexPath.row];
  [self.navigationController pushViewController:vcRoomBook animated:true];
} //end func
@end
