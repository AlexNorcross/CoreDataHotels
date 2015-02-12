//
//  HotelsViewController.m
//  CoreDataHotels
//
//  Created by Alexandra Norcross on 2/9/15.
//  Copyright (c) 2015 Alexandra Norcross. All rights reserved.
//

#import "HotelsViewController.h"
#import "HotelService.h"
#import "Hotel.h"
#import "RoomsViewController.h"

@interface HotelsViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableHotels;
@property (strong, nonatomic) NSArray *hotels;
@end

@implementation HotelsViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  //Title
  self.title = @"Hotels";
  
  //Table
  _tableHotels.dataSource = self;
  _tableHotels.delegate = self;
  
  //Managed object context
  NSManagedObjectContext *context = [[HotelService sharedService] coreDataStack].managedObjectContext;
  
  //Hotels
  NSFetchRequest *requestHotels = [[NSFetchRequest alloc] initWithEntityName:@"Hotel"];
  NSSortDescriptor *sortHotels = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
  [requestHotels setSortDescriptors:@[sortHotels]];
  NSError *fetchError;
  NSArray *fetchResults = [context executeFetchRequest:requestHotels error:&fetchError];
  if (fetchError == nil) {
    _hotels = fetchResults;
    [_tableHotels reloadData];
  } //end if
} //end func

#pragma mark - table view data source

//Number of rows
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return  _hotels.count;
} //end func

//Cell contents
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  //Hotel
  Hotel *newHotel = _hotels[indexPath.row];
  //Cell
  UITableViewCell *newCell = [tableView dequeueReusableCellWithIdentifier:@"CELL_HOTEL" forIndexPath:indexPath];
  newCell.textLabel.text = newHotel.name;
  newCell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@", newHotel.stars, @"stars"];
  //Return cell
  return newCell;
} //end func

#pragma mark - table view delegate

//Selected hotel
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  RoomsViewController *vcRooms = [self.storyboard instantiateViewControllerWithIdentifier:@"VC_ROOMS"];
  vcRooms.selectedHotel = _hotels[indexPath.row];
  [self.navigationController pushViewController:vcRooms animated:true];
} //end func
@end
