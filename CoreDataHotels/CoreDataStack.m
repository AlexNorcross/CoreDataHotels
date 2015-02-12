//
//  CoreDataStack.m
//  CoreDataHotels
//
//  Created by Alexandra Norcross on 2/11/15.
//  Copyright (c) 2015 Alexandra Norcross. All rights reserved.
//

#import "CoreDataStack.h"
#import "Hotel.h"
#import "Room.h"

@interface CoreDataStack()

@property (nonatomic) BOOL isTesting;

@end

@implementation CoreDataStack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

//Initialize for testing
- (instancetype) initForTesting {
  self = [super init];
  if (self) {
    self.isTesting = true;
  } //end if
  return self;
} //end init

//Fetch hotels; if none, seed database.
- (void) fetchHotels {
  NSFetchRequest *requestHotels = [[NSFetchRequest alloc] initWithEntityName:@"Hotel"];
  NSError *fetchError;
  NSInteger numberOfHotels = [self.managedObjectContext countForFetchRequest:requestHotels error:&fetchError];
  if (numberOfHotels == 0) { //seed database
    NSURL *urlSeed = [[NSBundle mainBundle] URLForResource:@"seed" withExtension:@"json"];
    NSData *dataSeed = [[NSData alloc] initWithContentsOfURL:urlSeed];
    NSError *jsonError;
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:dataSeed options:0 error:&jsonError];
    if (jsonError == nil) {
      //Seed database
      NSArray *hotels = jsonDictionary[@"Hotels"];
      for (NSDictionary *hotelDictionary in hotels) {
        //Hotel
        Hotel *addHotel = [NSEntityDescription insertNewObjectForEntityForName:@"Hotel" inManagedObjectContext:self.managedObjectContext];
        addHotel.name = hotelDictionary[@"name"];
        addHotel.location = hotelDictionary[@"location"];
        addHotel.stars = hotelDictionary[@"stars"];
        
        //Hotel rooms
        NSArray *rooms = hotelDictionary[@"rooms"];
        for (NSDictionary *roomDictionary in rooms) {
          Room *addRoom = [NSEntityDescription insertNewObjectForEntityForName:@"Room" inManagedObjectContext:self.managedObjectContext];
          addRoom.number = roomDictionary[@"number"];
          addRoom.numberOfBeds = roomDictionary[@"beds"];
          addRoom.rate = roomDictionary[@"rate"];
          addRoom.hotel = addHotel;
        } //end for
      } //end for
      
      //Save seed
      NSError *saveError;
      [self.managedObjectContext save:&saveError];
      if (saveError != nil) {
        NSLog(@"%s", "error saving seed");
      } //end if
    } //end if
  } //end if
} //end func

- (NSURL *)applicationDocumentsDirectory {
  // The directory the application uses to store the Core Data store file. This code uses a directory named "DiBella.CoreDataHotels" in the application's documents directory.
  return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
  // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
  if (_managedObjectModel != nil) {
    return _managedObjectModel;
  }
  NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"CoreDataHotels" withExtension:@"momd"];
  _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
  return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
  // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
  if (_persistentStoreCoordinator != nil) {
    return _persistentStoreCoordinator;
  }
  
  // Create the coordinator and store
  
  _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
  NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"CoreDataHotels.sqlite"];
  NSError *error = nil;
  NSString *failureReason = @"There was an error creating or loading the application's saved data.";
  
  NSString *storeType;
  if (self.isTesting) {
    storeType = NSInMemoryStoreType;
  } else {
    storeType = NSSQLiteStoreType;
  } //end if
  
  if (![_persistentStoreCoordinator addPersistentStoreWithType:storeType configuration:nil URL:storeURL options:nil error:&error]) {
    // Report any error we got.
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
    dict[NSLocalizedFailureReasonErrorKey] = failureReason;
    dict[NSUnderlyingErrorKey] = error;
    error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
    // Replace this with code to handle the error appropriately.
    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    abort();
  }
  
  return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
  // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
  if (_managedObjectContext != nil) {
    return _managedObjectContext;
  }
  
  NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
  if (!coordinator) {
    return nil;
  }
  _managedObjectContext = [[NSManagedObjectContext alloc] init];
  [_managedObjectContext setPersistentStoreCoordinator:coordinator];
  return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
  NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
  if (managedObjectContext != nil) {
    NSError *error = nil;
    if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
      // Replace this implementation with code to handle the error appropriately.
      // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
      NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
      abort();
    }
  }
}

@end
