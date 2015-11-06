//
//  MapViewController.h
//  StoryOfMyLife0.1
//
//  Created by Kevin Fich on 10/12/15.
//  Copyright © 2015 Kevin Fich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <MapKit/MKAnnotation.h>

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)


@interface MapViewController : UIViewController <MKMapViewDelegate,  CLLocationManagerDelegate>{
    
    MKMapView *mapView;
}

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property(nonatomic, retain) CLLocationManager *locationManager;


- (IBAction)setMapStyle:(id)sender;

@end
