//
//  MentionsRelationshipViewController.h
//  StoryOfMyLife0.1
//
//  Created by Kevin Fich on 9/14/15.
//  Copyright (c) 2015 Kevin Fich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "MentionsContainerViewController.h"

@interface MentionsRelationshipViewController : UIViewController

@property (strong, nonatomic) PFUser *selectedUser;

@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *userImage;

@property (weak, nonatomic) IBOutlet UILabel *hometownLabel;

@property (strong, nonatomic) NSMutableArray *tempArray;


@property (weak, nonatomic) IBOutlet UILabel *currentUsernameLabel;


@property (weak, nonatomic) IBOutlet UIImageView *currentUserImage;

@property (weak, nonatomic) IBOutlet UILabel *currentUserHometownLabel;



@end
