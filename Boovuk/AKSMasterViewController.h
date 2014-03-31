//
//  AKSMasterViewController.h
//  Boovuk
//
//  Created by Kácio Idarlan Oliveira de Souza on 26/03/14.
//  Copyright (c) 2014 Grupo iOS 4mob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Livro.h"

@class AKSDetailViewController;

#import <CoreData/CoreData.h>

@interface AKSMasterViewController : UITableViewController <NSFetchedResultsControllerDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) AKSDetailViewController *detailViewController;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (IBAction)buttonAdicionar:(id)sender;

@end
