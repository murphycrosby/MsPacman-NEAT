//
//  Organism.m
//  MsPacman-Neat
//
//  Created by Murphy Crosby on 1/2/19.
//  Copyright © 2019 Murphy Crosby. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Organism.h"
#import "Genome.h"
#import "Network.h"

@implementation Organism
@synthesize network, genome, fitness, speciesAdjustedFitness;

-(NSString*) description {
    return [NSString stringWithFormat: @"Organism with fitness: %1.3f", fitness];
}

- (id)initWithGenome: (Genome*) dna
{
    self = [super init];
    if (self) {
        genome = dna;
        fitness = 0;
        speciesAdjustedFitness = 0;
    }
    return self;
}

-(void) developNetwork {
    NSAssert(genome != nil, @"This organisms genome has not been set - cannot develop network without a genome");
    network = [[Network alloc] initWithGenome:genome];
}

-(NSArray*) predict: (NSArray*) inputValuesArray {
    [network updateSensors:inputValuesArray];
    return [network activateNetwork];
}

-(void) destroyNetwork {
    network = nil;
}

-(Organism*) reproduceChildOrganism {
    Genome* childGenome = [genome copy];
    [childGenome mutateGenome];
    Organism* childOrganism = [[Organism alloc] initWithGenome:childGenome];
    return childOrganism;
}

-(Organism*) reproduceChildOrganismWithOrganism: (Organism*) lessFitMate {
    Genome* childGenome = [genome offspringWithGenome: lessFitMate.genome];
    [childGenome mutateGenome];
    Organism* childOrganism = [[Organism alloc] initWithGenome:childGenome];
    return childOrganism;
}

-(NSComparisonResult) compareFitnessWith: (Organism*) anotherOrganism {
    if (self.fitness < anotherOrganism.fitness) {
        return NSOrderedDescending;
    }
    if (self.fitness == anotherOrganism.fitness) {
        return NSOrderedSame;
    }
    return NSOrderedAscending;
}

-(Organism*) copyWithZone: (NSZone*) zone {
    Organism* copiedOrganism = [[Organism alloc] init];
    copiedOrganism.genome = [genome copy];
    copiedOrganism.fitness = fitness;
    return copiedOrganism;
}

@end
