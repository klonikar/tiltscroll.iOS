//
//  TiltScroll.h
//
//  Created by Kiran Lonikar on 07/12/13.
//

#import <Foundation/Foundation.h>

@interface TiltScroll : NSObject {
    float xSensitivity;
    float ySensitivity;
    float xOrigin;
    float yOrigin;
    NSTimeInterval updateInterval;
    BOOL scrollWindow;
}

// Properties to control the tilt scroll speed, starting point etc.
@property(nonatomic) float xSensitivity;
@property(nonatomic) float ySensitivity;
@property(nonatomic) float xOrigin;
@property(nonatomic) float yOrigin;
@property(nonatomic) NSTimeInterval updateInterval;
@property(nonatomic) BOOL scrollWindow;

// Singleton instance
+ (TiltScroll *) sharedInstance;

// Start capturing motion updates: Do this when application becomes active
- (void) start: (NSTimeInterval) interval withXSensitivity: (float) xSens withYSensitivity: (float) ySens withXOrigin: (float) xOrg withYOrigin: (float) yOrg;

// End capturing motion updates: Do this when application is minimized/closed
- (void) end;

// Call this method to change the scroll views to be updated through motion
- (void) items: (NSArray *) svs scrollWindow: (BOOL) windowScrollFlag;

@end
