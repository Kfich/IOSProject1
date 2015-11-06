//
//  ArchiveViewController.m
//  StoryOfMyLife0.1
//
//  Created by Kevin Fich on 9/6/15.
//  Copyright (c) 2015 Kevin Fich. All rights reserved.
//

#import "ArchiveViewController.h"

@interface ArchiveViewController ()

@end

@implementation ArchiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.menuView.hidden = YES;

    
    //self.tableView.backgroundColor = [UIColor colorWithRed:101/255.0 green:98/255.0 blue:102/255.0 alpha:0.15f];

    
   // refreshControl addTarget:self action:<#(SEL)#> forControlEvents:<#(UIControlEvents)#>
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
    indicator.center = self.view.center;
    [self.view addSubview:indicator];
    [indicator bringSubviewToFront:self.view];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = TRUE;
    
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        
        PFQuery *query1 = [PFQuery queryWithClassName:@"DiaryEntry"];
        [query1 whereKey:@"recipientIds" equalTo:[[PFUser currentUser] objectId]];
        
        PFQuery *query2 = [PFQuery queryWithClassName:@"DiaryEntry"];
        [query2 whereKey:@"Username" equalTo:[[PFUser currentUser] username]];
        
        PFQuery *query = [PFQuery orQueryWithSubqueries:@[query1,query2]];
        [query orderByDescending:@"createdAt"];
        
        //query.cachePolicy = kPFCachePolicyCacheThenNetwork;
        
        
        [indicator startAnimating];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
            if (error) {
                NSLog(@"Error: %@ %@", error, [error userInfo]);
                
            }else{
                //We found the messages y'all
                self.entries = (NSMutableArray *)objects;
                [indicator stopAnimating];
                [self.tableView reloadData];
                
                if (self.entries.count == 0) {
                    
                    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height/3.0f)];
                    
                    [[button titleLabel] setTextAlignment: NSTextAlignmentCenter];
                    
                    [button setBackgroundColor:[UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:0.25f]];
                    NSString *entryDetails = [NSString stringWithFormat:@"Click Here To Create Your First Entry!"];
                    
                    [button setTitle:entryDetails forState:UIControlStateNormal];
                    
                    [[button layer] setBorderWidth:2.0f];
                    [[button layer] setBorderColor:[UIColor grayColor].CGColor];
                    button.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:20.0f];
                    
                    
                    button.layer.cornerRadius = 10;
                    button.clipsToBounds = YES;
                    
                    [button addTarget:self action:@selector(showCreateView:)
                     forControlEvents:UIControlEventTouchUpInside];
                    
                    [self.view addSubview:button];
                }else{
                
                }
                
            }
            
        }];
    }
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
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
        
        cell.entryDate.text = [entry objectForKey:@"entryDate"];

        
        NSString *entryTitle = [entry objectForKey:@"entryTitle"];
        if ([entryTitle length] > 0) {
            cell.entryTitle.text = [entry objectForKey:@"entryTitle"];

        }else{
            int r = arc4random_uniform(1000);
            cell.entryTitle.text = [NSString stringWithFormat:@"Journal Entry #%lu", (unsigned long)r];
            
        }
        
        
        if ([[PFUser currentUser].objectId isEqualToString: [entry objectForKey:@"UserID"]]) {
            NSArray *recipientsList = [entry objectForKey:@"recipientIds"];
            cell.entryRecipients.text = [NSString stringWithFormat:@"Mentioned Friends: %lu", (unsigned long)recipientsList.count];
        }else{
            cell.entryRecipients.text = @"Private Entry";

        }
        
        PFFile *imageFile = [entry objectForKey:@"imageFile"];
        
        if(imageFile != nil){
            NSURL *imageFileUrl = [[NSURL alloc] initWithString:imageFile.url];
            NSData *imageData = [NSData dataWithContentsOfURL:imageFileUrl];
            
            UIImage *userImage = [UIImage imageWithData:imageData];
            
            
            cell.entryImage.image = userImage;
            
        }else{
            cell.entryImage.image = [UIImage imageNamed:@"no_image.png"];
        }
        
    }
    
    // Configure the cell...

