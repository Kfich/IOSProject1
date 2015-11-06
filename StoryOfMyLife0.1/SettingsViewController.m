//
//  SettingsViewController.m
//  StoryOfMyLife0.1
//
//  Created by Kevin Fich on 10/11/15.
//  Copyright © 2015 Kevin Fich. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.settingsArray = [NSArray arrayWithObjects: @"Edit General Information", @"Logout", nil];
    
    UIImage *image1 = [UIImage imageNamed:@"archive.png"];
    UIImage *image2 = [UIImage imageNamed:@"info.png"];

    
    
    self.iconsArray = [NSArray arrayWithObjects:image2,image1, nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return  self.settingsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SettingsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    cell.settingLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:24.0f];
    [cell.settingLabel setTextColor:[UIColor blackColor]];
    
    NSString *setting = [self.settingsArray objectAtIndex:indexPath.row];
    UIImage *icon = [self.iconsArray objectAtIndex:indexPath.row];
    
    
    cell.iconImage.image = icon;
    cell.settingLabel.text = setting;
  
    return cell;
}

#pragma mark - Table view delegates

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SettingsTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    if ([cell.settingLabel.text isEqualToString:@"Logout"]) {
        
        [PFUser logOut];
        [self performSegueWithIdentifier:@"showLoginView" sender:self];
    }else{
        [self performSegueWithIdentifier:@"showEditSettings" sender:self];

    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  
    
    if([segue.identifier isEqualToString:@"showLoginView"]){
        [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
        [[segue.destinationViewController navigationItem] setHidesBackButton:YES];

        
    }
    
    
        
    
}


@end
