//
//  MentionsRelationshipEntryViewController.h
//  StoryOfMyLife0.1
//
//  Created by Kevin Fich on 9/27/15.
//  Copyright © 2015 Kevin Fich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "UIImage+ResizeMagick.h"

@interface MentionsRelationshipEntryViewController : UIViewController


@property (weak, nonatomic) IBOutlet UITextView *entryTextView;
@property (strong, nonatomic) PFObject *selectedEntry;
@property (strong, nonatomic) PFUser *selectedUser;
@property (strong, nonatomic) PFUser *sender;


@property (weak, nonatomic) IBOutlet UIImageView *userImage;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *authorLabel;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;


@end
