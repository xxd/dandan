//
//  MyAnnotation.m
//  Dandan
//
//  Created by xxd on 12-4-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MyAnnotation.h"

@implementation MyAnnotation

CLLocationCoordinate2D coordinate; @synthesize coordinate, title, subtitle;
- (id) initWithCoordinates:(CLLocationCoordinate2D)paramCoordinates title:(NSString *)paramTitle
                  subTitle:(NSString *)paramSubTitle{ self = [super init];
    if (self != nil){
        coordinate = paramCoordinates; title = paramTitle;
        subtitle = paramSubTitle;
    }
    return(self); }
@end
