#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


@interface ParkPlaceMark : NSObject<MKAnnotation> {
	CLLocationCoordinate2D coordinate;
    NSString *title;
}
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;

-(id)initWithTitle:(NSString *)ttl andCoordinate:(CLLocationCoordinate2D)c2d;
-(id)initWithCoordinate:(CLLocationCoordinate2D) coordinate;
- (NSString *)subtitle:(NSString *)subTitle;
- (NSString *)title:(NSString *)titles;

@end
