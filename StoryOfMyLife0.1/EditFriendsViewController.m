//
//  EditFriendsViewController.m
//  StoryOfMyLife0.1
//
//  Created by Kevin Fich on 9/1/15.
//  Copyright (c) 2015 Kevin Fich. All rights reserved.
//

#import "EditFriendsViewController.h"
#import "CreateViewController.h"

@interface EditFriendsViewController ()

@end

@implementation EditFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    
   // self.tableView.backgroundColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:0.15f];
    
    self.friendsRelation = [[PFUser currentUser] objectForKey:@"friendsRelation"];

    
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
            NSLog(@"Error: %@ %@", error, [error userInfo]);
            
        }else{
            self.friends = objects;
            [indicator stopAnimating];
            [self.tableView reloadData];
            
            if (self.friends.count == 0) {
                
                UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/3.0f, self.view.frame.size.width, self.view.frame.size.height/3.0f)];
                
                [[button titleLabel] setTextAlignment: NSTextAlignmentCenter];
                
                [button setBackgroundColor:[UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:0.5f]];
                NSString *entryDetails = [NSString stringWithFormat:@"Click the Icon ( + ) above to add Friends!"];
                
                [button setTitle:entryDetails forState:UIControlStateNormal];
                
                [[button layer] setBorderWidth:2.0f];
                [[button layer] setBorderColor:[UIColor grayColor].CGColor];
                button.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:21.0f];
                
                
                button.layer.cornerRadius = 10;
                button.clipsToBounds = YES;
                
                [self.view addSubview:button];
            }else{
                
            }
            
            
        }
    }];
 
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];


}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
   // NSLog(@"NUmber of Firneds %lu", (unsigned long)self.friends.count);
    
    return [self.friends count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FriendsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    PFUser *user = [self.friends objectAtIndex:indexPath.row];
    
    if (cell==nil) {
        NSArray *nib =[[NSBundle mainBundle] loadNibNamed:@"Cell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
    }else{
        
        cell.userImage.layer.cornerRadius = 40.0f;
        cell.userImage.layer.masksToBounds = YES;
        cell.userImage.layer.borderWidth = 0;
        
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:18.0f];
        [cell.textLabel setTextColor:[UIColor grayColor]];
        
        cell.usernameLabel.text = user.username;
        
        
        PFFile *imageFile = [user objectForKey:@"imageFile"];
        
        if(imageFile != nil){
            NSURL *imageFileUrl = [[NSURL alloc] initWithString:imageFile.url];
            NSData *imageData = [NSData dataWithContentsOfURL:imageFileUrl];
            
            UIImage *userImage = [UIImage imageWithData:imageData];
            
            
            cell.userImage.image = userImage;
            
        }else{
            cell.userImage.image = [UIImage imageNamed:@"no_image.png"];
        }

        
    }
    
    return cell;
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.selectedFriend = [self.friends objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"showRelationship" sender:self];
}



#pragma mark - Navigation

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"showFriendsSelection"]) {
        
        [segue.destinationViewController setHidesBottomBarWhenPushed:YES];

        FriendSelectionViewController *viewController = (FriendSelectionViewController *) segue.destinationViewController;
       // viewController.friends = [NSMutableArray arrayWithArray:self.friends];
        viewController.friends = (NSMutableArray *)self.friends;
        
     //   NSLog(@"Friend Count is: %lu", (unsigned long)viewController.friends.count);

    }else if([segue.identifier isEqualToString:@"showRelationship"]){
        [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
        
        MentionsRelationshipViewController *relationshipViewController = (MentionsRelationshipViewController *)segue.destinationViewController;
        relationshipViewController.selectedUser = self.selectedFriend;
        
        
        
    }
}

- (IBAction)refreshFriends:(id)sender {
    
    self.friendsRelation = [[PFUser currentUser] objectForKey:@"friendsRelation"];
    
    
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
            NSLog(@"Error: %@ %@", error, [error userInfo]);
            
        }else{
            self.friends = objects;
            [indicator stopAnimating];
            [self.tableView reloadData];
        }
    }];
    
}

-(BOOL) isFriend:(PFUser *)user{
    
    for(PFUser *friend in self.friends){
        
        if ([friend.objectId isEqualToString:user.objectId]) {
            return YES;
        }
    }
    return NO;
}


#pragma mark - Table View Delegate

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// =============================== I Want to Use this Code =================================

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

// =========================================================================================

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
