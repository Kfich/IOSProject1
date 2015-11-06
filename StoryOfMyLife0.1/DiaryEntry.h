//
//  DiaryEntry.h
//  StoryOfMyLife0.1
//
//  Created by Kevin Fich on 8/30/15.
//  Copyright (c) 2015 Kevin Fich. All rights reserved.
//

#import <Parse/Parse.h>
#import <CoreLocation/CoreLocation.h>

@interface DiaryEntry : PFObject

@property (nonatomic, strong) NSString *entryTitle;

@property (nonatomic, strong) NSDate *entryDate;

@property (nonatomic, strong) NSString *entryBody;

@property (nonatomic, strong) NSString *entryLocation;

@property (nonatomic, strong) NSMutableArray *entryImagesArray;

@property (nonatomic, strong) NSString *entryAuthor;

@end
