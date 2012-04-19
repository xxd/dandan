//
//  NewItemViewController.m
//  Dandan
//
//  Created by  on 12-4-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NewItemViewController.h"
#import "ParkPlaceMark.h"
#import "MyAnnotation.h"

#import <QuartzCore/QuartzCore.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import "UIColor+UIColor_Hex.h"
#import "UIImage+Resizing.h"

@interface NewItemViewController ()
static UIImage *shrinkImage(UIImage *original, CGSize size);
- (void)updateDisplay;
- (void)getMediaFromSource:(UIImagePickerControllerSourceType)sourceType;
@end

@implementation NewItemViewController
@synthesize contentTextView, toolbar;
@synthesize lastChosenMediaType, image, imageView;
@synthesize changeImageButton, clearImageButton;
@synthesize imagePane, mapPane, voicePane, songPane, openningPane, panes;
@synthesize scaledImage;
@synthesize items;
@synthesize mapView, myLocationManager, coordinate, currentLocationButton, clearLocationButton, reverseGeocoder, forwardGeocoder, titles, subTitle;

- (void)initTextView
{
	contentTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
	contentTextView.text = @"";
    contentTextView.textColor = [UIColor blackColor];
	contentTextView.font = [UIFont fontWithName:@"Helvetica" size:18.0];
	contentTextView.backgroundColor = [UIColor whiteColor];
	contentTextView.returnKeyType = UIReturnKeyDefault;
	contentTextView.keyboardType = UIKeyboardTypeDefault;
    contentTextView.scrollEnabled = YES;
    contentTextView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
	[contentTextView becomeFirstResponder];
	[self.view addSubview: contentTextView];
}

- (void)initToolbar{
    toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0, self.view.frame.size.height - 196.0 - 44.0, self.view.frame.size.width, 44.0)];
    self.toolbar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    
    [self.view addSubview: toolbar];
}

- (void)initToolbarItems{
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *imageItem = [[UIBarButtonItem alloc] initWithTitle:@"Image" style:UIBarButtonItemStylePlain target:self action:@selector(handleImage)];
    UIBarButtonItem *geoItem   = [[UIBarButtonItem alloc] initWithTitle:@"Map"   style:UIBarButtonItemStylePlain target:self action:@selector(handleLocation)];
    UIBarButtonItem *voiceItem = [[UIBarButtonItem alloc] initWithTitle:@"Voice" style:UIBarButtonItemStylePlain target:self action:@selector(handleVoice)];
    UIBarButtonItem *songItem  = [[UIBarButtonItem alloc] initWithTitle:@"Song"  style:UIBarButtonItemStylePlain target:self action:@selector(handleImage)];
    
    [imageItem setTag:0];
    
    items = [NSMutableArray arrayWithObjects: imageItem, flexible, geoItem, flexible, voiceItem, flexible, songItem, nil];
    
    [self.toolbar setItems:items animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initTextView];
    [self initToolbar];
    [self initToolbarItems];
    [self registerForKeyboardNotifications];
    
    float y = self.toolbar.frame.origin.y + self.toolbar.frame.size.height;
    float h = self.view.frame.size.height - y;
    
    imagePane = [[UIView alloc] initWithFrame:CGRectMake(0, y, 320, h)];
    mapPane = [[UIView alloc] initWithFrame:CGRectMake(0, y, 320, h)];
    voicePane = [[UIView alloc] initWithFrame:CGRectMake(0, y, 320, h)];
    songPane = [[UIView alloc] initWithFrame:CGRectMake(0, y, 320, h)];
    
    panes = [NSMutableArray arrayWithObjects:imagePane, mapPane, voicePane, songPane, nil];
    
    for (NSInteger i = 0; i < 4; i++) {
        [[panes objectAtIndex:i] setHidden:YES];
        [self.view addSubview: [panes objectAtIndex:i]];
    }
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 300, 161)];
    imageView.hidden = YES;
    
    clearImageButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [clearImageButton setFrame:CGRectMake(10, 381, 65, 25)];
    [clearImageButton setTitle:@"删除" forState:UIControlStateNormal];
    [clearImageButton addTarget:self action:@selector(clearImage) forControlEvents:UIControlEventTouchUpInside];
    clearImageButton.hidden = YES;
    
    changeImageButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [changeImageButton setFrame:CGRectMake(245, 381, 65, 25)];
    [changeImageButton setTitle:@"更换" forState:UIControlStateNormal];
    [changeImageButton addTarget:self action:@selector(changeImage) forControlEvents:UIControlEventTouchUpInside];
    changeImageButton.hidden = YES;
    
    [self.imagePane addSubview:self.imageView];
    [self.imagePane addSubview:clearImageButton];
    [self.imagePane addSubview:changeImageButton];
    
    openningPane = imagePane;
    
    [self changePane:imagePane];
}

