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
//#import "ParameterController.h"
#import "Organism.h"
#import "Utilities.h"
#import "Species.h"

@implementation Population
@synthesize allOrganisms, allSpecies, generation;

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

-(NSString *) description {
    return [NSString stringWithFormat: @"Generation %d, number of organisms %lu, highest fitness to date %1.3f: %@",
            generation, (unsigned long)[allOrganisms count],fittestOrganismEver.fitness, [allSpecies description]];
}

+(Population *) spawnInitialGenerationFromGenome: (int) nOrganisms genome:(Genome *) genesisGenome {
    Population * newPopulation = [[Population alloc] init];
    
    Organism * firstLife = [[Organism alloc] initWithGenome: genesisGenome];
    [newPopulation.allOrganisms addObject:firstLife];
    
    for (int i = 0; i < nOrganisms; i++) {
        Genome * newGenome = [[genesisGenome copy] randomiseWeights];
        Organism *nextLife = [[Organism alloc] initWithGenome: newGenome];
    
        [newPopulation.allOrganisms addObject:nextLife];
    }
    
    return newPopulation;
}
/*
-(void) rePopulateFromFittest {
    
    // go through each species, purge then sort by fitness
    NSMutableArray * speciesToDestroy = [NSMutableArray array];
    for (Species * nextSpecies in allSpecies) {
        [nextSpecies clearAndAge];
        if (nextSpecies.ageSinceImprovement > [ONParameterController speciesAgeSinceImprovementLimit]) {
            //&& nextSpecies.fittestOrganism.fitness < fittestOrganismEver.fitness) {
            [speciesToDestroy addObject:nextSpecies];
        }
    }
    [allSpecies removeObjectsInArray:speciesToDestroy];
    [speciesToDestroy removeAllObjects];
    [allSpecies sortUsingSelector:@selector(compareBestFitnessWith:)];
    
    double sumFitness = 0;
    double sumAdjustedFitness = 0;
    for (Organism * nextOrganism in allOrganisms) {
        bool foundSpecies = false;
        for (Species * nextSpecies in allSpecies) {
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
            Species * newSpecies = [[Species alloc] init];
            [newSpecies addOrganism:nextOrganism];
            sumFitness += nextOrganism.fitness;
            sumAdjustedFitness += nextOrganism.speciesAdjustedFitness;
            [allSpecies addObject:newSpecies];
        }
        
        if (nextOrganism.fitness > fittestOrganismEver.fitness) {
            fittestOrganismEver = [nextOrganism copy];
        }
    }
    
    for (Species * nextSpecies in allSpecies) {
        if (nextSpecies.speciesOrganisms.count == 0) {
            [speciesToDestroy addObject:nextSpecies];
        }
    }
    [allSpecies removeObjectsInArray:speciesToDestroy];
    
    // create new species and add to the general population
    double averageFitness = sumAdjustedFitness / allOrganisms.count;
    
    // sort the entire population and find out if we have a new best
    [allOrganisms sortUsingSelector:@selector(compareFitnessWith:)];
    
    [allOrganisms removeAllObjects];
    for (Species * nextSpecies in allSpecies) {
        int numberToCreate = (int) [nextSpecies numberToSpawnBasedOnAverageFitness:averageFitness];
        NSArray * newGeneration = [nextSpecies spawnOrganisms:numberToCreate];
        [allOrganisms addObjectsFromArray:newGeneration];
    }
    // this was fixed
    int speciesIndex = 0;
    for (int i = (int) [allOrganisms count] ; i < [ONParameterController populationSize]; i++) {
        Species * nextSpecies = [allSpecies objectAtIndex:speciesIndex];
        speciesIndex++;
        if (speciesIndex <= [allSpecies count]) {
            speciesIndex = 0;
        }
        NSArray * newGeneration = [nextSpecies spawnOrganisms:1];
        [allOrganisms addObjectsFromArray:newGeneration];
    }
    generation++;
    
}
*/

@end
