#import "ParkPlaceMark.h"

@implementation ParkPlaceMark
@synthesize title, coordinate;

- (id)initWithTitle:(NSString *)ttl andCoordinate:(CLLocationCoordinate2D)c2d {
	[super init];
	title = ttl;
	coordinate = c2d;
	return self;
}

- (NSString *)subtitle:(NSString *)subTitle{
	return @"可以增加用来回忆的详细位置信息";
}
- (NSString *)title:(NSString *)titles{
	return @"您所选择的单单item位置";
}

-(id)initWithCoordinate:(CLLocationCoordinate2D) c{
	coordinate=c;
	NSLog(@"%f,%f",c.latitude,c.longitude);
	return self;
}
@end
