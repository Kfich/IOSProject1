//
//  MentionFriendsViewController.m
//  StoryOfMyLife0.1
//
//  Created by Kevin Fich on 9/1/15.
//  Copyright (c) 2015 Kevin Fich. All rights reserved.
//

#import "MentionFriendsViewController.h"
#import "CreateViewController.h"

@interface MentionFriendsViewController ()

@end

@implementation MentionFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    [self.navigationItem setHidesBackButton:YES];
    self.friendsRelation = [[PFUser currentUser] relationForKey:@"friendsRelation"];
    self.entryRelation = [self.entry relationForKey:@"entryRelation"];
    self.mentionRelation = [[PFUser currentUser] relationForKey:@"mentionRelation"];
    self.currentUser = [PFUser currentUser];
    
    self.entryRecipients = [[NSMutableArray alloc] init];
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
    indicator.center = self.view.center;
    [self.view addSubview:indicator];
    [indicator bringSubviewToFront:self.view];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = TRUE;

    PFQuery *query = [self.friendsRelation query];
    [query orderByAscending:@"username"];
    
    [indicator startAnimating];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        
        if (error) {
           // NSLog(@"Error: %@ %@", error, [error userInfo]);
            
        }else{
            [indicator stopAnimating];
            self.friends = objects;
            [self.tableView reloadData];
        }
    }];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    return [self.friends count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FriendsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.mentionUserImage.layer.cornerRadius = 40.0f;
    cell.mentionUserImage.layer.masksToBounds = YES;
    cell.mentionUserImage.layer.borderWidth = 0;
    
    // Configure the cell...
    
    PFUser *user = [self.friends objectAtIndex:indexPath.row];
    
    if (cell==nil) {
        NSArray *nib =[[NSBundle mainBundle] loadNibNamed:@"Cell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
    }else{
        
        cell.mentionUserLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:24.0f];
        [cell.mentionUserLabel setTextColor:[UIColor grayColor]];
        cell.mentionUserLabel.text = user.username;
        
        PFFile *imageFile = [user objectForKey:@"imageFile"];
        
        if(imageFile != nil){
            NSURL *imageFileUrl = [[NSURL alloc] initWithString:imageFile.url];
            NSData *imageData = [NSData dataWithContentsOfURL:imageFileUrl];
            
            UIImage *userImage = [UIImage imageWithData:imageData];
            
            
            cell.mentionUserImage.image = userImage;
            
        }else{
            cell.mentionUserImage.image = [UIImage imageNamed:@"no_image.png"];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    PFUser *user = [self.friends objectAtIndex:indexPath.row];
   // PFRelation *friendsRelation = [self.currentUser relationForKey:@"friendsRelation"];
    
    
    if ([self isSelectedFriend:user]) {
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        for(PFUser *friend in self.entryRecipients){
            
            if ([friend.objectId isEqualToString:user.objectId]) {
                [self.entryRecipients removeObject:friend];
                
                break;
            }
        }
        
        [self.entryRelation removeObject:user];
        [self.mentionRelation removeObject:user];
        
    }else{
        
    //    [friendsRelation addObject:user];
       [self.entryRecipients addObject:user];
        [self.entryRelation addObject:user];
        [self.mentionRelation addObject:user];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    
    
    
    
    /*
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    
    FriendsTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    PFUser *user = [self.friends objectAtIndex:indexPath.row];
    
    
    if ([self isSelectedFriend:user]) {
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        for(PFUser *friend in self.entryRecipients){
            
            if ([friend.objectId isEqualToString:user.objectId]) {
                [self.entryRecipients removeObject:friend];
                break;
            }
        }
        
        [self.entryRelation removeObject:user];
        [self.mentionRelation removeObject:user];
        [self.entryRecipients removeObject:user.objectId];
        
    }else{
        
        [self.entryRelation addObject:user];
        [self.mentionRelation addObject:user];
        [self.entryRecipients addObject:user.objectId];
        [self.entry setObject:self.entryRecipients forKey:@"recipientIds"];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }

    
  
    
    if (cell.accessoryType == UITableViewCellAccessoryNone) {
        // Do something here
        
        [self.entryRelation addObject:user];
        [self.mentionRelation addObject:user];
        [self.entryRecipients addObject:user.objectId];
        [self.entry setObject:self.entryRecipients forKey:@"recipientIds"];
        


        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
    }else if (cell.accessoryType == UITableViewCellAccessoryCheckmark){
        // Remove the ids association in to the entry
        
        [self.entryRelation removeObject:user];
        [self.mentionRelation removeObject:user];
        [self.entryRecipients removeObject:user.objectId];
        cell.accessoryType = UITableViewCellAccessoryNone;
        
 }
*/
}


#pragma mark - Helper methods


- (IBAction)cancelWasPressed:(id)sender {
    
    [self.presentingViewController dismissViewControllerAnimated:NO completion:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    [self.entry deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        if (error) {
           // NSLog(@"Error %@ %@", error, [error userInfo]);
        }else{
           // NSLog(@"Entry Deleted");
        }
        
    }];
    
}

- (IBAction)doneWasPressed:(id)sender {
  
    NSMutableArray *recipientIds = [[NSMutableArray alloc] init];
    
    for(PFUser *friend in self.entryRecipients){
        
        [recipientIds addObject:friend.objectId];
        //NSLog(@"Recipients : %@", friend.objectId);
    }
    
    [self.entry setObject:recipientIds forKey:@"recipientIds"];

    
   
    [self.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        if (error) {
         //   NSLog(@"Error %@ %@", error, [error userInfo]);
        }else{
         //   NSLog(@"User saved");
        }
    }];
    
    [self.entry saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        if (error) {
         //   NSLog(@"Error %@ %@", error, [error userInfo]);
        }else{
         //   NSLog(@"Entry saved");
        }

    }];
    
    [self.presentingViewController dismissViewControllerAnimated:NO completion:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"Success!"
                              message:@"Your entry was successfully submitted. \n Keep building your story."
                              delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alertView show];
    
}

-(BOOL) isSelectedFriend:(PFObject *)user{
    
    for(PFObject *friend in self.entryRecipients){
        
        if ([friend.objectId isEqualToString:user.objectId]) {
            return YES;
        }
    }
    return NO;
}

@end
