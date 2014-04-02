//
//  AKSDetailViewController.h
//  Boovuk
//
//  Created by Kácio Idarlan Oliveira de Souza on 26/03/14.
//  Copyright (c) 2014 Grupo iOS 4mob. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AKSDetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;
@property  (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
//@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