//    cell.entryDate.text = [entry objectForKey:@"entryDate"];
//    cell.entryTitle.text = [entry objectForKey:@"entryTitle"];

    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

#pragma mark - Table view delegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ArchiveTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    self.selectedEntry = [self.entries objectAtIndex:indexPath.row];
    
    if ([cell.entryRecipients.text isEqualToString:@"Private Entry"]) {
        self.currentUserIsSender = NO;
    //    NSLog(@"Current User is sender: %i", self.currentUserIsSender);
        
    }else{
        self.currentUserIsSender = YES;
    //    NSLog(@"Current User is yes sender: %i", self.currentUserIsSender);

    }
    
    [self performSegueWithIdentifier:@"showEntryDetails" sender:self];
}

/// ============= This is where you left off (AGAIN). Removing posts from the db ==================


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

- (UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        
        PFObject *entry =[self.entries objectAtIndex:indexPath.row];
        
        if ([[PFUser currentUser].objectId isEqualToString: [entry objectForKey:@"UserID"]]) {
        [entry deleteInBackground];
        [self.entries removeObject:entry];
        [self.tableView reloadData];
        }else{
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry But You Can't Do That.." message:@"It's against the rules to delete other people's stuff. Rude!" delegate:nil cancelButtonTitle:@"Ok, I'm sorry" otherButtonTitles:nil];
            [alertView show];
            
        }
    }
    

}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"showEntryDetails"]){
        
        ArchiveDetailViewController *archiveDetailViewController = (ArchiveDetailViewController *)segue.destinationViewController;
        
        archiveDetailViewController.selectedEntry = self.selectedEntry;
        archiveDetailViewController.currentUserIsSender = self.currentUserIsSender;

    }

}


- (IBAction)createButtonPressed:(id)sender {
    
    [self.tabBarController setSelectedIndex:0];
}

- (IBAction)mentionsButtonPressed:(id)sender {
    
    [self.tabBarController setSelectedIndex:1];
}

- (IBAction)archiveButtonPressed:(id)sender {
    
    [self.tabBarController setSelectedIndex:2];
}

- (IBAction)showMenu:(id)sender {
    
    if ([sender tag] == 0) {
        [sender setTag:1];
        self.menuView.hidden = NO;
    } else {
        [sender setTag:0];
        self.menuView.hidden = YES;
    }
    
    
}


-(void)showCreateView:(UIButton*)sender{
    [self performSegueWithIdentifier:@"showCreateEntry" sender:self];
    
    
}



- (IBAction)refreshEntries:(id)sender {
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
    indicator.center = self.view.center;
    [self.view addSubview:indicator];
    [indicator bringSubviewToFront:self.view];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = TRUE;
    
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        
        PFQuery *query1 = [PFQuery queryWithClassName:@"DiaryEntry"];
        [query1 whereKey:@"recipientIds" equalTo:[[PFUser currentUser] objectId]];
        
        PFQuery *query2 = [PFQuery queryWithClassName:@"DiaryEntry"];
        [query2 whereKey:@"Username" equalTo:[[PFUser currentUser] username]];
        
        PFQuery *query = [PFQuery orQueryWithSubqueries:@[query1,query2]];
        [query orderByDescending:@"createdAt"];
        
        //query.cachePolicy = kPFCachePolicyCacheThenNetwork;
        
        
        [indicator startAnimating];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
            if (error) {
                NSLog(@"Error: %@ %@", error, [error userInfo]);
                
            }else{
                //We found the messages y'all
                self.entries = (NSMutableArray *)objects;
                [indicator stopAnimating];
                [self.tableView reloadData];
                
            }
            
        }];
    }
}

@end
