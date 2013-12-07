#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
#import "TiltScroll.h"

@interface TestBedViewController : UIViewController //<UIAccelerometerDelegate>
@end

@implementation TestBedViewController
{
    UIScrollView *sv;
}

- (void) loadView
{
    [super loadView];
    sv = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    self.view = sv;
}

- (void) viewDidAppear:(BOOL)animated
{
    NSString *map = @"http://maps.weather.com/images/maps/current/curwx_720x486.jpg";
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperationWithBlock:
     ^{
         // Load the weather data
         NSURL *weatherURL = [NSURL URLWithString:map];
         NSData *imageData = [NSData dataWithContentsOfURL:weatherURL];
         
         // Update the image on the main thread using the main queue
         [[NSOperationQueue mainQueue] addOperationWithBlock:^{
             UIImage *weatherImage = [UIImage imageWithData:imageData];
             UIImageView *imageView = [[UIImageView alloc] initWithImage:weatherImage];
             CGSize initSize = weatherImage.size;
             CGSize destSize = weatherImage.size;
             
             while ((destSize.width < (self.view.frame.size.width * 4)) ||
                    (destSize.height < (self.view.frame.size.height * 4)))
             {
                 destSize.width += initSize.width;
                 destSize.height += initSize.height;
             }
             
             imageView.userInteractionEnabled = NO;
             imageView.frame = (CGRect){.size = destSize};
             sv.contentSize = destSize;
             
             [sv addSubview:imageView];
             NSLog(@"Adding scroll view to tiltScroll");
             [[TiltScroll sharedInstance] items:[NSArray arrayWithObject:sv] scrollWindow:false];
         }];
     }];
}
@end

#pragma mark -

#pragma mark Application Setup
@interface TestBedAppDelegate : NSObject <UIApplicationDelegate>
@end
@implementation TestBedAppDelegate
{
	UIWindow *window;
    TestBedViewController *tbvc;
}

- (void) applicationWillResignActive:(UIApplication *)application
{
    [[TiltScroll sharedInstance] end];
}
- (void) applicationDidBecomeActive:(UIApplication *)application
{
    [[TiltScroll sharedInstance] start:0.1 withXSensitivity:10 withYSensitivity:10 withXOrigin:0 withYOrigin:0];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{	
    [application setStatusBarHidden:YES];
    // [[UINavigationBar appearance] setTintColor:COOKBOOK_PURPLE_COLOR];
    
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	tbvc = [[TestBedViewController alloc] init];
    // UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:tbvc];
    window.rootViewController = tbvc;
	[window makeKeyAndVisible];
    return YES;
}
@end
int main(int argc, char *argv[]) {
    @autoreleasepool {
        int retVal = UIApplicationMain(argc, argv, nil, @"TestBedAppDelegate");
        return retVal;
    }
}