//
//  Species.m
//  MsPacman-Neat
//
//  Created by Murphy Crosby on 1/2/19.
//  Copyright © 2019 Murphy Crosby. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Species.h"
#import "Organism.h"
#import "Parameters.h"
#import "Genome.h"
#import "Utilities.h"

@implementation Species
@synthesize speciesOrganisms, fittestOrganism, age, ageSinceImprovement;

static int speciesCounter = 0;

- (id)init
{
    self = [super init];
    if (self) {
        speciesID = speciesCounter++;
        speciesOrganisms = [[NSMutableArray alloc] init];
        age = 0;
        ageSinceImprovement = 0;
    }
    return self;
}

-(NSString*) description {
    return [NSString stringWithFormat:@"Species %d: %lu organisms, best fitness %1.3f.  %d generations, %d without improvement",
            speciesID, (unsigned long)[speciesOrganisms count], fittestOrganism.fitness, age, ageSinceImprovement];
}

-(id) initWithCoder:(NSCoder*) coder {
    self = [super init];
    if (self) {
        speciesID = [coder decodeIntForKey:@"speciesID"];
        age = [coder decodeIntForKey:@"age"];
        ageSinceImprovement = [coder decodeIntForKey:@"ageSinceImprovement"];
        fittestOrganism = [coder decodeObjectOfClass:[Organism class] forKey:@"fittestOrganism"];
        NSSet *set = [NSSet setWithArray:@[[NSMutableArray class],
                                                  [Organism class]
                                                  ]];
        speciesOrganisms = [coder decodeObjectOfClasses:set forKey:@"speciesOrganisms"];
    }
    return self;
}

-(void) encodeWithCoder:(NSCoder*) coder {
    [coder encodeInt:speciesID forKey:@"speciesID"];
    [coder encodeInt:age forKey:@"age"];
    [coder encodeInt:ageSinceImprovement forKey:@"ageSinceImprovement"];
    [coder encodeObject:fittestOrganism forKey:@"fittestOrganism"];
    [coder encodeObject:speciesOrganisms forKey:@"speciesOrganisms"];
}

+(BOOL) supportsSecureCoding {
    return YES;
}

-(void) clearAndAge {
    [speciesOrganisms removeAllObjects];
    age++;
    ageSinceImprovement++;
}

-(bool) shouldIncludeOrganism:(Organism*) org {
    if ([fittestOrganism.genome similarityScoreWithGenome:org.genome] < [Parameters speciesCompatibilityThreshold]) {
        return true;
    }
    return false;
}

-(void) addOrganism: (Organism*) org {
    [speciesOrganisms addObject:org];
    
    //modify fitness for young / old species
    if (age < [Parameters youngSpeciesAgeThreshold]) {
        org.speciesAdjustedFitness = org.fitness * [Parameters youngSpeciesFitnessBonus];
    }
    else if (age > [Parameters oldSpeciesAgeThreshold]) {
        org.speciesAdjustedFitness = org.fitness * [Parameters oldSpeciesFitnessBonus];
    }
    else {
        org.speciesAdjustedFitness = org.fitness;
    }
    if (org.fitness > fittestOrganism.fitness) {
        fittestOrganism = [org copy];
        ageSinceImprovement = 0;
    }
}

-(NSComparisonResult) compareBestFitnessWith: (Species*) anotherSpecies {
    if (self.fittestOrganism.fitness < anotherSpecies.fittestOrganism.fitness) {
        return NSOrderedDescending;
    }
    if (self.fittestOrganism.fitness == anotherSpecies.fittestOrganism.fitness) {
        return NSOrderedSame;
    }
    return NSOrderedAscending;
}

-(double) numberToSpawnBasedOnAverageFitness: (double) averageFitness {
    double sumSpeciesAdjustedFitness = 0.0;
    
    for (Organism* nextOrganism in speciesOrganisms) {
        sumSpeciesAdjustedFitness += nextOrganism.speciesAdjustedFitness;
    }
    double numToSpawn = sumSpeciesAdjustedFitness / averageFitness;
    return numToSpawn;
}

