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


@interface RoomsViewController () <UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableRooms;
@property (strong, nonatomic) NSArray *rooms;
@end

@implementation RoomsViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  //Title
//  [_navigationItem setTitle:_selectedHotel.name];
  
  //Table
  _tableRooms.dataSource = self;
  
  //Rooms
  _rooms = [_selectedHotel.rooms allObjects];
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
  //Return cell
  return newCell;
} //end func

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
