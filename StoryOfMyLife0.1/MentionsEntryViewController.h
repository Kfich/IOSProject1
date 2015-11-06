//
//  MentionsEntryViewController.h
//  StoryOfMyLife0.1
//
//  Created by Kevin Fich on 9/14/15.
//  Copyright (c) 2015 Kevin Fich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface MentionsEntryViewController : UIViewController

@property (strong, nonatomic) PFObject *selectedEntry;

@property (strong, nonatomic) IBOutlet UITextView *entryTextView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *authorLabel;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;


@property (weak, nonatomic) IBOutlet UIImageView *userImage;

@end
