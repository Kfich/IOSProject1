//
//  ArchiveTableViewCell.m
//  StoryOfMyLife0.1
//
//  Created by Kevin Fich on 9/15/15.
//  Copyright (c) 2015 Kevin Fich. All rights reserved.
//

#import "ArchiveTableViewCell.h"

@implementation ArchiveTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//-(void)setCellDate:(PFObject *)entry{
//    
//    self.entryDate.text = [entry objectForKey:@"entryDate"];
//    
//}
//
//-(void)setCellTitle:(PFObject *)entry{
//
//    
//    self.entryTitle.text = [entry objectForKey:@"entryTitle"];
//    
//
//}
//
//-(void)setCellImage:(PFObject *)entry{
//    
//    if ([entry objectForKey:@"imageFile"] != nil) {
//        PFFile *imageFile = [entry objectForKey:@"imageFile"];
//        NSURL *imageFileUrl = [[NSURL alloc] initWithString:imageFile.url];
//        NSData *imageData = [NSData dataWithContentsOfURL:imageFileUrl];
//        
//        self.entryImage.image = [UIImage imageWithData:imageData];
//    }else{
//        
//        self.entryImage.image = [UIImage imageNamed:@"icn_noimage.png"];
//    }
//}



@end
