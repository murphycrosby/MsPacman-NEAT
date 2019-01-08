//
//  Keyboard.m
//  MsPacman-Neat
//
//  Created by Murphy Crosby on 12/27/18.
//  Copyright © 2018 Murphy Crosby. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <IOKit/hidsystem/IOHIDShared.h>
#import "Keyboard.h"
#import "karabiner_virtual_hid_device_methods.hpp"

@implementation Keyboard

@synthesize connect;
@synthesize service;
@synthesize logLevel;

- (id)init: (int) logLvl {
    
    self = [super init];
    if (!self) {
        return self;
    }
    
    logLevel = logLvl;
    
    if(self.logLevel >= 3) {
        NSLog(@"Keyboard :: init :: start");
    }
    
    kern_return_t kr;
    connect = IO_OBJECT_NULL;
    service = IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceNameMatching(pqrs::karabiner_virtual_hid_device::get_virtual_hid_root_name()));
    if (!service) {
        if(logLevel >= 2) {
            NSLog(@"Keyboard :: IOServiceGetMatchingService :: ERROR\n");
        }
    }
    if(logLevel >= 3) {
        NSLog(@"Keyboard :: IOServiceGetMatchingService :: SUCCESS\n");
    }
    
    kr = IOServiceOpen(service, mach_task_self(), kIOHIDServerConnectType, &connect);
    if (kr != KERN_SUCCESS) {
        if(logLevel >= 2) {
            NSLog(@"Keyboard :: IOServiceOpen :: ERROR\n");
        }
    } else {
        if(logLevel >= 3) {
            NSLog(@"Keyboard :: IOServiceOpen :: SUCCESS\n");
        }
    }
    
    if(kr == KERN_SUCCESS) {
        pqrs::karabiner_virtual_hid_device::properties::keyboard_initialization properties;
        properties.country_code = 33;
        kr = pqrs::karabiner_virtual_hid_device_methods::initialize_virtual_hid_keyboard(connect, properties);
        if (kr != KERN_SUCCESS) {
            if(logLevel >= 2) {
                NSLog(@"Keyboard :: initialize_virtual_hid_keyboard :: ERROR\n");
            }
        } else {
            if(logLevel >= 3) {
                NSLog(@"Keyboard :: initialize_virtual_hid_keyboard :: SUCCESS\n");
            }
        }
    }
    
    if(logLevel >= 3) {
        NSLog(@"Keyboard :: init :: SUCCESS\n");
    }
    return self;
}

- (BOOL) sendKey: (uint8_t) key {
    BOOL ret = TRUE;
    pqrs::karabiner_virtual_hid_device::hid_report::keyboard_input report;
    
    //key = kHIDUsage_KeyboardA;
    report.keys.insert(key);
    kern_return_t kr = pqrs::karabiner_virtual_hid_device_methods::post_keyboard_input_report(connect, report);
    if (kr != KERN_SUCCESS) {
        ret = FALSE;
        if(logLevel >= 2) {
            NSLog(@"Keyboard :: post_keyboard_input_report :: ERROR\n");
        }
    }
    report.keys.erase(key);
    [NSThread sleepForTimeInterval:0.1f];
    kr = pqrs::karabiner_virtual_hid_device_methods::post_keyboard_input_report(connect, report);
    if (kr != KERN_SUCCESS) {
        printf("post_keyboard_input_report error\n");
    }
    
    return ret;
}

- (void)dealloc {
    if (connect) {
        IOServiceClose(connect);
    }
    if (service) {
        IOObjectRelease(service);
    }
    if(logLevel >= 3) {
        NSLog(@"Keyboard :: dealloc :: Complete\n");
    }
}

@end
