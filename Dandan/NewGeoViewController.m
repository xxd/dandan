//
//  NewGeoViewController.m
//  Dandan
//
//  Created by xxd on 12-4-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NewGeoViewController.h"
#import "ParkPlaceMark.h"
#import "MyAnnotation.h"

@interface NewGeoViewController ()

@end

@implementation NewGeoViewController
@synthesize mapView, mapPane, myLocationManager, coordinate, currentLocationButton, clearLocationButton, reverseGeocoder, forwardGeocoder, titles, subTitle,mapImage;

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
    
    [self.view addSubview:self.mapView];    
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
    [self.mapView addGestureRecognizer:longPressGesture];
}

-(void)handleLongPressGesture:(UIGestureRecognizer*)sender {
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        [self.mapView removeGestureRecognizer:sender];
    }
    else
    {
        CGPoint point = [sender locationInView:self.mapView];
        CLLocationCoordinate2D locCoord = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
        ParkPlaceMark *dropPin = [[ParkPlaceMark alloc] initWithTitle:subTitle andCoordinate:locCoord];
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
    CLLocationCoordinate2D coord = userLocation.location.coordinate;
    
    [self.mapView setRegion:MKCoordinateRegionMake(coord, MKCoordinateSpanMake(0.005f, 0.005f)) animated:YES];
    self.mapView.userLocation.title = @"当前位置:";
    self.mapView.userLocation.subtitle = subTitle;
    
    NSString *staticMapUrl = [NSString stringWithFormat:@"http://maps.google.com/maps/api/staticmap?markers=color:red|%f,%f&%@&sensor=true",coord.latitude, coord.longitude,@"zoom=10&size=60x60"];
    NSLog(@"url:%@",staticMapUrl);
    NSURL *mapUrl = [NSURL URLWithString:[staticMapUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]; 
    mapImage= [UIImage imageWithData: [NSData dataWithContentsOfURL:mapUrl]];
    
//    UIButton *composeButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [composeButton setFrame:CGRectMake(0.0f, 0.0f, 30.0f, 30.0f)];
//    [composeButton addTarget:self action:@selector(handleLocation) forControlEvents:UIControlEventTouchUpInside];
    
//    CALayer *sublayer = [composeButton layer];
//    sublayer.backgroundColor = [UIColor blueColor].CGColor;
//    sublayer.shadowOffset = CGSizeMake(0, 0);
//    sublayer.shadowRadius = 3.0;
//    sublayer.shadowColor = [UIColor blackColor].CGColor;
//    sublayer.shadowOpacity = 0.8;
//    sublayer.frame = CGRectMake(self.view.frame.size.width/2-15, self.view.frame.size.height/2-15,30,30);
//    sublayer.cornerRadius = 15;
//    
//    CALayer *imageLayer = [CALayer layer];
//    imageLayer.frame = sublayer.bounds;
//    imageLayer.cornerRadius = 15.0;
//    imageLayer.contents = (id) mapImage.CGImage;
//    imageLayer.borderWidth = 1;
//    imageLayer.borderColor = [UIColor whiteColorWithAlpha:0.7].CGColor;
//    imageLayer.masksToBounds = YES;
//    [sublayer addSublayer:imageLayer];
//    
//    UIBarButtonItem *composePost = [[UIBarButtonItem alloc] initWithCustomView:composeButton];
//    [items replaceObjectAtIndex:2 withObject:composePost];
//    [self.toolbar setItems:items animated:NO];
    
    reverseGeocoder = [[MJReverseGeocoder alloc] initWithCoordinate:coord];
    reverseGeocoder.delegate = self;
    [reverseGeocoder start];
}

#pragma mark -
#pragma mark MJReverseGeocoderDelegate

- (void)reverseGeocoder:(MJReverseGeocoder *)geocoder didFindAddress:(AddressComponents *)addressComponents{
	//hide network indicator
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	
	subTitle = [NSString stringWithFormat:@"%@ %@, %@, %@", 
                addressComponents.stateCode,
                addressComponents.city,
                addressComponents.route,
                addressComponents.streetNumber];
    NSLog(@"subTitle: %@",subTitle);
    //[self.newGeoDelegate controller:self geoInfo:subTitle];
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
