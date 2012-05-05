//
//  NewItemViewController.h
//  Dandan
//
//  Created by  on 12-4-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <MapKit/MapKit.h>
#import <MapKit/MKReverseGeocoder.h>
#import <CoreLocation/CoreLocation.h>
#import "MJGeocodingServices.h"
#import "NewGeoViewController.h"

@interface NewItemViewController : UIViewController
<UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, MKMapViewDelegate,CLLocationManagerDelegate,MKAnnotation,MJReverseGeocoderDelegate, MJGeocoderDelegate,NewGeoDelegate>
{
    CGRect imageFrame;
    MKPlacemark *mPlacemark;
    MJReverseGeocoder *reverseGeocoder;
	MJGeocoder *forwardGeocoder;
}
@property (strong, nonatomic) UITextView *contentTextView;
@property (strong, nonatomic) UIToolbar *toolbar;
@property (strong, nonatomic) NSString *lastChosenMediaType;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIButton *changeImageButton;
@property (strong, nonatomic) UIButton *clearImageButton;
@property (strong, nonatomic) NSMutableArray *items;
@property (strong, nonatomic) UIImage *scaledImage;

@property (strong, nonatomic) UIView *imagePane;
@property (strong, nonatomic) UIView *voicePane;
@property (strong, nonatomic) UIView *songPane;


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

@property(strong, nonatomic) UIView *geoInfoView;
@property (strong, nonatomic) NSMutableArray *panes;
@property (strong, nonatomic) UIView *openningPane;

- (IBAction)CancelModal:(id)sender;
- (void)registerForKeyboardNotifications;
- (void)addGeoButtonPressed;
@end
