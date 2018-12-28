//
//  playGame.m
//  MsPacman-Neat
//
//  Created by Murphy Crosby on 12/27/18.
//  Copyright © 2018 Murphy Crosby. All rights reserved.
//

#import "Game.h"
#import <IOKit/hid/IOHIDValue.h>

@implementation Game

@synthesize keyboard;
@synthesize logLevel;

- (id) init: (int) logLevel
{
    self = [super init];
    
    self.logLevel = logLevel;
    
    if(self.logLevel >= 3) {
        NSLog(@"Game :: init :: start");
    }
    self.keyboard = [[Keyboard alloc] init:1];
    
    return self;
}

- (void) play
{
    if(logLevel >= 3) {
        NSLog(@"Game :: play :: start");
    }
    
    [keyboard sendKey:kHIDUsage_KeyboardA];
}

@end
