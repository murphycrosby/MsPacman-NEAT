//
//  playGame.m
//  MsPacman-Neat
//
//  Created by Murphy Crosby on 12/27/18.
//  Copyright © 2018 Murphy Crosby. All rights reserved.
//

#import "Game.h"
#import <IOKit/hid/IOHIDValue.h>
#import "Utilities.h"
#import "Population.h"
#import "Organism.h"
#import "Genome.h"

@implementation Game

@synthesize logLevel;
@synthesize keyboard;
@synthesize screen;
@synthesize msPacman;
//@synthesize sighandler;

- (id) init: (int) logLvl
{
    self = [super init];
    
    logLevel = logLvl;
    
    if(logLevel >= 3) {
        NSLog(@"Game :: init :: start");
    }
    
    //queue = dispatch_queue_create("gameloop.queue", NULL);
    //signal(SIGINT, SIG_IGN);
    //dispatch_queue_t squeue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
    //sighandler = dispatch_source_create(DISPATCH_SOURCE_TYPE_SIGNAL, SIGINT, 0, squeue);
    //dispatch_source_set_event_handler(sighandler, ^{
    //    sigint = YES;
    //    NSLog(@"Control C hit");
    // });
    //dispatch_resume(sighandler);
    
    keyboard = [[Keyboard alloc] init:logLevel];
    screen = [[Screenshot alloc] init:logLevel];
    msPacman = [[MsPacman alloc] init:3];
    
    return self;
}

- (void) playEvolve:(int) generations
{
    CGImageRef gameScreen;
    long score = 0;
    NSMutableArray* inputs;
    BOOL gameOver = NO;
    
    //[NSThread sleepForTimeInterval:5.0f];
    if(logLevel >= 3) {
        NSLog(@"Game :: playEvolve :: start");
    }
    
    Genome* genome = [Genome createGenome:5 outputs:4];
    Population* pop = [Population spawnInitialGenerationFromGenome:1 genome: genome];
    
    if(logLevel >= 3) {
        NSLog(@"Game :: playEvolve :: Starting Game");
    }
    //[keyboard sendKey:kHIDUsage_KeyboardA];
    
    //for (int i = 0; i < generations; i++) {
        //for (Organism* nextOrganism in pop.allOrganisms) {
            //[nextOrganism developNetwork];
            
            /*
            dispatch_async(queue, ^{
            });
            */
            score = 0;
            gameOver = NO;
            gameScreen = [screen takeScreenshot];
            //while (gameOver == NO) {
            //for(int i = 0; i < 10; i++) {
                score = [msPacman getScore:gameScreen];
                if(logLevel >= 3) {
                    NSLog(@"Current Score: %ld", score);
                }
    
                NSDate *methodStart;
                NSDate *methodFinish;
                if(logLevel >= 4) {
                    methodStart = [NSDate date];
                }
                inputs = [msPacman getInputValues:gameScreen];
                if(logLevel >= 4) {
                    methodFinish = [NSDate date];
                    NSTimeInterval executionTime = [methodFinish timeIntervalSinceDate:methodStart];
                    NSLog(@"executionTime = %f", executionTime);
                }
                //if(logLevel >= 3) {
                for(int i = 0; i < [inputs count]; i++) {
                    NSLog(@"%d: %d",i,[[inputs objectAtIndex:i] intValue]);
                }
                //}
    
                //pass into network
                
                //[NSThread sleepForTimeInterval:1.0f];
                
                CGImageRelease(gameScreen);
                gameScreen = [screen takeScreenshot];
    
                if(logLevel >= 3) {
                    NSLog(@"Game Over: %@", ([msPacman isGameOver:gameScreen] == 0 ? @"No" : @"Yes"));
                }
                gameOver = [msPacman isGameOver:gameScreen];
            //}
            CGImageRelease(gameScreen);
            
            //if(sigint == YES) {
            //    break;
            //}
            
            //[self evaluateOrganism: nextOrganism];
            
            //[nextOrganism destroyNetwork];
            
            NSLog(@"Game :: playEvolve :: Resetting game for new Network");
            //[keyboard sendKey:kHIDUsage_KeyboardReturnOrEnter];
            //[NSThread sleepForTimeInterval:1.0f];
            //[keyboard sendKey:kHIDUsage_KeyboardA];
        //}
        
        //if(sigint == YES) {
        //    break;
        //}
        
        //evolve
    //}
    
    //write out best network weights and everything
    
    NSLog(@"Game :: playEvolve :: Complete");
}

- (void) rectTest:(CGRect*) blah {
    if(CGRectIsEmpty(*blah)) {
        NSLog(@"CGRect is empty");
        *blah = CGRectMake(10, 10, 10, 10);
    } else {
        NSLog(@"CGRect is not empty");
        blah->origin.x += 10;
        blah->origin.y += 10;
        blah->size.width += 10;
        blah->size.height += 10;
    }
    
    return;
}

- (void) playBest {
    
}

- (void)dealloc {
    keyboard = nil;
    screen = nil;
    
    if(logLevel >= 3) {
        NSLog(@"Game :: dealloc :: Complete\n");
    }
}

@end
