//
//  ArchiveDetailViewController.h
//  StoryOfMyLife0.1
//
//  Created by Kevin Fich on 9/6/15.
//  Copyright (c) 2015 Kevin Fich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "MentionsRelationshipViewController.h"
#import "UIImage+ResizeMagick.h"

@interface ArchiveDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *entryTextView;

@property (strong, nonatomic) PFObject *selectedEntry;

@property (strong, nonatomic) NSArray *mentionedFriendsArray;

@property (weak, nonatomic) IBOutlet UIImageView *userImage;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *authorLabel;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UIView *mentionedFriendsView;
@property (nonatomic, strong) PFUser *selectedFriend;


@property (assign) BOOL currentUserIsSender;


@end
