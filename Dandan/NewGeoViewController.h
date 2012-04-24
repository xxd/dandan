//
//  NewGeoViewController.h
//  Dandan
//
//  Created by xxd on 12-4-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <MapKit/MKReverseGeocoder.h>
#import <CoreLocation/CoreLocation.h>
#import "MJGeocodingServices.h"

@class NewGeoViewController;
@protocol NewGeoDelegate <NSObject>
- (void)controller:(NewGeoViewController *)controller geoInfo:(NSString *)geoInfo;
//- (void)controller:(NewGeoViewController *)controller geoImage:(UIImage *)geoImage;
@end

@interface NewGeoViewController : UIViewController<UIActionSheetDelegate, UINavigationControllerDelegate,MKMapViewDelegate,CLLocationManagerDelegate,MKAnnotation,MJReverseGeocoderDelegate, MJGeocoderDelegate>
{
    MKPlacemark *mPlacemark;
    MJReverseGeocoder *reverseGeocoder;
	MJGeocoder *forwardGeocoder;
}

@property (strong, nonatomic) MKMapView *mapView;
@property (strong, nonatomic) UIImage *mapImage;
@property (strong, nonatomic) CLLocationManager *myLocationManager;
@property (readonly, nonatomic) CLLocationCoordinate2D coordinate;
@property (strong, nonatomic) UIView *mapPane;
@property (strong, nonatomic) UIButton *currentLocationButton;
@property (strong, nonatomic) UIButton *clearLocationButton;
@property(nonatomic, retain) MJReverseGeocoder *reverseGeocoder;
@property(nonatomic, retain) MJGeocoder *forwardGeocoder;
@property(nonatomic, readonly) NSString *titles;
@property(nonatomic, readonly) NSString *subTitle;

@property (nonatomic, weak) id <NewGeoDelegate> theNewGeoDelegate;
@end
