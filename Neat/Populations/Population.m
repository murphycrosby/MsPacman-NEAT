//
//  Population.m
//  MsPacman-Neat
//
//  Created by Murphy Crosby on 1/2/19.
//  Copyright © 2019 Murphy Crosby. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Population.h"
#import "Genome.h"
#import "Parameters.h"
#import "Organism.h"
#import "Utilities.h"
#import "Species.h"


@implementation Population
@synthesize allOrganisms, allSpecies, fittestOrganismEver, generation;

- (id)init
{
    self = [super init];
    if (self) {
        allOrganisms = [[NSMutableArray alloc] init];
        allSpecies = [[NSMutableArray alloc] init];
        generation = 0;
    }
    return self;
}

-(NSString*) description {
    return [NSString stringWithFormat: @"Generation %d, number of organisms %lu, highest fitness to date %1.3f: %@",
            generation, (unsigned long)[allOrganisms count],fittestOrganismEver.fitness, [allSpecies description]];
}

-(id) initWithCoder:(NSCoder*) coder {
    self = [super init];
    if (self) {
        generation = [coder decodeIntForKey:@"generation"];
        fittestOrganismEver = [coder decodeObjectOfClass:[Organism class] forKey:@"fittestOrganismEver"];
        NSSet *orgSet = [NSSet setWithArray:@[[NSMutableArray class],
                                               [Organism class]
                                               ]];
        allOrganisms = [coder decodeObjectOfClasses:orgSet forKey:@"allOrganisms"];
        
        NSSet *speciesSet = [NSSet setWithArray:@[[NSMutableArray class],
                                              [Species class]
                                              ]];
        allSpecies = [coder decodeObjectOfClasses:speciesSet forKey:@"allSpecies"];
    }
    return self;
}

-(void) encodeWithCoder:(NSCoder*) coder {
    [coder encodeInt:generation forKey:@"generation"];
    [coder encodeObject:fittestOrganismEver forKey:@"fittestOrganismEver"];
    [coder encodeObject:allOrganisms forKey:@"allOrganisms"];
    [coder encodeObject:allSpecies forKey:@"allSpecies"];
}

+(BOOL) supportsSecureCoding {
    return YES;
}

+(void) saveToHtml: (Population*) population directory: (NSString*) directory populationId: (NSString*) populationId {
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSError* error;
    
    NSString* newDirectory = [NSString stringWithFormat:@"%@/population-%@", directory, populationId];
    
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
    [str appendString:@"\t\t<title>Population</title>\n"];
    [str appendString:@"\t</head>\n"];
    [str appendString:@"\t<body style=\"font-family:'Verdana'\">\n"];
    [str appendString:[NSString stringWithFormat:@"\t\t<div>Generation: %i</div>\n", population.generation]];
    [str appendString:[NSString stringWithFormat:@"\t\t<div>Organism Count: %lu</div>\n", [population.allOrganisms count]]];
    [str appendString:[NSString stringWithFormat:@"\t\t<div>Species Count: %lu</div>\n", [population.allSpecies count]]];
    
    [str appendString:@"\t\t<span style=\"float:left;margin: 0px 20px 0px 20px;\">\n"];
    [str appendString:@"\t\t\t<h4>Organisms:</h4>\n"];
    [str appendString:@"\t\t\t<ul>\n"];
    for (int i = 0; i < population.allOrganisms.count; i++) {
        Organism* o  = [population.allOrganisms objectAtIndex:i];
        [Organism saveToHtml:o directory:newDirectory organismId:[NSString stringWithFormat:@"%02d", i+1]];
        [str appendString:[NSString stringWithFormat:@"\t\t\t\t<li><a href=\"organism-%02d.html\">%02d</a>. Fitness: %1.0f</li>\n", i+1, i+1, o.fitness]];
    }
    [str appendString:@"\t\t\t</ul>\n"];
    [str appendString:@"\t\t</span>\n"];
    
    [str appendString:@"\t\t<span style=\"float:left;margin: 0px 20px 0px 20px;\">\n"];
    [str appendString:@"\t\t\t<h4>Species:</h4>\n"];
    [str appendString:@"\t\t\t<ul>\n"];
    for (int i = 0; i < population.allSpecies.count; i++) {
        Species* sp = [population.allSpecies objectAtIndex:i];
        [Species saveToHtml:sp directory:newDirectory speciesId:[NSString stringWithFormat:@"%02d", i+1]];
        [str appendString:[NSString stringWithFormat:@"\t\t\t\t<li><a href=\"species-%02d/species-%02d.html\">%02d</a>. Fittest Fitness: %1.0f</li>\n", i+1, i+1, i+1, sp.fittestOrganism.fitness]];
    }
    [str appendString:@"\t\t\t</ul>\n"];
    [str appendString:@"\t\t</span>\n"];
    
    [str appendString:@"\t</body>\n"];
    [str appendString:@"</html>\n"];
    
    NSString* html = [NSString stringWithFormat:@"%@/population.html", newDirectory];
    [str writeToFile:html atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

+(void) saveToFile: (Population*) population filename: (NSString*) filename {
    NSError* error;
    NSData* data = [NSKeyedArchiver archivedDataWithRootObject:population requiringSecureCoding:YES error:&error];
    
    if(error != nil) {
        NSLog(@"%@", [error debugDescription]);
        return;
    }
    [data writeToFile:filename atomically:YES];
}

+(Population*) loadFromFile: (NSString*) filename {
    NSFileManager* fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:filename]) {
        return nil;
    }
    
    NSData* data = [NSData dataWithContentsOfFile:filename];
    NSError* error;
    
    Population* population = [NSKeyedUnarchiver unarchivedObjectOfClass:[Population class] fromData:data error:&error];
    if(error != nil) {
        NSLog(@"%@", [error debugDescription]);
        return nil;
    }
    return population;
}

