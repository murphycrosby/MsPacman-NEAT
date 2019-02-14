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
#import "Species.h"
#import "Network.h"
#import "Genome.h"
#import "GenomeLink.h"

#import "PhenomeNode.h"

#define ARC4RANDOM_MAX 0x100000000

@implementation Game

@synthesize logLevel;
@synthesize keyboard;
@synthesize screen;
@synthesize msPacman;

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
    Population* population;
    int generation = 1;
    long score = 0;
    BOOL gameOver = NO;
    BOOL ready = NO;
    
    if(logLevel >= 3) {
        NSLog(@"Game :: playEvolve :: start");
    }
    
    NSString* pop_file = @"/Users/murphycrosby/Misc/Results-1/gen-157.pop";
    NSString* org_file = @"";
    
    if ([fileManager fileExistsAtPath:pop_file]) {
        population = [Population loadFromFile:pop_file];
        generation = population.generation;
    }
     else {
        Genome* genome;
        double fitness = 0.0;
        if ([fileManager fileExistsAtPath:org_file]) {
            Organism * organism = [Organism loadFromFile:org_file];
            genome = organism.genome;
            fitness = organism.fitness;
        } else {
            //genome = [Genome createGenome:366 outputs:4];
            genome = [Genome createGenome:80 outputs:4];
        }
        
        population = [Population spawnInitialGenerationFromGenome:genome generation:generation fitness:fitness];
    }
    
    NSLog(@"Innovation: GenomeNodeID: %i, InnovationID: %i", [InnovationDb getGenomeNodeID], [InnovationDb getInnovationID]);
    
    if(logLevel >= 3) {
        NSLog(@"Game :: playEvolve :: Starting Game");
    }
    
    NSLog(@"Game :: playEvolve :: Starting Generation: %i to %i", generation, generation + [Parameters numGenerations]);
    for (int i = generation; i < generation + [Parameters numGenerations]; i++) {
        NSLog(@" ");
        NSLog(@"Game :: playEvolve :: Population Fittest: %1.3f", population.fittestOrganismEver.fitness);
        NSLog(@"Game :: playEvolve ::         Generation: %i", i);
        NSLog(@"Game :: playEvolve ::      Species Count: %lu", (unsigned long)[population.allSpecies count]);
        for (int j = 0; j < population.allSpecies.count; j++) {
            Species* s = [population.allSpecies objectAtIndex:j];
            NSLog(@"Species Info - %d :: Count: %lu", j, [s.speciesOrganisms count]);
            NSLog(@"\t      Fittest Fitness: %1.3f", s.fittestOrganism.fitness);
            NSLog(@"\t                  Age: %i", s.age);
            NSLog(@"\tAge Since Improvement: %i", s.ageSinceImprovement);
            for(Organism* ooo in s.speciesOrganisms) {
                NSLog(@"\t\t      Fitness: %1.3f :: Simularity: %1.3f", ooo.fitness, [s.fittestOrganism.genome similarityScoreWithGenome:ooo.genome]);
            }
        }
        
        for (int o = 0; o < [population.allOrganisms count]; o++) {
            Organism* nextOrganism = [population.allOrganisms objectAtIndex:o];
            NSLog(@" ");
            NSLog(@"Game :: playEvolve :: Organism (%i of %lu) :: Generation: %i", o + 1, (unsigned long)[population.allOrganisms count], i);
            
            [nextOrganism developNetwork];
            [keyboard sendKey:kHIDUsage_KeyboardA];
            [NSThread sleepForTimeInterval:1.0f];
            
            score = 0;
            gameOver = NO;
            BOOL play = FALSE;
            while (gameOver == NO) {
                gameScreen = [screen takeScreenshot];
                
                //gameOver = [msPacman isGameOver:gameScreen];
                //if(logLevel >= 3) {
                //    NSLog(@"Game Over: %@", (gameOver == 0 ? @"No" : @"Yes"));
                //}
                //if(gameOver) {
                //    break;
                //}
                
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
                
                //score = [msPacman getScore:gameScreen];
                //score = [msPacman getPelletsEaten:gameScreen];
                //if(logLevel >= 3) {
                //    NSLog(@"Current Score: %ld", score);
                //}
                
                //NSDate *methodStart;
                //NSDate *methodFinish;
                //if(logLevel >= 4) {
                //    methodStart = [NSDate date];
                //}
                inputs = [msPacman getInputValues:gameScreen];
                CGImageRelease(gameScreen);
                //NSString* ssss = @"";
                //for(int i = 0; i < inputs.count; i++) {
                //    double gg = [inputs[i] doubleValue];
                //    ssss = [ssss stringByAppendingString:[NSString stringWithFormat:@"%1.3f, ", gg]];
                //}
                //NSLog(@"%@", ssss);
                
                //if(logLevel >= 4) {
                //    methodFinish = [NSDate date];
                //    NSTimeInterval executionTime = [methodFinish timeIntervalSinceDate:methodStart];
                //    NSLog(@"executionTime = %f", executionTime);
                //}
                
                NSArray* output = [nextOrganism predict:inputs];
                
                int argmax = -1;
                double val = 0;
                for(int i = 0; i < output.count; i++) {
                    if ([output[i] doubleValue] > val) {
                        val = [output[i] doubleValue];
                        argmax = i;
                    }
                }
                
                NSString* str = @"";
                switch (argmax) {
                    case 0:
                        str = @"Up";
                        break;
                    case 1:
                        str = @"Right";
                        break;
                    case 2:
                        str = @"Down";
                        break;
                    case 3:
                        str = @"Left";
                        break;
                }
                
                if([output count] == 4) {
                    NSLog(@"Prediction: %@ : [%1.4f] [%1.4f] [%1.4f] [%1.4f]", str,
                          [output[0] doubleValue], [output[1] doubleValue], [output[2] doubleValue], [output[3] doubleValue]);
                }
                
                switch (argmax) {
                    case 0:
                        //if(msPacman.canGoUp) {
                            //NSLog(@"Send: Up");
                            [keyboard sendKey:kHIDUsage_KeyboardUpArrow];
                        //}
                        break;
                    case 1:
                        //if(msPacman.canGoRight) {
                            //NSLog(@"Send: Right");
                            [keyboard sendKey:kHIDUsage_KeyboardRightArrow];
                        //}
                        break;
                    case 2:
                        //if(msPacman.canGoDown) {
                            //NSLog(@"Send: Down");
                            [keyboard sendKey:kHIDUsage_KeyboardDownArrow];
                        //}
                        break;
                    case 3:
                        //if(msPacman.canGoLeft) {
                            //NSLog(@"Send: Left");
                            [keyboard sendKey:kHIDUsage_KeyboardLeftArrow];
                        //}
                        break;
                }
                
                if(logLevel >= 3) {
                    NSLog(@" ");
                }
                
                //[NSThread sleepForTimeInterval:0.1f];
            }
            score = [msPacman getPelletsEaten:gameScreen];
            CGImageRelease(gameScreen);
            
            nextOrganism.fitness = score;
            [nextOrganism destroyNetwork];
            
            NSLog(@"Game :: playEvolve :: Fitness: %1.3f", nextOrganism.fitness);
            NSLog(@" ");
            NSLog(@"Game :: playEvolve :: Resetting game for new Network");
            [keyboard sendKey:kHIDUsage_KeyboardReturnOrEnter];
            [NSThread sleepForTimeInterval:1.0f];
        }
        
        //We want to keep track of the best from each generation
        Organism* best = [population bestFitness];
        NSLog(@"Game :: playEvolve :: Best Fitness: %1.0f", best.fitness);
        [self writeTracking:i score:best.fitness];
        
        NSString* path = @"/Users/murphycrosby/Misc/Results-1/";
        NSString* populationFilename = [NSString stringWithFormat:@"%@/gen-%i.pop", path, population.generation];
        
        //Save the old population with the scores; overwrite if already there
        [Population saveToFile:population filename:populationFilename];
        //[Population saveToHtml:population directory:path populationId:[NSString stringWithFormat:@"%d", population.generation]];
        
        NSLog(@"Game :: playEvolve :: EVOLVE - GEN(%d)", i + 1);
        [population evolvePopulation];
        //Generation moves up one after evolution
        
        //Save the new population as bookmark
        populationFilename = [NSString stringWithFormat:@"%@/gen-%i.pop", path, population.generation];
        [Population saveToFile:population filename:populationFilename];
        
        NSLog(@"Game :: playEvolve :: Fittest Organism: %1.3f", population.fittestOrganismEver.fitness);
    }
    
    NSLog(@"Game :: playEvolve :: Complete");
}

-(void) writeTracking:(int) generation score:(int) score {
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSString* tracking = @"/Users/murphycrosby/Misc/Results-1/generation_tracking.csv";
    
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