-(NSArray*) spawnOrganisms: (int) numToSpawn fittestEver: (Organism*) fittest; {
    NSMutableArray* newOrganisms = [[NSMutableArray alloc] init];
    
    [speciesOrganisms sortUsingSelector:@selector(compareFitnessWith:)];
    
    //[newOrganisms addObject:fittestOrganism];
    [newOrganisms addObject:[fittestOrganism copy]];
    
    long survivingOrganisms = [speciesOrganisms count] * [Parameters speciesPercentOrganismsSurvive];
    if (survivingOrganisms < 1) {
        survivingOrganisms = 1;
    }
    if(survivingOrganisms > numToSpawn) {
        survivingOrganisms = numToSpawn;
    }
    
    //Put back the top few and mutate
    for(int i = 0; i < survivingOrganisms; i++) {
        Organism* survivor = [speciesOrganisms objectAtIndex:i];
        Organism* childOrganism = [survivor reproduceChildOrganism];
        [newOrganisms addObject:childOrganism];
    }
    
    //Reproduce with the top few
    for(int i = 0; i < survivingOrganisms; i++) {
        //Organism* dadOrganism = [speciesOrganisms objectAtIndex:(arc4random() % survivingOrganisms)];
        Organism* dadOrganism;
        Organism* mumOrganism = [speciesOrganisms objectAtIndex:(arc4random() % survivingOrganisms)];
        if([mumOrganism.genome similarityScoreWithGenome:fittest.genome] < [Parameters speciesCompatibilityThreshold]) {
            dadOrganism = [fittest copy];
        } else {
            dadOrganism = [speciesOrganisms objectAtIndex:(arc4random() % survivingOrganisms)];
        }
        
        if (mumOrganism.fitness > dadOrganism.fitness) {
            Organism* swapOrganism = dadOrganism;
            dadOrganism = mumOrganism;
            mumOrganism = swapOrganism;
        }
        if (dadOrganism == mumOrganism || randomDouble() < [Parameters mutateWeightOnlyDontCrossover]) {
            NSLog(@"Species :: spawnOrganisms :: 1. start");
            NSLog(@"Species :: spawnOrganisms ::   Dad-Fitness:%1.3f, Nodes:%lu, Links:%lu",
                  dadOrganism.fitness, dadOrganism.genome.genoNodes.count, dadOrganism.genome.genoLinks.count);
            
            Organism* childOrganism = [dadOrganism reproduceChildOrganism];
            
            NSLog(@"Species :: spawnOrganisms :: Child-Fitness:%1.3f, Nodes:%lu, Links:%lu",
                  childOrganism.fitness, childOrganism.genome.genoNodes.count, childOrganism.genome.genoLinks.count);
            
            NSLog(@"Species :: spawnOrganisms :: 1. complete");
            [newOrganisms addObject:childOrganism];
        }
        else {
            NSLog(@"Species :: spawnOrganisms :: 2. start");
            NSLog(@"Species :: spawnOrganisms ::   Dad-Fitness:%1.3f, Nodes:%lu, Links:%lu",
                  dadOrganism.fitness, dadOrganism.genome.genoNodes.count, dadOrganism.genome.genoLinks.count);
            NSLog(@"Species :: spawnOrganisms ::   Mom-Fitness:%1.3f, Nodes:%lu, Links:%lu",
                  mumOrganism.fitness, mumOrganism.genome.genoNodes.count, mumOrganism.genome.genoLinks.count);
            
            Organism* childOrganism = [dadOrganism reproduceChildOrganismWithOrganism: mumOrganism];
            
            NSLog(@"Species :: spawnOrganisms :: Child-Fitness:%1.3f, Nodes:%lu, Links:%lu",
                  childOrganism.fitness, childOrganism.genome.genoNodes.count, childOrganism.genome.genoLinks.count);
            NSLog(@"Species :: spawnOrganisms :: 2. complete");
            [newOrganisms addObject:childOrganism];
        }
    }
    
    //Reproduce the top few with the bottom few
    if(survivingOrganisms > 0) {
        long count = numToSpawn - [newOrganisms count];
        //NSLog(@"species :: spawnOrganisms :: species: %lu :: surviving: %lu :: count: %lu = numToSpawn: %d - newOrganisms_count: %lu", speciesOrganisms.count, survivingOrganisms, count, numToSpawn, [newOrganisms count]);
        for (int i = 1; i <= count; i++) {
            Organism* dadOrganism = [speciesOrganisms objectAtIndex:(arc4random() % survivingOrganisms)];
            long idx = arc4random() % speciesOrganisms.count;
            if(idx + survivingOrganisms < speciesOrganisms.count) {
                idx = idx + survivingOrganisms;
            }
            Organism* mumOrganism = [speciesOrganisms objectAtIndex:idx];
            
            if (mumOrganism.fitness > dadOrganism.fitness) {
                Organism* swapOrganism = dadOrganism;
                dadOrganism = mumOrganism;
                mumOrganism = swapOrganism;
            }
            if (dadOrganism == mumOrganism || randomDouble() < [Parameters mutateWeightOnlyDontCrossover]) {
                NSLog(@"Species :: spawnOrganisms :: 3. start");
                NSLog(@"Species :: spawnOrganisms ::   Dad-Fitness:%1.3f, Nodes:%lu, Links:%lu",
                      dadOrganism.fitness, dadOrganism.genome.genoNodes.count, dadOrganism.genome.genoLinks.count);
                
                Organism* childOrganism = [dadOrganism reproduceChildOrganism];
                
                NSLog(@"Species :: spawnOrganisms :: Child-Fitness:%1.3f, Nodes:%lu, Links:%lu",
                      childOrganism.fitness, childOrganism.genome.genoNodes.count, childOrganism.genome.genoLinks.count);
                
                NSLog(@"Species :: spawnOrganisms :: 3. complete");
                [newOrganisms addObject:childOrganism];
            }
            else {
                NSLog(@"Species :: spawnOrganisms :: 4. start");
                NSLog(@"Species :: spawnOrganisms ::   Dad-Fitness:%1.3f, Nodes:%lu, Links:%lu",
                      dadOrganism.fitness, dadOrganism.genome.genoNodes.count, dadOrganism.genome.genoLinks.count);
                NSLog(@"Species :: spawnOrganisms ::   Mom-Fitness:%1.3f, Nodes:%lu, Links:%lu",
                      mumOrganism.fitness, mumOrganism.genome.genoNodes.count, mumOrganism.genome.genoLinks.count);
                
                Organism* childOrganism = [dadOrganism reproduceChildOrganismWithOrganism: mumOrganism];
                
                NSLog(@"Species :: spawnOrganisms :: Child-Fitness:%1.3f, Nodes:%lu, Links:%lu",
                      childOrganism.fitness, childOrganism.genome.genoNodes.count, childOrganism.genome.genoLinks.count);
                NSLog(@"Species :: spawnOrganisms :: 4. complete");
                [newOrganisms addObject:childOrganism];
            }
        }
    }
    
    return newOrganisms;
}

