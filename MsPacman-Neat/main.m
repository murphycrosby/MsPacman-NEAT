//
//  main.m
//  MsPacman-Neat
//
//  Created by Murphy Crosby on 12/26/18.
//  Copyright © 2018 Murphy Crosby. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Game.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSLog(@"Hello, World!");
        
        Game* g = [[Game alloc] init:3];
        [g playEvolve: 1];
        g = nil;
        
        NSLog(@"Goodbye World!");
    }
    return 0;
}
