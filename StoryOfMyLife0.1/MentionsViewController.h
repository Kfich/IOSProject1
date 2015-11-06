//
//  MentionsViewController.h
//  StoryOfMyLife0.1
//
//  Created by Kevin Fich on 8/31/15.
//  Copyright (c) 2015 Kevin Fich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <QuartzCore/QuartzCore.h>
#import "MentionsEntryViewController.h"
#import "MentionsRelationshipViewController.h"
#import "UIImage+ResizeMagick.h"

@interface MentionsViewController : UIViewController <CLLocationManagerDelegate> {
    BOOL clicked;

}

@property (nonatomic, strong) NSArray *friends;
@property (nonatomic, strong) NSArray *mentionedFriends;

@property (strong, nonatomic) NSArray *entries;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UILabel *authorLabel;

@property (strong, nonatomic) IBOutlet UITextView *entryTextView;

//@property (nonatomic, strong) NSMutableArray *recipients;

@property (nonatomic, strong) PFRelation  *friendsRelation;
@property (nonatomic, strong) PFRelation  *mentionRelation;

@property (nonatomic, strong) PFObject *entry;

@property (nonatomic, strong) PFObject *selectedEntry;

@property (nonatomic, strong) PFUser *selectedFriend;

@property (weak, nonatomic) IBOutlet UIView *recentMentionsView;

- (void)createEntryScrollMenu;
//- (void)createRecentsScrollMenu;




@end
