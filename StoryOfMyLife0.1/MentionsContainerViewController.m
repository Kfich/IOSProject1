//
//  MentionsContainerViewController.m
//  StoryOfMyLife0.1
//
//  Created by Kevin Fich on 9/16/15.
//  Copyright (c) 2015 Kevin Fich. All rights reserved.
//

#import "MentionsContainerViewController.h"

@interface MentionsContainerViewController ()

@end

@implementation MentionsContainerViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        
        //NSLog(@"Current user: %@", currentUser.username);
        PFQuery *query1 = [PFQuery queryWithClassName:@"DiaryEntry"];
        [query1 whereKey:@"recipientIds" equalTo:[[PFUser currentUser] objectId]];
        [query1 whereKey:@"Username" equalTo:self.otherUser.username];
        
        PFQuery *query2 = [PFQuery queryWithClassName:@"DiaryEntry"];
        [query2 whereKey:@"recipientIds" equalTo:self.otherUser.objectId];
        [query2 whereKey:@"Username" equalTo:[[PFUser currentUser] username]];
        
        PFQuery *query = [PFQuery orQueryWithSubqueries:@[query1,query2]];
        [query orderByDescending:@"createdAt"];

        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
            if (error) {
                NSLog(@"Error: %@ %@", error, [error userInfo]);
                
            }else{
                //We found the messages y'all
                self.entries = objects;
                [self.tableView reloadData];
              //  NSLog(@"Retrieved: %lu", (unsigned long)[self.entries count]);

            
            }
            
        }];
    }
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
    return [self.entries count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    ArchiveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:18.0f];
    [cell.textLabel setTextColor:[UIColor grayColor]];
    
    PFObject *entry = [self.entries objectAtIndex:indexPath.row];
    
    if (cell==nil) {
        NSArray *nib =[[NSBundle mainBundle] loadNibNamed:@"Cell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
    } else {
        
        cell.relationshipEntryDate.text = [entry objectForKey:@"entryDate"];
        cell.relationshipEntryTitle.text = [entry objectForKey:@"entryTitle"];
        
        if ([[PFUser currentUser].objectId isEqualToString: [entry objectForKey:@"UserID"]]) {
            NSArray *recipientsList = [entry objectForKey:@"recipientIds"];
            cell.relationshipEntryRecipients.text = [NSString stringWithFormat:@"Mentioned Friends: %lu", (unsigned long)recipientsList.count];
        }else{
            cell.relationshipEntryRecipients.text = @"Private Entry";
            
        }
        
        PFFile *imageFile = [entry objectForKey:@"imageFile"];
        
        if(imageFile != nil){
            NSURL *imageFileUrl = [[NSURL alloc] initWithString:imageFile.url];
            NSData *imageData = [NSData dataWithContentsOfURL:imageFileUrl];
            
            UIImage *userImage = [UIImage imageWithData:imageData];
            
            
            cell.relationshipEntryImage.image = userImage;
            
        }else{
            cell.relationshipEntryImage.image = [UIImage imageNamed:@"no_image.png"];
        }
    
    }
    
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.selectedEntry = [self.entries objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"showCommonEntry" sender:self];

    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"showCommonEntry"]){
        
        MentionsRelationshipEntryViewController *entryViewController = (MentionsRelationshipEntryViewController *)segue.destinationViewController;
        entryViewController.selectedEntry = self.selectedEntry;
        entryViewController.selectedUser = self.otherUser;
       // entryViewController.sender = self.sender;
     
        
        
    }
    
}

@end
