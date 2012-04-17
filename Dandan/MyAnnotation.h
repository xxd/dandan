//
//  MyAnnotation.h
//  Dandan
//
//  Created by xxd on 12-4-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h> 
#import <MapKit/MapKit.h>
@interface MyAnnotation : NSObject <MKAnnotation>
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy, readonly) NSString *title; @property (nonatomic, copy, readonly) NSString *subtitle;
- (id) initWithCoordinates:(CLLocationCoordinate2D)paramCoordinates title:(NSString *)paramTitle
                  subTitle:(NSString *)paramSubTitle;
@end
