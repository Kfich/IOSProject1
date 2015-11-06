//
//  FriendSelectionViewController.h
//  StoryOfMyLife0.1
//
//  Created by Kevin Fich on 9/1/15.
//  Copyright (c) 2015 Kevin Fich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "FriendsTableViewCell.h"

@interface FriendSelectionViewController : UITableViewController

@property (strong, nonatomic) NSArray *allUsers;
@property (strong, nonatomic) PFUser *currentUser;
@property (strong, nonatomic) NSMutableArray *friends;

@property (nonatomic, strong) PFRelation  *friendsRelation;


-(BOOL) isFriend:(PFUser *) user;

@end