-(Organism*) bestFitness {
    Organism* org = nil;
    for (Organism* nextOrganism in allOrganisms) {
        if(org == nil) {
            org = nextOrganism;
            continue;
        }
        if(nextOrganism.fitness > org.fitness) {
            org = nextOrganism;
        }
    }
    
    return org;
}

-(void) evolvePopulation {
    // go through each species, purge then sort by fitness
    NSMutableArray* speciesToDestroy = [[NSMutableArray alloc] init];
    for (Species* nextSpecies in allSpecies) {
        [nextSpecies clearAndAge];
        if (nextSpecies.ageSinceImprovement > [Parameters speciesAgeSinceImprovementLimit]) {
            [speciesToDestroy addObject:nextSpecies];
        }
    }
    [allSpecies removeObjectsInArray:speciesToDestroy];
    [speciesToDestroy removeAllObjects];
    
    [allSpecies sortUsingSelector:@selector(compareBestFitnessWith:)];
    
    double sumFitness = 0;
    double sumAdjustedFitness = 0;
    for (Organism* nextOrganism in allOrganisms) {
        bool foundSpecies = false;
        for (Species* nextSpecies in allSpecies) {
            if (!foundSpecies && [nextSpecies shouldIncludeOrganism:nextOrganism]) {
                foundSpecies = true;
                [nextSpecies addOrganism:nextOrganism];
                sumFitness += nextOrganism.fitness;
                sumAdjustedFitness += nextOrganism.speciesAdjustedFitness;
                break;
            }
        }
        if (!foundSpecies) {
            // need to create a new species
            Species* newSpecies = [[Species alloc] init];
            [newSpecies addOrganism:nextOrganism];
            sumFitness += nextOrganism.fitness;
            sumAdjustedFitness += nextOrganism.speciesAdjustedFitness;
            [allSpecies addObject:newSpecies];
        }
        
        if (nextOrganism.fitness > fittestOrganismEver.fitness) {
            fittestOrganismEver = [nextOrganism copy];
        }
    }
    
    for (Species* nextSpecies in allSpecies) {
        if (nextSpecies.speciesOrganisms.count == 0) {
            [speciesToDestroy addObject:nextSpecies];
        }
    }
    [allSpecies removeObjectsInArray:speciesToDestroy];
    
    // create new species and add to the general population
    double averageFitness = sumAdjustedFitness / allOrganisms.count;
    
    // sort the entire population and find out if we have a new best
    //[allOrganisms sortUsingSelector:@selector(compareFitnessWith:)];
    //Organism* org = [allOrganisms objectAtIndex:0];
    //if(fittestOrganismEver.fitness < org.fitness) {
    //    fittestOrganismEver = [org copy];
    //}
    [allOrganisms removeAllObjects];
    
    for (Species* nextSpecies in allSpecies) {
        int numberToCreate = (int) [nextSpecies numberToSpawnBasedOnAverageFitness:averageFitness];
        if(numberToCreate > [Parameters populationSize]) {
            numberToCreate = [Parameters populationSize];
        }
        NSArray* newGeneration = [nextSpecies spawnOrganisms:numberToCreate fittestEver:fittestOrganismEver];
        [allOrganisms addObjectsFromArray:newGeneration];
    }
    // this was fixed
    int speciesIndex = 0;
    for (int i = (int) [allOrganisms count] ; i < [Parameters populationSize]; i++) {
        Species* nextSpecies = [allSpecies objectAtIndex:speciesIndex];
        speciesIndex++;
        if (speciesIndex <= [allSpecies count]) {
            speciesIndex = 0;
        }
        NSArray* newGeneration = [nextSpecies spawnOrganisms:1 fittestEver:fittestOrganismEver];
        [allOrganisms addObjectsFromArray:newGeneration];
    }
    generation++;
}

+(Population*) spawnInitialGenerationFromGenome:(Genome*) genesisGenome generation:(int) generation fitness:(double) fitness {
    Population* newPopulation = [[Population alloc] init];
    newPopulation.generation = generation;
    
    Organism* firstLife = [[Organism alloc] initWithGenome: genesisGenome];
    firstLife.fitness = fitness;
    
    [newPopulation.allOrganisms addObject:firstLife];
    
    int nOrganisms = [Parameters populationSize] - 1;
    
    for (int i = 0; i < nOrganisms; i++) {
        Genome* newGenome = [[genesisGenome copy] randomiseWeights];
        Organism *nextLife = [[Organism alloc] initWithGenome: newGenome];
        
        [newPopulation.allOrganisms addObject:nextLife];
    }
    
    return newPopulation;
}

@end