- (void)changePane:(UIView *)paneView{
    openningPane.hidden = YES;
    openningPane = paneView;
    openningPane.hidden = NO;
}

- (void)handleVoice{
    [self changePane:voicePane];
}

- (void)clearImage{
    self.imageView.image = nil;
    self.scaledImage = nil;
    changeImageButton.hidden = YES;
    clearImageButton.hidden = YES;
    
    UIBarButtonItem *imageItem = [[UIBarButtonItem alloc] initWithTitle:@"Image" style:UIBarButtonItemStylePlain target:self action:@selector(handleImage)];
    [items replaceObjectAtIndex:0 withObject:imageItem];
    [self.toolbar setItems:items animated:NO];
    
    [contentTextView becomeFirstResponder];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self updateDisplay];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark Keyboard Notification
- (IBAction)CancelModal:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
}

- (void)ConsoleLogFrame:(CGRect)frame{
    NSLog(@"%f, %f, %f, %f", frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
}

- (void)keyboardWasShown:(NSNotification *)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGRect kbFrame = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];

    CGRect frame;
    
    frame = self.toolbar.frame;
    frame.origin.y =  self.view.frame.size.height - kbFrame.size.height - self.toolbar.frame.size.height;
    [self.toolbar setFrame:frame];
    
    frame = self.contentTextView.frame;
    frame.size.height = self.view.frame.size.height - kbFrame.size.height - self.toolbar.frame.size.height - 3.0f;
    [self.contentTextView setFrame:frame];
    
    frame = self.imagePane.frame;
    frame.size.height = kbFrame.size.height;
    frame.origin.y = self.view.frame.size.height - kbFrame.size.height;
    
    for (NSInteger i = 0; i < 4; i++) {
        [[panes objectAtIndex:i] setFrame:frame];
    }
    
    frame = self.imageView.frame;
    frame.size.height = self.imagePane.frame.size.height - 55;
    [self.imageView setFrame:frame];
    imageFrame = imageView.frame;
    
    frame = self.clearImageButton.frame;
    frame.origin.y = self.imageView.frame.origin.y + self.imageView.frame.size.height + 10;
    [self.clearImageButton setFrame:frame];
    
    frame = self.changeImageButton.frame;
    frame.origin.y = self.imageView.frame.origin.y + self.imageView.frame.size.height + 10;
    [self.changeImageButton setFrame:frame];
    
    // mapView
    frame = self.mapView.frame;
    frame.size.height = self.mapPane.frame.size.height - 55;
    [self.mapView setFrame:frame];
    
    frame = self.clearLocationButton.frame;
    frame.origin.y = self.mapView.frame.origin.y + self.mapView.frame.size.height + 10;
    [self.clearLocationButton setFrame:frame];
    
    frame = self.currentLocationButton.frame;
    frame.origin.y = self.mapView.frame.origin.y + self.mapView.frame.size.height + 10;
    [self.currentLocationButton setFrame:frame];
    
    if (self.scaledImage) {
        UIImage *cropImage = [self.scaledImage cropToSize:CGSizeMake(600, self.imageView.frame.size.height*2) usingMode:NYXCropModeCenter];
        self.imageView.image = cropImage;
    }
}

#pragma mark -
#pragma mark Location

