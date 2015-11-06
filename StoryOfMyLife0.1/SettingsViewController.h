//
//  SettingsViewController.h
//  StoryOfMyLife0.1
//
//  Created by Kevin Fich on 10/11/15.
//  Copyright © 2015 Kevin Fich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "SettingsTableViewCell.h"

@interface SettingsViewController : UITableViewController

@property(strong, nonatomic) NSArray *settingsArray;

@property(strong, nonatomic) NSArray *iconsArray;



@end
