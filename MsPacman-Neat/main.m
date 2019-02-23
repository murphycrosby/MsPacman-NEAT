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
        
        int play = 0;
        NSFileManager* fileManager = [NSFileManager defaultManager];
        NSString* populationFile = @"";
        NSString* workingDir = @"";
        for(int i = 1; i < argc; i++) {
            NSString *s = [[NSString stringWithFormat:@"%s", argv[i]] lowercaseString];
            
            if([s isEqualToString:@"playevolve"]) {
                play = 0;
            } else if([s isEqualToString:@"playbest"]) {
                play = 1;
            } else if([s isEqualToString:@"checkAll"]) {
                play = 2;
            } else if([s isEqualToString:@"check"]) {
                play = 3;
            } else {
                s = [NSString stringWithFormat:@"%s", argv[i]];
                BOOL isDir;
                if ([fileManager fileExistsAtPath:s isDirectory:&isDir] && !isDir) {
                    populationFile = s;
                    workingDir = [[populationFile stringByDeletingLastPathComponent] stringByAppendingString:@"/"];
                }
                if([fileManager fileExistsAtPath:s isDirectory:&isDir] && isDir){
                    workingDir = s;
                }
            }
        }
        
        if([workingDir isEqualToString:@""]) {
            workingDir = @"/users/murphycrosby/misc/";
        }
        NSLog(@"main :: Working Directory: %@", workingDir);
        NSLog(@"main ::   Population File: %@", populationFile);
        
        BOOL debug = ((play >= 2) ? TRUE : FALSE);
        g = [[Game alloc] init:debug workingDir:workingDir logLevel:2];
        if(!g) {
            NSLog(@"main :: A game could not be allocated.");
            return 1;
        }
         
        switch (play) {
            case 0:
                NSLog(@"main :: Playing and Evolving");
                [g playEvolve:workingDir populationFile:populationFile];
                break;
            case 1:
                NSLog(@"main :: Playing the best Organism");
                [g playBest:workingDir populationFile:populationFile];
                break;
            case 2:
                NSLog(@"main :: Checking All Organisms");
                [g checkAllSimilarity:workingDir populationFile:populationFile];
                break;
            case 3:
                NSLog(@"main :: Checking Organisms against Fittest");
                [g checkSimilarity:workingDir populationFile:populationFile];
                break;
            default:
                break;
        }
        g = nil;
        
        NSLog(@"Goodbye World!");
    }
    return 0;
}
