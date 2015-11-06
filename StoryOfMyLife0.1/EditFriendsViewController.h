//
//  EditFriendsViewController.h
//  StoryOfMyLife0.1
//
//  Created by Kevin Fich on 9/1/15.
//  Copyright (c) 2015 Kevin Fich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "FriendSelectionViewController.h"
#import "FriendsTableViewCell.h"
#import "MentionsRelationshipViewController.h"


@interface EditFriendsViewController : UITableViewController


@property (nonatomic, strong) NSArray *friends;

@property (nonatomic, strong) NSMutableArray *recipients;

@property (nonatomic, strong) PFRelation  *friendsRelation;

@property (nonatomic, strong) PFUser *selectedFriend;

- (IBAction)refreshFriends:(id)sender;

-(BOOL) isFriend:(PFUser *)user;
@end
