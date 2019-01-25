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

#define ARC4RANDOM_MAX 0x100000000

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
    
    keyboard = [[Keyboard alloc] init:1];
    screen = [[Screenshot alloc] init:1];
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
    CGImageRef gameScreen = nil;
    long score = 0;
    NSMutableArray* inputs;
    BOOL gameOver = NO;
    BOOL ready = NO;
    
    if(logLevel >= 3) {
        NSLog(@"Game :: playEvolve :: start");
    }
    
    //Load Genome
    //or create new
    Genome* genome = [Genome createGenome:366 outputs:4];
    Population* population = [Population spawnInitialGenerationFromGenome:genome];
    
    if(logLevel >= 3) {
        NSLog(@"Game :: playEvolve :: Starting Game");
    }
    
    for (int i = 0; i < [Parameters numGenerations]; i++) {
        for (Organism* nextOrganism in population.allOrganisms) {
            //[nextOrganism printOganism];
            [nextOrganism developNetwork];
            
            score = 0;
            gameOver = NO;
            BOOL play = FALSE;
            int lastMove = 3;
            while (gameOver == NO) {
                gameScreen = [screen takeScreenshot];
                
                gameOver = [msPacman isGameOver:gameScreen];
                if(logLevel >= 3) {
                    NSLog(@"Game Over: %@", ([msPacman isGameOver:gameScreen] == 0 ? @"No" : @"Yes"));
                }
                if(gameOver) {
                    break;
                }
                
                ready = [msPacman isReady:gameScreen];
                if(ready) {
                    [NSThread sleepForTimeInterval:0.3f];
                    NSLog(@"Ready");
                    lastMove = -1;
                    if(!play) {
                        continue;
                    } else {
                        break;
                    }
                }
                play = TRUE;
                
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
                CGImageRelease(gameScreen);
                //NSString* ssss = @"";
                //for(int i = 0; i < inputs.count; i++) {
                //    double gg = [inputs[i] doubleValue];
                //    ssss = [ssss stringByAppendingString:[NSString stringWithFormat:@"%1.3f, ", gg]];
                //}
                //NSLog(@"%@", ssss);
                
                if(logLevel >= 4) {
                    methodFinish = [NSDate date];
                    NSTimeInterval executionTime = [methodFinish timeIntervalSinceDate:methodStart];
                    NSLog(@"executionTime = %f", executionTime);
                }
                
                NSArray* output = [nextOrganism predict:inputs];
                if([output count] == 4) {
                    NSLog(@"Network Output: [%1.4f] [%1.4f] [%1.4f] [%1.4f]", [output[0] doubleValue], [output[1] doubleValue], [output[2] doubleValue], [output[3] doubleValue]);
                }
                int argmax = -1;
                double val = 0;
                for(int i = 0; i < output.count; i++) {
                    if ([output[i] doubleValue] > val) {
                        val = [output[i] doubleValue];
                        argmax = i;
                    }
                }
                if (lastMove != argmax) {
                    lastMove = argmax;
                    switch (argmax) {
                        case 0:
                            NSLog(@"Send: Up");
                            [keyboard sendKey:kHIDUsage_KeyboardUpArrow];
                            break;
                        case 1:
                            NSLog(@"Send: Right");
                            [keyboard sendKey:kHIDUsage_KeyboardRightArrow];
                            break;
                        case 2:
                            NSLog(@"Send: Down");
                            [keyboard sendKey:kHIDUsage_KeyboardDownArrow];
                            break;
                        case 3:
                            NSLog(@"Send: Left");
                            [keyboard sendKey:kHIDUsage_KeyboardLeftArrow];
                            break;
                    }
                }
                
                if(logLevel >= 3) {
                    NSLog(@" ");
                }
                
                [NSThread sleepForTimeInterval:0.1f];
                //return;
            }
            CGImageRelease(gameScreen);
            
            nextOrganism.fitness = score;
            [nextOrganism destroyNetwork];
            
            NSLog(@"Fitness: %1.3f", nextOrganism.fitness);
            NSLog(@" ");
            NSLog(@"Game :: playEvolve :: Resetting game for new Network");
            [keyboard sendKey:kHIDUsage_KeyboardReturnOrEnter];
            [NSThread sleepForTimeInterval:1.0f];
            [keyboard sendKey:kHIDUsage_KeyboardA];
            [NSThread sleepForTimeInterval:1.0f];
        }
        
        NSLog(@"-- EVOLVE NETWORKS - GEN(%d) --", i + 1);
        [population evolvePopulation];
        NSLog(@"Fittest Organism: %1.3f", population.fittestOrganismEver.fitness);
        //SAVE FITTEST
    }
    
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
