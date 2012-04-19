#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


@interface ParkPlaceMark : MKAnnotationView<MKAnnotation> {
	CLLocationCoordinate2D coordinate;
    NSString *title;
    NSString *subtitle;
    UIImage *image;
}
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, strong) UIImage *image;

- (id)initWithTitle:(NSString *)ttl andCoordinate:(CLLocationCoordinate2D)c2d;
-(id)initWithCoordinate:(CLLocationCoordinate2D) coordinate;

@end
