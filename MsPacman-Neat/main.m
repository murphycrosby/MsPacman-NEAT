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
        
        Game* g = [[Game alloc] init:1];
        [g play];
        
        NSLog(@"Goodbye World!");
    }
    return 0;
}
