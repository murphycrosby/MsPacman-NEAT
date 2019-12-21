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

- (id) init:(BOOL) debug workingDir:(NSString*) workingDir logLevel:(int) logLvl
{
    self = [super init];
    
    logLevel = logLvl;
    
    if(logLevel >= 3) {
        NSLog(@"Game :: init :: start");
    }
    
    if (!debug) {
        keyboard = [[Keyboard alloc] init:1];
        screen = [[Screenshot alloc] init:workingDir logLevel:1];
    }
    msPacman = [[MsPacman alloc] init:workingDir logLevel:1];
    
    int seed = 0;
    if (seed == 0) {
        srand((unsigned int)time(NULL));
    }
    else {
        srand(seed);
    }
    
    return self;
}

- (void) playEvolve:(NSString*) workingDir populationFile:(NSString*) populationFile {
    NSFileManager* fileManager = [NSFileManager defaultManager];
    CGImageRef gameScreen = nil;
    NSArray* inputs;
    Population* population;
    int generation = 1;
    long score = 0;
    BOOL gameOver = NO;
    BOOL ready = NO;
    
    if(logLevel >= 3) {
        NSLog(@"Game :: playEvolve :: start");
    }
    
    NSString* org_file = @"";
    if ([fileManager fileExistsAtPath:populationFile]) {
        population = [Population loadFromFile:populationFile];
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
            genome = [Genome createGenome:23 outputs:4];
        }
        
        population = [Population spawnInitialGenerationFromGenome:genome];
    }

    /*
    for (int i = 0; i < population.allOrganisms.count; i++) {
        Organism* o1 = [population.allOrganisms objectAtIndex:i];
        for (int j = 0; j < population.allOrganisms.count; j++) {
            Organism* o2 = [population.allOrganisms objectAtIndex:j];
            if([o1 isEqual:o2]) {
                continue;
            }
            NSLog(@"i:%d j:%d === %f",i,j,[o1.genome similarityScoreWithGenome:o2.genome]);
        }
    }
    return;
    */
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
            NSLog(@"Game :: playEvolve :: Organism :: Nodes: %lu :: Links: %lu", (unsigned long)[nextOrganism.genome.genoNodes count], (unsigned long)[nextOrganism.genome.genoLinks count]);
            
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
                        [keyboard sendKey:kHIDUsage_KeyboardUpArrow];
                        break;
                    case 1:
                        [keyboard sendKey:kHIDUsage_KeyboardRightArrow];
                        break;
                    case 2:
                        [keyboard sendKey:kHIDUsage_KeyboardDownArrow];
                        break;
                    case 3:
                        [keyboard sendKey:kHIDUsage_KeyboardLeftArrow];
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
        [self writeTracking:workingDir generation:i score:best.fitness];
        
        NSString* populationFilename = [NSString stringWithFormat:@"%@/gen-%i.pop", workingDir, population.generation];
        
        //Save the old population with the scores; overwrite if already there
        [Population saveToFile:population filename:populationFilename];
        //[Population saveToHtml:population directory:path populationId:[NSString stringWithFormat:@"%d", population.generation]];
        
        NSLog(@"Game :: playEvolve :: EVOLVE - GEN(%d)", i + 1);
        [population evolvePopulation];
        //Generation moves up one after evolution
        
        //Save the new population as bookmark
        populationFilename = [NSString stringWithFormat:@"%@/gen-%i.pop", workingDir, population.generation];
        [Population saveToFile:population filename:populationFilename];
        
        NSLog(@"Game :: playEvolve :: Fittest Organism: %1.3f", population.fittestOrganismEver.fitness);
    }
    
    NSLog(@"Game :: playEvolve :: Complete");
}

-(void) playBest:(NSString*) workingDir populationFile:(NSString*) populationFile {
    NSFileManager* fileManager = [NSFileManager defaultManager];
    CGImageRef gameScreen = nil;
    NSArray* inputs;
    Population* population;
    int generation = 1;
    long score = 0;
    BOOL gameOver = NO;
    BOOL ready = NO;
    
    if(logLevel >= 3) {
        NSLog(@"Game :: playBest :: start");
    }
    
    if ([fileManager fileExistsAtPath:populationFile]) {
        population = [Population loadFromFile:populationFile];
        generation = population.generation;
    } else {
        NSLog(@"Game :: playBest :: No population file provided. Exiting.");
        return;
    }
    
    Organism* best = population.fittestOrganismEver;
    NSLog(@" ");
    NSLog(@"Game :: playBest :: Organism :: Generation: %i :: Fitness: %1.3f", population.generation + 1, best.fitness);
    
    [best developNetwork];
    [keyboard sendKey:kHIDUsage_KeyboardA];
    [NSThread sleepForTimeInterval:1.0f];
    
    score = 0;
    gameOver = NO;
    BOOL play = FALSE;
    
    while (gameOver == NO) {
        gameScreen = [screen takeScreenshot];
        
        gameOver = [msPacman isGameOver:gameScreen];
        if(gameOver) {
            break;
        }
        
        ready = [msPacman isReady:gameScreen];
        if(ready) {
            [NSThread sleepForTimeInterval:0.3f];
            NSLog(@"Ready");
            if(!play) {
                continue;
            }
        }
        play = TRUE;
        
        inputs = [msPacman getInputValues:gameScreen];
        CGImageRelease(gameScreen);
        
        NSArray* output = [best predict:inputs];
        
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
                [keyboard sendKey:kHIDUsage_KeyboardUpArrow];
                break;
            case 1:
                [keyboard sendKey:kHIDUsage_KeyboardRightArrow];
                break;
            case 2:
                [keyboard sendKey:kHIDUsage_KeyboardDownArrow];
                break;
            case 3:
                [keyboard sendKey:kHIDUsage_KeyboardLeftArrow];
                break;
        }
    }
    NSLog(@"Game :: playBest :: Complete");
}

