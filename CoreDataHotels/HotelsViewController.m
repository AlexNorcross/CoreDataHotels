//
//  HotelsViewController.m
//  CoreDataHotels
//
//  Created by Alexandra Norcross on 2/9/15.
//  Copyright (c) 2015 Alexandra Norcross. All rights reserved.
//

#import "HotelsViewController.h"
#import "AppDelegate.h"
#import "Hotel.h"
#import "RoomsViewController.h"

@interface HotelsViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableHotels;
@property (strong, nonatomic) NSArray *hotels;
@property (strong, nonatomic) Hotel *selectedHotel;
@end

@implementation HotelsViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  //Table
  _tableHotels.dataSource = self;
  _tableHotels.delegate = self;
  
  //Hotels
  AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
  NSManagedObjectContext *context = appDelegate.managedObjectContext;
  NSFetchRequest *requestHotels = [[NSFetchRequest alloc] initWithEntityName:@"Hotel"];
  NSError *fetchError;
  NSArray *fetchResults = [context executeFetchRequest:requestHotels error:&fetchError];
  if (fetchError == nil) {
    _hotels = fetchResults;
    [_tableHotels reloadData];
  } //end if
}

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
  _selectedHotel = _hotels[indexPath.row];
} //end func

#pragma mark - Navigation

//Preparation for navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqual:@"SEGUE_TO_ROOMS"]) {
    //View controller
    RoomsViewController *vcRooms = segue.destinationViewController;
    vcRooms.selectedHotel = _selectedHotel;
  } //end if
} //end func
@end
