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

static BOOL sigint = NO;

@synthesize logLevel;
@synthesize keyboard;
@synthesize screen;
@synthesize msPacman;
@synthesize sighandler;

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
    msPacman = [[MsPacman alloc] init:logLevel];
    
    return self;
}

- (void) playEvolve:(int) generations
{
    CGImageRef gameScreen;
    long score = 0;
    NSMutableArray* inputs;
    BOOL gameOver = NO;
    
    [NSThread sleepForTimeInterval:5.0f];
    if(logLevel >= 3) {
        NSLog(@"Game :: playEvolve :: start");
    }
    
    Genome* genome = [Genome createGenome:5 outputs:4];
    Population* pop = [Population spawnInitialGenerationFromGenome:1 genome: genome];
    
    NSLog(@"Game :: playEvolve :: Starting Game");
    //[keyboard sendKey:kHIDUsage_KeyboardA];
    
    for (int i = 0; i < generations; i++) {
        for (Organism* nextOrganism in pop.allOrganisms) {
            [nextOrganism developNetwork];
            
            /*
            dispatch_async(queue, ^{
            });
            */
            score = 0;
            gameOver = NO;
            gameScreen = [screen takeScreenshot];
            while (gameOver == NO && sigint == NO) {
                score = [msPacman getScore:gameScreen];
                NSLog(@"Current Score: %ld", score);
                
                inputs = [msPacman getInputValues:gameScreen];
                
                //pass into network
                
                [NSThread sleepForTimeInterval:1.0f];
                
                CGImageRelease(gameScreen);
                gameScreen = [screen takeScreenshot];
                
                NSLog(@"Game Over: %@", ([msPacman isGameOver:gameScreen] == 0 ? @"No" : @"Yes"));
                if([msPacman isGameOver:gameScreen]) {
                    gameOver = YES;
                    sigint = YES;
                }
            }
            CGImageRelease(gameScreen);
            
            if(sigint == YES) {
                break;
            }
            
            //[self evaluateOrganism: nextOrganism];
            
            [nextOrganism destroyNetwork];
            
            NSLog(@"Game :: playEvolve :: Resetting game for new Network");
            //[keyboard sendKey:kHIDUsage_KeyboardReturnOrEnter];
            //[NSThread sleepForTimeInterval:1.0f];
            //[keyboard sendKey:kHIDUsage_KeyboardA];
        }
        
        if(sigint == YES) {
            break;
        }
        
        //evolve
    }
    
    //write out best network weights and everything
    
    NSLog(@"Game :: playEvolve :: Complete");
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
