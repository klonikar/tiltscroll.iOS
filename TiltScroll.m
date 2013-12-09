//
//  TiltScroll.m
//  HelloWorld
//
//  Created by Kiran Lonikar on 07/12/13.
//  Copyright (c) 2013 Erica Sadun. All rights reserved.
//

#import "TiltScroll.h"
#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>

@interface TiltScroll() {
    NSArray *scrollViews; // array of ScrollViews which this TiltScroll object manipulates
    CMMotionManager *motionManager;
    float ax;
    float ay;
}
@property (strong, nonatomic) NSArray * scrollViews;
@property (nonatomic) float ax;
@property (nonatomic) float ay;
@end

@implementation TiltScroll
@synthesize xSensitivity,xOrigin,ySensitivity,yOrigin, updateInterval, scrollWindow;
@synthesize scrollViews, ax, ay;

static TiltScroll *onlyInstance = Nil;

+ (void)load {
    NSLog(@"In TiltScroll:load");
    onlyInstance = [[TiltScroll alloc] init];
}

+ (TiltScroll *)sharedInstance {
    return onlyInstance;
}

- (void) attachTo: (NSArray *) svs scrollWindow: (BOOL) windowScrollFlag {
    self.scrollViews = svs;
    self.scrollWindow = windowScrollFlag;
}

- (void) attachToOne: (UIScrollView *) sv scrollWindow: (BOOL) windowScrollFlag {
    self.scrollViews = [NSArray arrayWithObject:sv];
    self.scrollWindow = windowScrollFlag;
}

- (void) start: (NSTimeInterval) interval withXSensitivity: (float) xSens withYSensitivity: (float) ySens withXOrigin: (float) xOrg withYOrigin: (float) yOrg
{
    self.updateInterval = interval;
    self.xSensitivity = xSens;
    self.ySensitivity = ySens;
    self.xOrigin = xOrg;
    self.yOrigin = yOrg;

    if (motionManager)
        return;
    
    NSLog(@"Starting motion manager");
    // Establish the motion manager
    motionManager = [[CMMotionManager alloc] init];
    motionManager.deviceMotionUpdateInterval = self.updateInterval;
    if (motionManager.deviceMotionAvailable)
        [motionManager
         startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue]
         withHandler: ^(CMDeviceMotion *motion, NSError *error) {
             if(self.scrollViews == Nil)
                 return;
             
             for (UIScrollView *sv in self.scrollViews) {
                 CGFloat x = sv.contentOffset.x + motion.attitude.roll*self.xSensitivity;
                 CGFloat y = sv.contentOffset.y + motion.attitude.pitch*self.ySensitivity;
                 if(x < 0.0 || x > sv.contentSize.width)
                     x = sv.contentOffset.x;
                 if(y < 0.0 || y > sv.contentSize.height)
                     y = sv.contentOffset.y;
                 
                 sv.contentOffset = CGPointMake(x, y);
             }
         }];
}

- (void) end
{
    NSLog(@"Shutting down motion manager");
    [motionManager stopDeviceMotionUpdates];
    motionManager = nil;
}

- (void) dealloc {
    self.scrollViews = Nil;
    [self end];
}

@end
