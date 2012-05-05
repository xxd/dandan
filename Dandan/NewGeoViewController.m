//
//  NewGeoViewController.m
//  Dandan
//
//  Created by xxd on 12-4-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NewGeoViewController.h"
#import "NewItemViewController.h"
#import "ParkPlaceMark.h"
#import "MyAnnotation.h"

@interface NewGeoViewController ()

@end

@implementation NewGeoViewController
@synthesize mapView, mapPane, myLocationManager, coordinate, currentLocationButton, clearLocationButton, reverseGeocoder, forwardGeocoder, titles, subTitle, mapImage;
@synthesize theNewGeoDelegate,point,coord,coordPressed,subTitlePressed;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    mapView =[[MKMapView alloc] initWithFrame:self.view.bounds];
    mapView.mapType = MKMapTypeStandard;
    mapView.delegate = self;
    mapView.showsUserLocation = YES;
    
    if ([CLLocationManager locationServicesEnabled]){ 
        self.myLocationManager = [[CLLocationManager alloc] init];
        self.myLocationManager.delegate = self;
        self.myLocationManager.purpose = @"To provide functionality based on user's current location.";
        [self.myLocationManager startUpdatingLocation];
    } else {
        NSLog(@"Location services are not enabled");
    }
    
//    clearLocationButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [clearLocationButton setFrame:CGRectMake(10, self.mapView.frame.size.height + 20, 65, 25)];
//    [clearLocationButton setTitle:@"清除" forState:UIControlStateNormal];
//    [clearLocationButton addTarget:self action:@selector(clearAnnotations) forControlEvents:UIControlEventTouchUpInside];
//    
//    currentLocationButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [currentLocationButton setFrame:CGRectMake(245, self.mapView.frame.size.height + 20, 65, 25)];
//    [currentLocationButton setTitle:@"位置" forState:UIControlStateNormal];
//    [currentLocationButton addTarget:self action:@selector(currentLocation) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * rightButton = [[UIBarButtonItem alloc]
                                     initWithTitle:@"添加"
                                     style:UIBarButtonItemStyleBordered
                                     target:self
                                     action:@selector(addGeoToItem)];
    self.navigationItem.rightBarButtonItem = rightButton;
    self.navigationItem.title=@"添加地理位置信息";
    
    [self.view addSubview:self.mapView];    
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
    [self.mapView addGestureRecognizer:longPressGesture];
}

-(void)addGeoToItem
{
    if ([NSStringFromCGPoint(point) isEqualToString:@"{0, 0}"]) {
        NSLog(@"it's the default point {0, 0}");
        [self.theNewGeoDelegate controller:self geoInfo:subTitle];
        NSLog(@"subTitle pass to Itemview: %@",subTitle);
        [self.theNewGeoDelegate controller:self geoImage:mapImage];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        NSLog(@"it's the touch point %@",NSStringFromCGPoint(point));
        
        [self.theNewGeoDelegate controller:self geoInfo:subTitle];
        [self.theNewGeoDelegate controller:self geoImage:mapImage];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
//    [self.theNewGeoDelegate controller:self geoInfo:subTitle];
//    [self.theNewGeoDelegate controller:self geoImage:mapImage];
//    [self.navigationController popViewControllerAnimated:YES];
}

-(void)handleLongPressGesture:(UIGestureRecognizer*)sender {
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        [self.mapView removeGestureRecognizer:sender];
    }
    else
    {
        point = [sender locationInView:self.mapView];
        NSLog(@"%@",NSStringFromCGPoint(point));
//        CLLocationCoordinate2D locCoord = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
        coordPressed= [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
        [self obtainImageandGeoInfo:coordPressed];
        ParkPlaceMark *dropPin = [[ParkPlaceMark alloc] initWithTitle:subTitle andCoordinate:coordPressed];
        [self.mapView addAnnotation:dropPin];
        
    }
}

- (void) currentLocation{
    ParkPlaceMark *placemark = [[ParkPlaceMark alloc] initWithTitle:subTitle andCoordinate:coordinate];
	[mapView addAnnotation:placemark];
}

- (void) clearAnnotations{
	[mapView removeAnnotations:mapView.annotations];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    coord = userLocation.location.coordinate;
    
    [self.mapView setRegion:MKCoordinateRegionMake(coord, MKCoordinateSpanMake(0.005f, 0.005f)) animated:YES];
    //self.mapView.userLocation.title = @"当前位置:";
    //self.mapView.userLocation.subtitle = subTitle;
    NSLog(@"subTitle is: %@",subTitle);
    [self obtainImageandGeoInfo:coord];
}

- (void)obtainImageandGeoInfo:(CLLocationCoordinate2D )coordi
{
    NSString *staticMapUrl = [NSString stringWithFormat:@"http://maps.google.com/maps/api/staticmap?markers=color:red|%f,%f&%@&sensor=true",coordi.latitude, coordi.longitude,@"zoom=10&size=60x60"];
    NSLog(@"url:%@",staticMapUrl);
    NSURL *mapUrl = [NSURL URLWithString:[staticMapUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]; 
    mapImage= [UIImage imageWithData: [NSData dataWithContentsOfURL:mapUrl]];

    reverseGeocoder = [[MJReverseGeocoder alloc] initWithCoordinate:coordi];
    reverseGeocoder.delegate = self;
    [reverseGeocoder start];
}
#pragma mark -
#pragma mark MJReverseGeocoderDelegate

- (void)reverseGeocoder:(MJReverseGeocoder *)geocoder didFindAddress:(AddressComponents *)addressComponents{
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	subTitle = [NSString stringWithFormat:@"%@ %@, %@, %@", 
                addressComponents.stateCode,
                addressComponents.city,
                addressComponents.route,
                addressComponents.streetNumber];
    NSLog(@"subTitle: %@",subTitle);
}

- (void)reverseGeocoder:(MJReverseGeocoder *)geocoder didFailWithError:(NSError *)error
{
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    NSLog(@"Couldn't reverse geocode coordinate!");
}

- (MKAnnotationView *)mapView:(MKMapView *)aMapView viewForAnnotation:(id <MKAnnotation>)annotation{
    if (annotation == aMapView.userLocation) {
        return nil;
    }
    
    static NSString* AnnotationIdentifier = @"Annotation";
    MKPinAnnotationView *pinView = (MKPinAnnotationView *)[aMapView dequeueReusableAnnotationViewWithIdentifier:AnnotationIdentifier];
    
    if (!pinView) {
        MKPinAnnotationView *customPinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationIdentifier];   
        if (annotation == aMapView.userLocation) customPinView.image = [UIImage imageNamed:@"pin.png"];
        else customPinView.image = [UIImage imageNamed:@"pin.png"];
        customPinView.animatesDrop = NO;
        customPinView.canShowCallout = YES;
        UIImageView *sfIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xxd-c1.png"]];
        customPinView.leftCalloutAccessoryView = sfIconView;
        return customPinView;
    } else {
        
        pinView.annotation = annotation;
    }
    
    return pinView;
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
