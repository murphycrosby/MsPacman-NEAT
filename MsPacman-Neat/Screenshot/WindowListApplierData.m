//
//  WindowListAplierData.m
//  MsPacman-Neat
//
//  Created by Murphy Crosby on 1/5/19.
//  Copyright © 2019 Murphy Crosby. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WindowListApplierData.h"

@implementation WindowListApplierData

NSString *kAppNameKey = @"applicationName";
NSString *kWindowOriginKey = @"windowOrigin";
NSString *kWindowSizeKey = @"windowSize";
NSString *kWindowIDKey = @"windowID";
NSString *kWindowLevelKey = @"windowLevel";
NSString *kWindowOrderKey = @"windowOrder";
NSString *kWindowBounds = @"bounds";

-(instancetype)initWindowListData:(NSMutableArray*) array
{
    self = [super init];
    
    self.outputArray = array;
    self.order = 0;
    
    return self;
}

void WindowListApplierFunction(const void *inputDictionary, void *context)
{
    NSDictionary *entry = (__bridge NSDictionary*)inputDictionary;
    WindowListApplierData *data = (__bridge WindowListApplierData*)context;
    int sharingState = [entry[(id)kCGWindowSharingState] intValue];
    if(sharingState != kCGWindowSharingNone)
    {
        NSMutableDictionary *outputEntry = [NSMutableDictionary dictionary];
        NSString *applicationName = entry[(id)kCGWindowOwnerName];
        if(applicationName != NULL)
        {
            // PID is required so we assume it's present.
            NSString *nameAndPID = [NSString stringWithFormat:@"%@ (%@)", applicationName, entry[(id)kCGWindowOwnerPID]];
            
            if(![applicationName  isEqual: @"OpenEmu"]) {
                return;
            }
            outputEntry[kAppNameKey] = nameAndPID;
        }
        else
        {
            return;
        }
        
        CGRect bounds;
        CGRectMakeWithDictionaryRepresentation((CFDictionaryRef)entry[(id)kCGWindowBounds], &bounds);
        outputEntry[kWindowBounds] = entry[(id)kCGWindowBounds];
        NSString *originString = [NSString stringWithFormat:@"%.0f/%.0f", bounds.origin.x, bounds.origin.y];
        outputEntry[kWindowOriginKey] = originString;
        NSString *sizeString = [NSString stringWithFormat:@"%.0f*%.0f", bounds.size.width, bounds.size.height];
        outputEntry[kWindowSizeKey] = sizeString;
        
        outputEntry[kWindowIDKey] = entry[(id)kCGWindowNumber];
        outputEntry[kWindowLevelKey] = entry[(id)kCGWindowLayer];
        outputEntry[kWindowOrderKey] = @(data.order);
        
        if([data.outputArray containsObject:(outputEntry)]) {
            return;
        }
        
        data.order++;
        [data.outputArray addObject:outputEntry];
    }
}

@end