- (void) checkSimilarity:(NSString*) workingDir populationFile:(NSString*) populationFile {
    NSFileManager* fileManager = [NSFileManager defaultManager];
    double max = 0;
    double min = 1;
    double sum = 0;
    double count = 0;
    Population* population;
    
    if(logLevel >= 3) {
        NSLog(@"Game :: checkSimilarity :: start");
    }
    
    if ([fileManager fileExistsAtPath:populationFile]) {
        population = [Population loadFromFile:populationFile];
    } else {
        NSLog(@"Game :: checkSimilarity :: No population file provided. Exiting.");
        return;
    }
    
    for (int i = 0; i < population.allSpecies.count; i++) {
        Species* sp = [population.allSpecies objectAtIndex:i];
        Organism* fittest = sp.fittestOrganism;
        min = 1;
        max = 0;
        sum = 0;
        count = 0;
        
        for(int j = 0; j < sp.speciesOrganisms.count; j++) {
            Organism* org = [sp.speciesOrganisms objectAtIndex:j];
            
            if([fittest isEqual:org]) {
                continue;
            }
            
            double val = [fittest.genome similarityScoreWithGenome:org.genome];
            sum += val;
            if(val > max) {
                max = val;
            }
            if(val < min) {
                min = val;
            }
            NSLog(@"Fittest == %f == %d (%1.0f)", val, j, org.fitness);
            count++;
        }
        
        NSLog(@"Game :: checkSimilarity :: -----");
        NSLog(@"Game :: checkSimilarity :: Species:%i", i);
        NSLog(@"Game :: checkSimilarity :: Max:%f    Min:%f", max, min);
        NSLog(@"Game :: checkSimilarity :: Avg:%f  Count:%1.0f", sum/count, count);
        NSLog(@"Game :: checkSimilarity :: -----");
    }
    
    if(logLevel >= 3) {
        NSLog(@"Game :: checkSimilarity :: complete");
    }
}

- (void) checkAllSimilarity:(NSString*) workingDir populationFile:(NSString*) populationFile {
    NSFileManager* fileManager = [NSFileManager defaultManager];
    double max = 0;
    double min = 1;
    double sum = 0;
    double count = 0;
    Population* population;
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    
    if(logLevel >= 3) {
        NSLog(@"Game :: checkAllSimilarity :: start");
    }
    
    if ([fileManager fileExistsAtPath:populationFile]) {
        population = [Population loadFromFile:populationFile];
    } else {
        NSLog(@"Game :: checkAllSimilarity :: No population file provided. Exiting.");
        return;
    }
    
    for(int i = 0; i < population.allOrganisms.count; i++) {
        Organism* o1 = [population.allOrganisms objectAtIndex:i];
        
        for(int j = 0; j < population.allOrganisms.count; j++) {
            BOOL cont = FALSE;
            NSArray* arrI = [dict objectForKey:[NSString stringWithFormat:@"%i",i]];
            for(int k = 0; k < arrI.count; k++) {
                int intJ = [arrI[k] intValue];
                if(intJ == j) {
                    cont = TRUE;
                    break;
                }
            }
            if(cont) {
                continue;
            }
            NSArray* arrJ = [dict objectForKey:[NSString stringWithFormat:@"%i",j]];
            for(int k = 0; k < arrJ.count; k++) {
                int intI = [arrJ[k] intValue];
                if(intI == i) {
                    cont = TRUE;
                    break;
                }
            }
            if(cont) {
                continue;
            }
            
            Organism* o2 = [population.allOrganisms objectAtIndex:j];
            if([o1 isEqual:o2]) {
                continue;
            }
            
            NSMutableArray* newArrI = nil;
            if(arrI.count > 0) {
                newArrI = [NSMutableArray arrayWithArray:arrI];
            } else {
                newArrI = [[NSMutableArray alloc] init];
            }
            [newArrI addObject:[NSNumber numberWithInt:j]];
            [dict setValue:newArrI forKey:[NSString stringWithFormat:@"%i",i]];
            
            NSMutableArray* newArrJ = nil;
            if(arrJ.count > 0) {
                newArrJ = [NSMutableArray arrayWithArray:arrJ];
            } else {
                newArrJ = [[NSMutableArray alloc] init];
            }
            [newArrJ addObject:[NSNumber numberWithInt:i]];
            [dict setValue:newArrJ forKey:[NSString stringWithFormat:@"%i",j]];
            
            double val = [o1.genome similarityScoreWithGenome:o2.genome];
            sum += val;
            if(val > max) {
                max = val;
            }
            if(val < min) {
                min = val;
            }
            NSLog(@"%d == %f == %d", i, val, j);
            count++;
        }
    }
    
    NSLog(@"Game :: checkAllSimilarity :: -----");
    NSLog(@"Game :: checkAllSimilarity :: Max:%f    Min:%f", max, min);
    NSLog(@"Game :: checkAllSimilarity :: Avg:%f  Count:%1.0f", sum/count, count);
    NSLog(@"Game :: checkAllSimilarity :: -----");
    
    if(logLevel >= 3) {
        NSLog(@"Game :: checkAllSimilarity :: complete");
    }
}

-(void) writeTracking:(NSString*) workingDir generation:(int) generation score:(int) score {
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSString* tracking = [workingDir stringByAppendingString:@"generation_tracking.csv"];
    
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

-(void) dealloc {
    keyboard = nil;
    screen = nil;
    msPacman = nil;
    
    if(logLevel >= 1) {
        NSLog(@"Game :: dealloc :: Complete\n");
    }
}

@end
