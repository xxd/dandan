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

@interface NewItemViewController : UIViewController
<UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, MKMapViewDelegate, MKReverseGeocoderDelegate,CLLocationManagerDelegate>{
    CGRect imageFrame;
    MKMapView *mapView;
    CLLocationCoordinate2D location;
    MKPlacemark *mPlacemark;
    CLLocationManager *currentLocation;
}
@property (strong, nonatomic) UITextView *contentTextView;
@property (strong, nonatomic) UIToolbar *toolbar;
@property (strong, nonatomic) NSString *lastChosenMediaType;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIButton *changeImageButton;
@property (strong, nonatomic) UIButton *clearImageButton;
@property (strong, nonatomic) UIButton *ShowMyLocationButton;
@property (strong, nonatomic) UIButton *ClearMyLocationButton;
@property (strong, nonatomic) NSMutableArray *items;
@property (strong, nonatomic) UIView *imagePane;
@property (strong, nonatomic) UIImage *scaledImage;

- (IBAction)CancelModal:(id)sender;
- (void)registerForKeyboardNotifications;
@end
