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
        
        __block Game* g;
        
        signal(SIGINT, SIG_IGN);
        dispatch_queue_t squeue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
        dispatch_source_t sighandler = dispatch_source_create(DISPATCH_SOURCE_TYPE_SIGNAL, SIGINT, 0, squeue);
        dispatch_source_set_event_handler(sighandler, ^{
            //sigint = YES;
            g = nil;
            NSLog(@"Control C hit");
        });
        dispatch_resume(sighandler);
        
        g = [[Game alloc] init:3];
        if(g) {
            [g playEvolve: 1];
        }
        g = nil;
        
        NSLog(@"Goodbye World!");
    }
    return 0;
}