- (void)handleLocation{
    [contentTextView resignFirstResponder];
    [self changePane:mapPane];
    
    if (!mapView) {
        mapView =[[MKMapView alloc] initWithFrame:CGRectMake(10, 10, 300, self.mapPane.frame.size.height - 55)];
        mapView.mapType = MKMapTypeStandard;
        mapView.delegate = self;
        
        if ([CLLocationManager locationServicesEnabled]){ 
            self.myLocationManager = [[CLLocationManager alloc] init];
            self.myLocationManager.delegate = self;
            self.myLocationManager.purpose = @"To provide functionality based on user's current location.";
            [self.myLocationManager startUpdatingLocation];
        } else {
            NSLog(@"Location services are not enabled");
        }
        
        clearLocationButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [clearLocationButton setFrame:CGRectMake(10, self.mapView.frame.size.height + 20, 65, 25)];
        [clearLocationButton setTitle:@"清除" forState:UIControlStateNormal];
        [clearLocationButton addTarget:self action:@selector(clearAnnotations) forControlEvents:UIControlEventTouchUpInside];
        
        currentLocationButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [currentLocationButton setFrame:CGRectMake(245, self.mapView.frame.size.height + 20, 65, 25)];
        [currentLocationButton setTitle:@"位置" forState:UIControlStateNormal];
        [currentLocationButton addTarget:self action:@selector(currentLocation) forControlEvents:UIControlEventTouchUpInside];
        
        [self.mapPane addSubview:self.mapView];
        [self.mapPane addSubview:clearLocationButton];
        [self.mapPane addSubview:currentLocationButton];
        
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
        [self.mapView addGestureRecognizer:longPressGesture];
    }
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
	ParkPlaceMark *placemark=[[ParkPlaceMark alloc] initWithCoordinate:coordinate];
	[mapView addAnnotation:placemark];
}

