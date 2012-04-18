#import "ParkPlaceMark.h"

@implementation ParkPlaceMark
@synthesize coordinate;

- (NSString *)subtitle{
	return @"可以增加用来回忆的详细位置信息";
}
- (NSString *)title{
	return @"您所选择的单单item位置";
}

-(id)initWithCoordinate:(CLLocationCoordinate2D) c{
	coordinate=c;
	NSLog(@"%f,%f",c.latitude,c.longitude);
	return self;
}
@end
