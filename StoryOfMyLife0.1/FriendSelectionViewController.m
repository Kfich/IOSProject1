//
//  FriendSelectionViewController.m
//  StoryOfMyLife0.1
//
//  Created by Kevin Fich on 9/1/15.
//  Copyright (c) 2015 Kevin Fich. All rights reserved.
//

#import "FriendSelectionViewController.h"

@interface FriendSelectionViewController ()

@end

@implementation FriendSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.tableView.backgroundColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
    indicator.center = self.view.center;
    [self.view addSubview:indicator];
    [indicator bringSubviewToFront:self.view];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = TRUE;
    
    
    PFQuery *query = [PFUser query];
    [query orderByAscending:@"username"];
    [indicator startAnimating];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        
        if (error) {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        else{
            self.allUsers = objects;
            [indicator stopAnimating];
            [self.tableView reloadData];
        }
    }];
    
    self.friendsRelation = [[PFUser currentUser] relationForKey:@"friendsRelation"];

    
    self.currentUser = [PFUser currentUser];
   // NSLog(@"Current user: %@", self.currentUser);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    return [self.allUsers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    FriendsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    PFUser *user = [self.allUsers objectAtIndex:indexPath.row];
    
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:24.0f];
    [cell.textLabel setTextColor:[UIColor grayColor]];
    cell.selectionUsername.text = user.username;
    
    cell.selectionUserImage.layer.cornerRadius = 40.0f;
    cell.selectionUserImage.layer.masksToBounds = YES;
    cell.selectionUserImage.layer.borderWidth = 0;
    
    if ([self isFriend:user]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
        
    }
    
    PFFile *imageFile = [user objectForKey:@"imageFile"];
    
    if(imageFile != nil){
        NSURL *imageFileUrl = [[NSURL alloc] initWithString:imageFile.url];
        NSData *imageData = [NSData dataWithContentsOfURL:imageFileUrl];
        
        UIImage *userImage = [UIImage imageWithData:imageData];
        
        
        cell.selectionUserImage.image = userImage;
        
    }else{
        cell.selectionUserImage.image = [UIImage imageNamed:@"no_image.png"];
    }
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    PFUser *user = [self.allUsers objectAtIndex:indexPath.row];
    PFRelation *friendsRelation = [self.currentUser relationForKey:@"friendsRelation"];
    
    
    if ([self isFriend:user]) {
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        for(PFUser *friend in self.friends){
            
            if ([friend.objectId isEqualToString:user.objectId]) {
                [self.friends removeObject:friend];
                break;
            }
        }
        
        [friendsRelation removeObject:user];

    }else{
        
        [friendsRelation addObject:user];
        [self.friends addObject:user];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    [self.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        if (error) {
            NSLog(@"Error %@ %@", error, [error userInfo]);
        }
    }];
}

#pragma mark - Helper methods


-(BOOL) isFriend:(PFUser *)user{
    
    for(PFUser *friend in self.friends){
        
        if ([friend.objectId isEqualToString:user.objectId]) {
            return YES;
        }
    }
    return NO;
}
@end