- (void) clearAnnotations{
	[mapView removeAnnotations:mapView.annotations];
    [self handleLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    coordinate = newLocation.coordinate;
    
    [myLocationManager stopUpdatingLocation];	
	coordinate.latitude = newLocation.coordinate.latitude;
	coordinate.longitude = newLocation.coordinate.longitude;
       
	MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, 0, 0);
    region.center = coordinate;

    MKCoordinateSpan span;
    span.latitudeDelta = 0.005;
    span.longitudeDelta = 0.005;
	region.span = span;
	
	[mapView setRegion:region animated:TRUE];
    
    reverseGeocoder = [[MJReverseGeocoder alloc] initWithCoordinate:newLocation.coordinate];
	reverseGeocoder.delegate = self;
	[reverseGeocoder start];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error 
{	
	[myLocationManager stopUpdatingLocation];
}

#pragma mark -
#pragma mark MJReverseGeocoderDelegate

- (void)reverseGeocoder:(MJReverseGeocoder *)geocoder didFindAddress:(AddressComponents *)addressComponents{
	//hide network indicator
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	
	subTitle = [NSString stringWithFormat:@"%@ %@, %@, %@", 
								 addressComponents.city,
                                addressComponents.route,
                         addressComponents.streetNumber,
                            addressComponents.stateCode];
    NSLog(@"%@",subTitle);
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


#pragma mark -
#pragma mark Handle Uploaders

- (void)handleImage{
    [contentTextView resignFirstResponder];
    [self changePane:imagePane];
    if (!imageView.image) {
        
        [self pickPhotoByActionSheet];
    }
}

- (void)changeImage{
    [contentTextView resignFirstResponder];
    [self pickPhotoByActionSheet];
}

-(void)pickPhotoByActionSheet{
    UIActionSheet *uploadImageActionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                        delegate:self
                                                               cancelButtonTitle:@"取消"
                                                          destructiveButtonTitle:nil
                                                               otherButtonTitles:@"拍照", @"选取现有的", nil];
    [uploadImageActionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex == [actionSheet cancelButtonIndex]) {
        if (!imageView.image) {
            [contentTextView becomeFirstResponder];
        }
        NSLog(@"已取消选择!");
    } else {
        switch (buttonIndex) {
            case 0:
                NSLog(@"选择拍照!");
                [self getMediaFromSource:UIImagePickerControllerSourceTypeCamera];
                break;
            case 1:
                NSLog(@"选择选取现有的!");
                [self getMediaFromSource:UIImagePickerControllerSourceTypePhotoLibrary];
                break;
            default:
                break;
        }
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    self.lastChosenMediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([lastChosenMediaType isEqual:(NSString *)kUTTypeImage]) {
        UIImage *chosenImage = [info objectForKey:UIImagePickerControllerEditedImage];
        UIImage *shrunkenImage = shrinkImage(chosenImage, CGSizeMake(310, 310));
        self.image = shrunkenImage;
    }
    [picker dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissModalViewControllerAnimated:YES];
}

static UIImage *shrinkImage(UIImage *original, CGSize size){
    CGFloat scale = [UIScreen mainScreen].scale;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, size.width*scale, size.height*scale, 8, 0, colorSpace, kCGImageAlphaPremultipliedFirst);
    CGContextDrawImage(context, CGRectMake(0, 0, size.width*scale, size.height*scale), original.CGImage);
    CGImageRef shrunken = CGBitmapContextCreateImage(context);
    UIImage *final = [UIImage imageWithCGImage:shrunken];
    CGContextRelease(context);
    CGImageRelease(shrunken);
    
    return final;
}

- (void)updateDisplay{
    if ([lastChosenMediaType isEqual:(NSString *)kUTTypeImage]) {
        self.scaledImage = [image scaleToFitSize:CGSizeMake(600, 600/image.size.width*self.image.size.height)];
        UIImage *cropImage = [self.scaledImage cropToSize:CGSizeMake(600, self.imageView.frame.size.height*2) usingMode:NYXCropModeCenter];
        self.imageView.image = cropImage;
        
        self.imageView.hidden = NO;
        self.changeImageButton.hidden = NO;
        self.clearImageButton.hidden = NO;
        
        UIButton *composeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [composeButton setFrame:CGRectMake(0.0f, 0.0f, 30.0f, 30.0f)];
        [composeButton addTarget:self action:@selector(handleImage) forControlEvents:UIControlEventTouchUpInside];
        
        CALayer *sublayer = [composeButton layer];
        sublayer.backgroundColor = [UIColor blueColor].CGColor;
        sublayer.shadowOffset = CGSizeMake(0, 0);
        sublayer.shadowRadius = 3.0;
        sublayer.shadowColor = [UIColor blackColor].CGColor;
        sublayer.shadowOpacity = 0.8;
        sublayer.frame = CGRectMake(self.view.frame.size.width/2-15, self.view.frame.size.height/2-15,30,30);
        sublayer.cornerRadius = 15;
        
        CALayer *imageLayer = [CALayer layer];
        imageLayer.frame = sublayer.bounds;
        imageLayer.cornerRadius = 15.0;
        imageLayer.contents = (id) image.CGImage;
        imageLayer.borderWidth = 1;
        imageLayer.borderColor = [UIColor whiteColorWithAlpha:0.7].CGColor;
        imageLayer.masksToBounds = YES;
        [sublayer addSublayer:imageLayer];
        
        UIBarButtonItem *composePost = [[UIBarButtonItem alloc] initWithCustomView:composeButton];
        
        [items replaceObjectAtIndex:0 withObject:composePost];
        [self.toolbar setItems:items animated:NO];
    }
}

- (void)getMediaFromSource:(UIImagePickerControllerSourceType)sourceType{
    NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:sourceType];
    if ([UIImagePickerController isSourceTypeAvailable:sourceType] && [mediaTypes count] > 0) {
        NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:sourceType];
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.mediaTypes = mediaTypes;
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentModalViewController:picker animated:YES];
    }else {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Error accessing media"
                              message:@"Device doesn't support that media source."
                              delegate:nil
                              cancelButtonTitle:@"Drat!"
                              otherButtonTitles:nil];
        [alert show];
    }
}
@end
