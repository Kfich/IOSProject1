//
//  FriendsTableViewCell.h
//  StoryOfMyLife0.1
//
//  Created by Kevin Fich on 9/15/15.
//  Copyright (c) 2015 Kevin Fich. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendsTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *userImage;

@property (weak, nonatomic) IBOutlet UILabel *selectionUsername;

@property (weak, nonatomic) IBOutlet UIImageView *selectionUserImage;


@property (weak, nonatomic) IBOutlet UIImageView *mentionUserImage;

@property (weak, nonatomic) IBOutlet UILabel *mentionUserLabel;
@end
