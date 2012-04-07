//
//  NewItemViewController.m
//  Dandan
//
//  Created by  on 12-4-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NewItemViewController.h"

#import <MobileCoreServices/UTCoreTypes.h>

@interface NewItemViewController ()
static UIImage *shrinkImage(UIImage *original, CGSize size);
- (void)updateDisplay;
- (void)getMediaFromSource:(UIImagePickerControllerSourceType)sourceType;
@end

@implementation NewItemViewController
@synthesize contentTextView, toolbar;
@synthesize lastChosenMediaType, image, imageView;
@synthesize changeImageButton, clearImageButton;

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
    UIBarButtonItem *geoItem   = [[UIBarButtonItem alloc] initWithTitle:@"Map"   style:UIBarButtonItemStylePlain target:self action:@selector(handleImage)];
    UIBarButtonItem *voiceItem = [[UIBarButtonItem alloc] initWithTitle:@"Voice" style:UIBarButtonItemStylePlain target:self action:@selector(handleImage)];
    UIBarButtonItem *songItem  = [[UIBarButtonItem alloc] initWithTitle:@"Song"  style:UIBarButtonItemStylePlain target:self action:@selector(handleImage)];
    
    NSArray *items = [NSArray arrayWithObjects: imageItem, flexible, geoItem, flexible, voiceItem, flexible, songItem, nil];
    
    [self.toolbar setItems:items animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initTextView];
    [self initToolbar];
    [self initToolbarItems];
    [self registerForKeyboardNotifications];
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 216, 320, 200)];
    [self.view addSubview:self.imageView];
    imageView.hidden = YES;
    imageFrame = imageView.frame;
    
    changeImageButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [changeImageButton setFrame:CGRectMake(0, 0, 72, 30)];
    [changeImageButton setCenter:CGPointMake(274, 391)];
    [changeImageButton setTitle:@"更换" forState:UIControlStateNormal];
    [changeImageButton addTarget:self action:@selector(changeImage) forControlEvents:UIControlEventTouchUpInside];
    changeImageButton.hidden = YES;
    [self.view addSubview:changeImageButton];
    
    clearImageButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [clearImageButton setFrame:CGRectMake(0, 0, 72, 30)];
    [clearImageButton setCenter:CGPointMake(46, 391)];
    [clearImageButton setTitle:@"删除" forState:UIControlStateNormal];
    [clearImageButton addTarget:self action:@selector(clearImage) forControlEvents:UIControlEventTouchUpInside];
    clearImageButton.hidden = YES;
    [self.view addSubview:clearImageButton];
}

- (void)clearImage{
    self.imageView.image = nil;
    changeImageButton.hidden = YES;
    clearImageButton.hidden = YES;
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
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
}

- (void)keyboardWasShown:(NSNotification *)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    CGRect aRect = self.toolbar.frame;
    aRect.origin.y = self.view.frame.size.height - kbSize.height - self.toolbar.frame.size.height;
    [self.toolbar setFrame:aRect];
    NSLog(@"Keyboard did change & kb height is: %f",kbSize.height);
    float height = self.view.frame.size.height - kbSize.height - self.toolbar.frame.size.height - 3.0f;
    CGRect textViewRect = self.contentTextView.frame;
    textViewRect.size.height = height;
    self.contentTextView.frame = textViewRect;
}

#pragma mark -
#pragma mark Handle Uploaders

-(void)handleImage{
    [contentTextView resignFirstResponder];
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
        UIImage *shrunkenImage = shrinkImage(chosenImage, imageFrame.size);
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
        float y = self.toolbar.frame.origin.y+self.toolbar.frame.size.height;
        float height = self.view.frame.size.height-(y+20);
        self.imageView.frame = CGRectMake(10, y+10, 300, height);
        self.imageView.image = image;
        self.imageView.hidden = NO;
        self.changeImageButton.hidden = NO;
        self.clearImageButton.hidden = NO;
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