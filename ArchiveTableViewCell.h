//
//  ArchiveTableViewCell.h
//  StoryOfMyLife0.1
//
//  Created by Kevin Fich on 9/15/15.
//  Copyright (c) 2015 Kevin Fich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArchiveViewController.h"
#import <Parse/Parse.h>

@interface ArchiveTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *entryImage;
@property (weak, nonatomic) IBOutlet UILabel *entryTitle;

@property (weak, nonatomic) IBOutlet UILabel *entryDate;

@property (weak, nonatomic) IBOutlet UILabel *entryRecipients;


@property (weak, nonatomic) IBOutlet UIImageView *relationshipEntryImage;

@property (weak, nonatomic) IBOutlet UILabel *relationshipEntryTitle;

@property (weak, nonatomic) IBOutlet UILabel *relationshipEntryDate;

@property (weak, nonatomic) IBOutlet UILabel *relationshipEntryRecipients;


//-(void)setCellDate:(PFObject *)entry;

//-(void)setCellTitle:(PFObject *)entry;

//-(void)setCellImage:(PFObject *)entry;


@end
