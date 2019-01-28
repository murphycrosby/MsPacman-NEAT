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
#import "InnovationDb.h"
#import "Population.h"
#import "Organism.h"
#import "Network.h"
#import "Genome.h"

#import "PhenomeNode.h"

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
    NSFileManager* fileManager = [NSFileManager defaultManager];
    CGImageRef gameScreen = nil;
    NSMutableArray* inputs;
    long score = 0;
    BOOL gameOver = NO;
    BOOL ready = NO;
    
    if(logLevel >= 3) {
        NSLog(@"Game :: playEvolve :: start");
    }
    
    /*
    NSMutableArray* nodes = [[NSMutableArray alloc] init];
    PhenomeNode* n1 = [[PhenomeNode alloc] init];
    n1.nodeType = OUTPUT;
    n1.activationValue = 56;
    [nodes addObject:n1];
    
    PhenomeNode* n2 = [[PhenomeNode alloc] init];
    n2.nodeType = OUTPUT;
    n2.activationValue = -54;
    [nodes addObject:n2];
    
    PhenomeNode* n3 = [[PhenomeNode alloc] init];
    n3.nodeType = OUTPUT;
    n3.activationValue = 101;
    [nodes addObject:n3];
    
    PhenomeNode* n4 = [[PhenomeNode alloc] init];
    n4.nodeType = OUTPUT;
    n4.activationValue = 1;
    [nodes addObject:n4];
    
    [Network fscale:nodes max:100 min:-100];
    
    for (PhenomeNode* nextPhenoNode in nodes) {
        if(nextPhenoNode.nodeType == OUTPUT) {
            NSLog(@"[%1.3f]", nextPhenoNode.activationValue);
        }
    }
    
    NSArray* arr = [Network fsoftmax:nodes];
    NSLog(@"[%1.3f] [%1.3f] [%1.3f] [%1.3f]", [arr[0] doubleValue], [arr[1] doubleValue], [arr[2] doubleValue], [arr[3] doubleValue]);
    
    return;
    */
    NSString* filename = @"/Users/murphycrosby/Misc/Images/org-gen-25.org";
    Organism * org;
    Genome* genome;
    int generation = 0;
    double fitness = 0;
    
    if ([fileManager fileExistsAtPath:filename]) {
        org = [Organism loadFromFile:filename];
        genome = org.genome;
        generation = org.generation + 1;
        //generation = 15 + 1;
        fitness = org.fitness;
    } else {
        genome = [Genome createGenome:366 outputs:4];
    }
    NSLog(@"Innovation: GenomeNodeID: %i, InnovationID: %i", [InnovationDb getGenomeNodeID], [InnovationDb getInnovationID]);

    Population* population = [Population spawnInitialGenerationFromGenome:genome generation:generation fitness:fitness];
    
    if(logLevel >= 3) {
        NSLog(@"Game :: playEvolve :: Starting Game");
    }
    
    NSLog(@"Game :: playEvolve :: Starting Generation: %i to %i", generation, generation + [Parameters numGenerations]);
    for (int i = generation; i < generation + [Parameters numGenerations]; i++) {
        NSLog(@" ");
        NSLog(@"Game :: playEvolve ::    Generation: %i", i);
        NSLog(@"Game :: playEvolve :: Species Count: %lu", (unsigned long)[population.allSpecies count]);
        
        for (int o = 0; o < [population.allOrganisms count]; o++) {
            Organism* nextOrganism = [population.allOrganisms objectAtIndex:o];
            NSLog(@" ");
            NSLog(@"Game :: playEvolve :: Organism (%i of %lu) :: Generation: %i", o + 1, (unsigned long)[population.allOrganisms count], i);
            
            [nextOrganism developNetwork];
            
            score = 0;
            gameOver = NO;
            BOOL play = FALSE;
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
                    NSLog(@"Prediction: [%1.4f] [%1.4f] [%1.4f] [%1.4f]", [output[0] doubleValue], [output[1] doubleValue], [output[2] doubleValue], [output[3] doubleValue]);
                }
                int argmax = -1;
                double val = 0;
                for(int i = 0; i < output.count; i++) {
                    if ([output[i] doubleValue] > val) {
                        val = [output[i] doubleValue];
                        argmax = i;
                    }
                }
                
                switch (argmax) {
                    case 0:
                        if(msPacman.canGoUp) {
                            NSLog(@"Send: Up");
                            [keyboard sendKey:kHIDUsage_KeyboardUpArrow];
                        }
                        break;
                    case 1:
                        if(msPacman.canGoRight) {
                            NSLog(@"Send: Right");
                            [keyboard sendKey:kHIDUsage_KeyboardRightArrow];
                        }
                        break;
                    case 2:
                        if(msPacman.canGoDown) {
                            NSLog(@"Send: Down");
                            [keyboard sendKey:kHIDUsage_KeyboardDownArrow];
                        }
                        break;
                    case 3:
                        if(msPacman.canGoLeft) {
                            NSLog(@"Send: Left");
                            [keyboard sendKey:kHIDUsage_KeyboardLeftArrow];
                        }
                        break;
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
            
            NSLog(@"Game :: playEvolve :: Fitness: %1.3f", nextOrganism.fitness);
            NSLog(@" ");
            NSLog(@"Game :: playEvolve :: Resetting game for new Network");
            [keyboard sendKey:kHIDUsage_KeyboardReturnOrEnter];
            [NSThread sleepForTimeInterval:1.0f];
            [keyboard sendKey:kHIDUsage_KeyboardA];
            [NSThread sleepForTimeInterval:1.0f];
        }
        
        Organism* best = [population bestFitness];
        best.generation = population.generation;
        NSLog(@"Game :: playEvolve :: Best Fitness: %1.0f", best.fitness);
        //We want to keep track of the best from each generation
        [self writeTracking:i score:best.fitness];
        
        NSString* filename = [NSString stringWithFormat:@"/Users/murphycrosby/Misc/Images/org-gen-%i",i];
        NSString* path = [NSString stringWithFormat:@"%@.org", filename];
        [Organism saveToFile:best filename:path];
        path = [NSString stringWithFormat:@"%@.txt", filename];
        [Organism printToFile:best filename:path];
        
        NSLog(@"Game :: playEvolve :: EVOLVE - GEN(%d)", i + 1);
        [population evolvePopulation];
        NSLog(@"Game :: playEvolve :: Fittest Organism: %1.3f", population.fittestOrganismEver.fitness);
    }
    
    NSLog(@"Game :: playEvolve :: Complete");
}

-(void) writeTracking:(int) generation score:(int) score {
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSString* tracking = @"/Users/murphycrosby/Misc/Images/generation_tracking.csv";
    
    if (![fileManager fileExistsAtPath:tracking]) {
        NSString* str = @"generation|fitness\n";
        NSData* data = [str dataUsingEncoding:NSUTF8StringEncoding];
        [data writeToFile:tracking atomically:YES];
    }
    
    NSFileHandle *fileHandler = [NSFileHandle fileHandleForUpdatingAtPath:tracking];
    [fileHandler seekToEndOfFile];
    NSString* str = [NSString stringWithFormat:@"%i|%i\n", generation, score];
    NSData* data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [fileHandler writeData:data];
    [fileHandler closeFile];
}

-(void) rectTest:(CGRect*) blah {
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

-(void) playBest {
    
}

-(void) dealloc {
    keyboard = nil;
    screen = nil;
    
    if(logLevel >= 1) {
        NSLog(@"Game :: dealloc :: Complete\n");
    }
}

@end
