//
//  main.m
//  MsPacman-Neat
//
//  Created by Murphy Crosby on 12/26/18.
//  Copyright © 2018 Murphy Crosby. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Game.h"

Game* g;

void controlc_handler(int s){
    printf("Caught signal %d\n",s);
    g = nil;
    exit(1);
}

int main(int argc, const char* argv[]) {
    @autoreleasepool {
        NSLog(@"Hello, World!");
        
        struct sigaction sigIntHandler;
        sigIntHandler.sa_handler = controlc_handler;
        sigemptyset(&sigIntHandler.sa_mask);
        sigIntHandler.sa_flags = 0;
        sigaction(SIGINT, &sigIntHandler, NULL);
        
        g = [[Game alloc] init:3];
        if(g) {
            [g playEvolve];
        }
        g = nil;
        
        NSLog(@"Goodbye World!");
    }
    return 0;
}
