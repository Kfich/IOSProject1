//
//  MentionsContainerViewController.h
//  StoryOfMyLife0.1
//
//  Created by Kevin Fich on 9/16/15.
//  Copyright (c) 2015 Kevin Fich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "ArchiveTableViewCell.h"
#import "MentionsRelationshipEntryViewController.h"


@interface MentionsContainerViewController : UITableViewController

@property (strong, nonatomic) NSArray *entries;
@property (strong, nonatomic) PFObject *selectedEntry;
@property (strong, nonatomic) PFUser *otherUser;
@property (strong, nonatomic) PFUser *sender;



@end
