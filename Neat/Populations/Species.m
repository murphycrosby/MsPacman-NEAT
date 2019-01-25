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

/*
static float speciesCompatibilityThreshold = 0.7;
static int youngSpeciesAgeThreshold = 5;
static int youngSpeciesFitnessBonus = 3;
static int oldSpeciesAgeThreshold = 15;
static double oldSpeciesFitnessBonus = 0.5;
static double speciesPercentOrganismsSurvive = 0.2;
static double mutateWeightOnlyDontCrossover = 0.3;
*/

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

-(NSArray*) spawnOrganisms: (int) numToSpawn {
    NSMutableArray* newOrganisms = [[NSMutableArray alloc] init];
    
    [newOrganisms addObject:fittestOrganism];
    
    int survivingOrganisms = [speciesOrganisms count] * [Parameters speciesPercentOrganismsSurvive];
    if (survivingOrganisms < 1) {
        survivingOrganisms = 1;
    }
    
    for (int i = 1; i < numToSpawn; i++) {
        Organism* dadOrganism = [speciesOrganisms objectAtIndex:(arc4random() % survivingOrganisms)];
        Organism* mumOrganism = [speciesOrganisms objectAtIndex:(arc4random() % survivingOrganisms)];
        //blantent sexism right here
        if (mumOrganism.fitness > dadOrganism.fitness) {
            Organism* swapOrganism = dadOrganism;
            dadOrganism = mumOrganism;
            mumOrganism = swapOrganism;
        }
        if (dadOrganism == mumOrganism || randomDouble() < [Parameters mutateWeightOnlyDontCrossover]) {
            Organism* childOrganism = [dadOrganism reproduceChildOrganism];
            [newOrganisms addObject:childOrganism];
        }
        else {
            Organism* childOrganism = [dadOrganism reproduceChildOrganismWithOrganism: mumOrganism];
            [newOrganisms addObject:childOrganism];
        }
    }
    return newOrganisms;
}

@end