+(void) saveToHtml: (Species*) species directory: (NSString*) directory speciesId: (NSString*) speciesId {
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSError* error;
    
    NSString* newDirectory = [NSString stringWithFormat:@"%@/species-%@", directory, speciesId];
    
    if (![fileManager fileExistsAtPath:newDirectory]) {
        [fileManager createDirectoryAtPath:newDirectory withIntermediateDirectories:TRUE attributes:nil error:&error];
        if(error != nil) {
            NSLog(@"%@", [error debugDescription]);
            return;
        }
    }
    
    NSMutableString* str = [[NSMutableString alloc] init];
    [str appendString:@"<html>\n"];
    [str appendString:@"\t<head>\n"];
    [str appendString:@"\t\t<title>Species</title>\n"];
    [str appendString:@"\t</head>\n"];
    [str appendString:@"\t<body style=\"font-family:'Verdana'\">\n"];
    [str appendString:[NSString stringWithFormat:@"\t\t<div>Age: %d</div>\n", species.age]];
    [str appendString:[NSString stringWithFormat:@"\t\t<div>Age Since Improvement: %d</div>\n", species.ageSinceImprovement]];
    
    [Organism saveToHtml:species.fittestOrganism directory:newDirectory organismId:@"fittest"];
    [str appendString:[NSString stringWithFormat:@"\t\t<a href=\"organism-fittest.html\">Fittest Organism - Fitness: %1.0f</a><br/>\n", species.fittestOrganism.fitness]];
    
    [str appendString:@"\t\t<span style=\"float:left;margin: 0px 20px 0px 20px;\">\n"];
    [str appendString:@"\t\t\t<h4>Organisms:</h4>\n"];
    [str appendString:@"\t\t\t<ul>\n"];
    for (int i = 0; i < species.speciesOrganisms.count; i++) {
        Organism* o  = [species.speciesOrganisms objectAtIndex:i];
        [Organism saveToHtml:o directory:newDirectory organismId:[NSString stringWithFormat:@"%02d", i+1]];
        [str appendString:[NSString stringWithFormat:@"\t\t\t\t<li><a href=\"organism-%02d.html\">%02d</a>. Fitness: %1.0f</li>\n", i+1, i+1, o.fitness]];
    }
    [str appendString:@"\t\t\t</ul>\n"];
    [str appendString:@"\t\t</span>\n"];
    
    [str appendString:@"\t</body>\n"];
    [str appendString:@"</html>\n"];
    
    NSString* html = [NSString stringWithFormat:@"%@/species-%@.html", newDirectory, speciesId];
    [str writeToFile:html atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

-(void) dealloc {
    speciesOrganisms = nil;
    fittestOrganism = nil;
}

@end
