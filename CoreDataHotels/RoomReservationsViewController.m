//
//  RoomReservationsViewController.m
//  CoreDataHotels
//
//  Created by Alexandra Norcross on 2/11/15.
//  Copyright (c) 2015 Alexandra Norcross. All rights reserved.
//

#import "RoomReservationsViewController.h"
#import "HotelService.h"
#import "Reservation.h"
#import "RoomBookViewController.h"

@interface RoomReservationsViewController () <UITableViewDataSource, NSFetchedResultsControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableReservations;
@property (strong, nonatomic) NSFetchedResultsController *fetchController;
@end

@implementation RoomReservationsViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  //Title
  self.title = [NSString stringWithFormat:@"%@ %s", _selectedRoom.number, "reservations"];
  
  //Toolbar - add button
  UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(pressedAddButton)];
  [self.navigationItem setRightBarButtonItem:addButton];
  
  //Table
  _tableReservations.dataSource = self;
  
  //Fetch controller
  NSManagedObjectContext *context = [[HotelService sharedService] coreDataStack].managedObjectContext;
  NSFetchRequest *fetchReservations = [[NSFetchRequest alloc] initWithEntityName:@"Reservation"];
  
  //Predicate
  NSPredicate *predicateReservations = [NSPredicate predicateWithFormat:@"self.room == %@", _selectedRoom];
  fetchReservations.predicate = predicateReservations;
  
  //Sort
  NSSortDescriptor *sortReservations = [[NSSortDescriptor alloc] initWithKey:@"startDate" ascending:YES];
  fetchReservations.sortDescriptors = @[sortReservations];
  
  //Fetch controller
  _fetchController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchReservations managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
  _fetchController.delegate = self;

  //Fetch
  NSError *fetchError;
  [_fetchController performFetch:&fetchError];
  if (fetchError) {
    NSLog(@"%s", "fetch controller error");
  } //end if
} //end func

#pragma mark - table view data source

//Number of rows
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  NSArray *sections = [_fetchController sections];
  id<NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:section];
  return [sectionInfo numberOfObjects];
} //end func

//Cell content
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *newCell = [tableView dequeueReusableCellWithIdentifier:@"CELL_RESERVATION" forIndexPath:indexPath];
  newCell.textLabel.font = [UIFont fontWithName:@"HiraMinProN-W3" size: 17];
  [self setCellContent:newCell atIndexPath:indexPath];
  return newCell;
} //end func

//Cell content
-(void) setCellContent:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
  Reservation *reservation = [self.fetchController objectAtIndexPath:indexPath];
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"MM-dd-yyyy"];
  NSString *printStartDate = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:reservation.startDate]];
  NSString *printEndDate = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:reservation.endDate]];
  cell.textLabel.text = [NSString stringWithFormat:@"%@ to %@", printStartDate, printEndDate];
} //end func

//Table cell can be edited
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
  return true;
} //end func

//Table cell edit functionality
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    Reservation *reservation = [_fetchController objectAtIndexPath:indexPath];
    [[HotelService sharedService] deleteReservation:reservation];
  } //end if
} //end func

#pragma mark - fetch results controller delegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
  [_tableReservations beginUpdates];
} //end func

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
  [_tableReservations endUpdates];
} //end func

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
  switch (type) {
    case NSFetchedResultsChangeInsert:
      [_tableReservations insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationRight];
      break;
    case NSFetchedResultsChangeDelete:
      [_tableReservations deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
      break;
    case NSFetchedResultsChangeUpdate:
      [self setCellContent:[_tableReservations cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
      break;
    case NSFetchedResultsChangeMove:
      [_tableReservations deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
      [_tableReservations insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationRight];
      break;
    default:
      break;
  } //end switch
} //end func

#pragma mark - selectors

//Add button pressed
-(void) pressedAddButton {
  RoomBookViewController *vcRoomBook = [self.storyboard instantiateViewControllerWithIdentifier:@"VC_ROOM_BOOK"];
  vcRoomBook.selectedRoom = _selectedRoom;
  [self.navigationController pushViewController:vcRoomBook animated:true];
} //end func
@end