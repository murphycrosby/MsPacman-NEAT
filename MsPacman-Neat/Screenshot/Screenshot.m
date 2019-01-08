//
//  Screenshot.m
//  MsPacman-Neat
//
//  Created by Murphy Crosby on 1/5/19.
//  Copyright © 2019 Murphy Crosby. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Screenshot.h"
#import "WindowListApplierData.h"

@implementation Screenshot

@synthesize logLevel;

- (id)init: (int) logLvl {
    self = [super init];
    if (!self) {
        return self;
    }
    
    logLevel = logLvl;
    
    kWindowIDKey = @"windowID";
    kWindowBounds = @"bounds";
    
    CGWindowListOption listOptions = kCGWindowListOptionAll | kCGWindowListOptionOnScreenOnly | kCGWindowListExcludeDesktopElements;
    CFArrayRef windowList = CGWindowListCopyWindowInfo(listOptions, kCGNullWindowID);
    NSMutableArray* prunedWindowList = [NSMutableArray array];
    WindowListApplierData* windowListData = [[WindowListApplierData alloc] initWindowListData:prunedWindowList];
    CFArrayApplyFunction(windowList, CFRangeMake(0, CFArrayGetCount(windowList)), &WindowListApplierFunction, (__bridge void *)(windowListData));
    CFRelease(windowList);
    
    NSString *path = @"/Users/murphycrosby/Documents/Misc/Images/";
    NSString *filename = @"screenshot-";
    NSString *type = @".png";
    
    for(int j = 0; j < windowListData.outputArray.count; j++) {
        window = windowListData.outputArray[j];
        windowID = [window[kWindowIDKey] unsignedIntValue];
        
        NSString *dest = [NSString stringWithFormat:@"%@%@%i%@", path, filename, j, type];
        CFURLRef url = (__bridge CFURLRef)[NSURL fileURLWithPath:dest];
        
        CGImageRef windowImage = [self takeScreenshot];
        CGImageDestinationRef destination = CGImageDestinationCreateWithURL(url, kUTTypePNG, 1, NULL);
        if (!destination) {
            NSLog(@"Screenshot :: init :: Failed to create CGImageDestination for %@", path);
        } else {
            CGImageDestinationAddImage(destination, windowImage, nil);
            if (!CGImageDestinationFinalize(destination)) {
                NSLog(@"Screenshot :: init :: Failed to write image to %@", path);
            }
        }
        CGImageRelease(windowImage);
        CFRelease(destination);
    }
    
    if(windowListData.outputArray.count > 2) {
        NSLog(@"Screenshot :: init :: Which Window?");
        NSString* input = [[[NSString alloc] initWithData:[[NSFileHandle fileHandleWithStandardInput] availableData] encoding:NSUTF8StringEncoding] stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        
        NSInteger b = [input integerValue];
        window = windowListData.outputArray[b];
    } else if (windowListData.outputArray.count > 1) {
        NSLog(@"Screenshot :: init :: Window: 1");
        window = windowListData.outputArray[1];
    } else {
        NSLog(@"Screenshot :: init :: Window: 0");
        window = windowListData.outputArray[0];
    }
    windowID = [window[kWindowIDKey] unsignedIntValue];
    
    return self;
}

-(CGImageRef) takeScreenshot {
    CGWindowListOption singleWindowListOptions = kCGWindowListOptionIncludingWindow;
    CGWindowImageOption imageOptions = kCGWindowImageDefault;
    CGRect imageBounds;
    
    CGRectMakeWithDictionaryRepresentation((CFDictionaryRef)window[kWindowBounds], &imageBounds);
    CGImageRef windowImage = CGWindowListCreateImage(imageBounds, singleWindowListOptions, windowID, imageOptions);
    
    return windowImage;
}

- (void)dealloc {
    if(logLevel >= 3) {
        NSLog(@"Screenshot :: dealloc :: Complete\n");
    }
}
@end
