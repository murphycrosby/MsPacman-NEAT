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
//#import "ONParameterController.h"
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
/*
-(void) addOrganism: (Organism *) org {
    [speciesOrganisms addObject:org];
    
    //modify fitness for young / old species
    //if (age < [ONParameterController youngSpeciesAgeThreshold]) {
    //    org.speciesAdjustedFitness = org.fitness * [ONParameterController youngSpeciesFitnessBonus];
    //}
    //else if (age > [ONParameterController oldSpeciesAgeThreshold]) {
    //    org.speciesAdjustedFitness = org.fitness * [ONParameterController oldSpeciesFitnessBonus];
    //}
    //else {
    //    org.speciesAdjustedFitness = org.fitness;
    //}
    if (org.fitness > fittestOrganism.fitness) {
        fittestOrganism = [org copy];
        ageSinceImprovement = 0;
    }
}


-(void) clearAndAge {
    [speciesOrganisms removeAllObjects];
    age++;
    ageSinceImprovement++;
}

-(bool) shouldIncludeOrganism:(Organism *) org {
    if ([fittestOrganism.genome similarityScoreWithGenome: org.genome] < [ONParameterController speciesCompatibilityThreshold]) {
        return true;
    }
    return false;
}

-(NSComparisonResult) compareBestFitnessWith: (Species *) anotherSpecies {
    if (self.fittestOrganism.fitness < anotherSpecies.fittestOrganism.fitness) {
        return NSOrderedDescending;
    }
    if (self.fittestOrganism.fitness == anotherSpecies.fittestOrganism.fitness) {
        return NSOrderedSame;
    }
    return NSOrderedAscending;
}

-(NSString *) description {
    return [NSString stringWithFormat:@"Species %d: %d organisms, best fitness %1.3f.  %d generations, %d without improvement",
            speciesID, [speciesOrganisms count], fittestOrganism.fitness, age, ageSinceImprovement];
}

-(double) numberToSpawnBasedOnAverageFitness: (double) averageFitness {
    double sumSpeciesAdjustedFitness = 0.0;
    
    for (Organism * nextOrganism in speciesOrganisms) {
        sumSpeciesAdjustedFitness += nextOrganism.speciesAdjustedFitness;
    }
    double numToSpawn = sumSpeciesAdjustedFitness / averageFitness;
    return numToSpawn;
}

-(NSArray *) spawnOrganisms: (int) numToSpawn {
    
    NSMutableArray * newOrganisms = [[NSMutableArray alloc] init];
    
    [newOrganisms addObject:fittestOrganism];
    
    int survivingOrganisms = [speciesOrganisms count] * [ONParameterController speciesPercentOrganismsSurvive];
    if (survivingOrganisms < 1) {
        survivingOrganisms = 1;
    }
    
    for (int i = 1; i < numToSpawn; i++) {
        Organism * dadOrganism = [speciesOrganisms objectAtIndex:(rand() % survivingOrganisms)];
        Organism * mumOrganism = [speciesOrganisms objectAtIndex:(rand() % survivingOrganisms)];
        if (mumOrganism.fitness > dadOrganism.fitness) {
            Organism * swapOrganism = dadOrganism;
            dadOrganism = mumOrganism;
            mumOrganism = swapOrganism;
        }
        if (dadOrganism == mumOrganism || randomDouble() < [ONParameterController mutateWeightOnlyDontCrossover]) {
            Organism * childOrganism = [dadOrganism reproduceChildOrganism];
            [newOrganisms addObject:childOrganism];
        }
        else {
            Organism * childOrganism = [dadOrganism reproduceChildOrganismWithOrganism: mumOrganism];
            [newOrganisms addObject:childOrganism];
        }
    }
    return newOrganisms;
}
*/

@end
