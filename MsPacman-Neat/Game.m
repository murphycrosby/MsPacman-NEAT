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
#import "Parameters.h"
#import "Population.h"
#import "Organism.h"
#import "Network.h"
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
    
    //keyboard = [[Keyboard alloc] init:1];
    //screen = [[Screenshot alloc] init:1];
    msPacman = [[MsPacman alloc] init:1];
    
    int seed = 0;
    if (seed == 0) {
        srand((unsigned int)time(NULL));
    }
    else {
        srand(seed);
    }
    
    return self;
}

- (void) playEvolve {
    CGImageRef gameScreen;
    long score = 0;
    NSMutableArray* inputs;
    BOOL gameOver = NO;
    
    //[NSThread sleepForTimeInterval:5.0f];
    if(logLevel >= 3) {
        NSLog(@"Game :: playEvolve :: start");
    }
    
    Genome* genome = [Genome createGenome:3 outputs:4];
    Population* population = [Population spawnInitialGenerationFromGenome:genome];
    
    if(logLevel >= 3) {
        NSLog(@"Game :: playEvolve :: Starting Game");
    }
    
    [population saveOganisms:@"filename"];
    //[keyboard sendKey:kHIDUsage_KeyboardA];
    
    for (int i = 0; i < [Parameters numGenerations]; i++) {
        for (Organism* nextOrganism in population.allOrganisms) {
            [nextOrganism developNetwork];
            
            NSMutableArray* arr = [[NSMutableArray alloc] init];
            [arr addObject:[NSNumber numberWithInt:42]];
            [arr addObject:[NSNumber numberWithInt:17]];
            [arr addObject:[NSNumber numberWithInt:69]];
            NSArray* output = [nextOrganism predict:arr];
            if([output count] == 4) {
                NSLog(@"Network Output: [%1.3f] [%1.3f] [%1.3f] [%1.3f]", [output[0] doubleValue], [output[1] doubleValue], [output[2] doubleValue], [output[3] doubleValue]);
            }
            [nextOrganism.network flushNetwork];
            nextOrganism.fitness = 5;
            [nextOrganism destroyNetwork];
        }
        [population evolvePopulation];
    }
    //[pop ev]
    /*
     
            //dispatch_async(queue, ^{
            //});
            score = 0;
            gameOver = NO;
            gameScreen = [screen takeScreenshot];
            while (gameOver == NO) {
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
                if(logLevel >= 3) {
                    CGRect msPacmanRect = [msPacman msPacman];
                    NSLog(@"MsPacman: %d,%d,%d,%d", (int)msPacmanRect.origin.x, (int)msPacmanRect.origin.y, (int)msPacmanRect.size.width, (int)msPacmanRect.size.height);
                    CGRect blinkyRect = [msPacman blinky];
                    NSLog(@"  Blinky: %d,%d,%d,%d", (int)blinkyRect.origin.x, (int)blinkyRect.origin.y, (int)blinkyRect.size.width, (int)blinkyRect.size.height);
                    CGRect pinkyRect = [msPacman pinky];
                    NSLog(@"   Pinky: %d,%d,%d,%d", (int)pinkyRect.origin.x, (int)pinkyRect.origin.y, (int)pinkyRect.size.width, (int)pinkyRect.size.height);
                    CGRect inkyRect = [msPacman inky];
                    NSLog(@"    Inky: %d,%d,%d,%d", (int)inkyRect.origin.x, (int)inkyRect.origin.y, (int)inkyRect.size.width, (int)inkyRect.size.height);
                    CGRect sueRect = [msPacman sue];
                    NSLog(@"     Sue: %d,%d,%d,%d", (int)sueRect.origin.x, (int)sueRect.origin.y, (int)sueRect.size.width, (int)sueRect.size.height);
                }
    
                //pass into network
                
                //[NSThread sleepForTimeInterval:1.0f];
                
                CGImageRelease(gameScreen);
                gameScreen = [screen takeScreenshot];
    
                if(logLevel >= 3) {
                    NSLog(@"Game Over: %@", ([msPacman isGameOver:gameScreen] == 0 ? @"No" : @"Yes"));
                }
                gameOver = [msPacman isGameOver:gameScreen];
                if(logLevel >= 3) {
                    NSLog(@" ");
                }
            }
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
     */
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
    
    if(logLevel >= 1) {
        NSLog(@"Game :: dealloc :: Complete\n");
    }
}

@end
