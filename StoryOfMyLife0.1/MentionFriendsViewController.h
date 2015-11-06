//
//  MentionFriendsViewController.h
//  StoryOfMyLife0.1
//
//  Created by Kevin Fich on 9/1/15.
//  Copyright (c) 2015 Kevin Fich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface MentionFriendsViewController : UITableViewController

//@property (strong, nonatomic) NSArray *allUsers;
//@property (strong, nonatomic) PFUser *currentUser;
@property (strong, nonatomic) NSArray *friends;
////
//@property (nonatomic, strong) PFRelation *diaryEntryRelation;
//
@property (nonatomic, strong) PFRelation  *friendsRelation;

@property (strong, nonatomic) PFRelation *entryRelation;

@property (strong, nonatomic) PFRelation *mentionRelation;

@property(strong, nonatomic) NSMutableArray *entryRecipients;

@property (strong, nonatomic) PFObject *entry;
@property (strong, nonatomic) PFObject *relationships;

@property (strong, nonatomic) PFUser *currentUser;

- (IBAction)cancelWasPressed:(id)sender;


- (IBAction)doneWasPressed:(id)sender;



-(BOOL) isSelectedFriend:(PFUser *) user;

@end
