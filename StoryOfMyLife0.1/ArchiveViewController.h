//
//  ArchiveViewController.h
//  StoryOfMyLife0.1
//
//  Created by Kevin Fich on 9/6/15.
//  Copyright (c) 2015 Kevin Fich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "ArchiveDetailViewController.h"
#import "ArchiveTableViewCell.h"
#include <stdlib.h>

@interface ArchiveViewController : UITableViewController


@property (assign) BOOL currentUserIsSender;

@property (strong, nonatomic) NSMutableArray *entries;
@property (strong, nonatomic) PFObject *selectedEntry;

@property(retain) NSMutableArray *tableViewSections;
@property(retain) NSMutableDictionary *tableViewCells;

@property (weak, nonatomic) IBOutlet UIView *menuView;

- (IBAction)createButtonPressed:(id)sender;

- (IBAction)mentionsButtonPressed:(id)sender;

- (IBAction)archiveButtonPressed:(id)sender;

- (IBAction)refreshEntries:(id)sender;



//@property (strong, nonatomic) UIRefreshControl *refreshControl;



@end
