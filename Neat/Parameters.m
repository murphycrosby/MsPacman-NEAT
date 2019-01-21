//
//  Parameters.m
//  MsPacman-Neat
//
//  Created by Murphy Crosby on 1/20/19.
//  Copyright © 2019 Murphy Crosby. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Parameters.h"

@implementation Parameters

static int populationSize = 15;
static int numGenerations = 3;
static double mutationProbabilityReplaceWeight = 0.2;
static double mutationMaximumPerturbation = 0.05;
static double chanceMutateWeight = 0.5;
static double chanceToggleLinks = 0.2;
static double changeReenableLinks = 0.2;;
static double c1ExcessCoefficient = 1;
static double c2DisjointCoefficient = 1;
static double c3weightCoefficient = 0.4;
static double speciesCompatibilityThreshold = 0.7;
static int speciesAgeSinceImprovementLimit = 15;
static double speciesPercentOrganismsSurvive = 0.2;
static int maximumNeurons = 5000;
static double chanceAddLink = 0.05;
static double chanceAddNode = 0.04;
static double mutateWeightOnlyDontCrossover = 0.3;
static int youngSpeciesAgeThreshold = 5;
static double youngSpeciesFitnessBonus = 3;
static int oldSpeciesAgeThreshold = 15;
static double oldSpeciesFitnessBonus = 0.5;
static int randomSeed = 0;

+(int) populationSize {
    return populationSize;
}

+(int) numGenerations {
    return numGenerations;
}

+(double) mutationProbabilityReplaceWeight {
    return mutationProbabilityReplaceWeight;
}

+(double) mutationMaximumPerturbation {
    return mutationMaximumPerturbation;
}

+(double) chanceMutateWeight {
    return chanceMutateWeight;
}

+(double) chanceToggleLinks {
    return chanceToggleLinks;
}

+(double) changeReenableLinks {
    return changeReenableLinks;
}

+(double) c1ExcessCoefficient {
    return c1ExcessCoefficient;
}

+(double) c2DisjointCoefficient {
    return c2DisjointCoefficient;
}

+(double) c3weightCoefficient {
    return c3weightCoefficient;
}

+(double) speciesCompatibilityThreshold {
    return speciesCompatibilityThreshold;
}

+(int) speciesAgeSinceImprovementLimit {
    return speciesAgeSinceImprovementLimit;
}

+(double) speciesPercentOrganismsSurvive {
    return speciesPercentOrganismsSurvive;
}

+(int) maximumNeurons {
    return maximumNeurons;
}

+(double) chanceAddLink {
    return chanceAddLink;
}

+(double) chanceAddNode {
    return chanceAddNode;
}

+(double) mutateWeightOnlyDontCrossover {
    return mutateWeightOnlyDontCrossover;
}

+(int) youngSpeciesAgeThreshold {
    return youngSpeciesAgeThreshold;
}

+(double) youngSpeciesFitnessBonus {
    return youngSpeciesFitnessBonus;
}

+(int) oldSpeciesAgeThreshold {
    return oldSpeciesAgeThreshold;
}

+(double) oldSpeciesFitnessBonus {
    return oldSpeciesFitnessBonus;
}
+(int) randomSeed {
    return randomSeed;
}

@end
