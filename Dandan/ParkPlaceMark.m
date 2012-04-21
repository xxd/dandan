#import "ParkPlaceMark.h"

@implementation ParkPlaceMark
@synthesize title, subtitle, coordinate;
@synthesize image;

- (id)initWithTitle:(NSString *)ttl andCoordinate:(CLLocationCoordinate2D)c2d{
	[super init];
	title = @"xxd所选位置：";
	coordinate = c2d;
    subtitle = ttl;
	return self;
}

-(id)initWithCoordinate:(CLLocationCoordinate2D) c{
	coordinate=c;
	NSLog(@"%f,%f",c.latitude,c.longitude);
	return self;
}

@end
