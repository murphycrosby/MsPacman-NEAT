//
//  Parameter.h
//  MsPacman-Neat
//
//  Created by Murphy Crosby on 1/20/19.
//  Copyright © 2019 Murphy Crosby. All rights reserved.
//

#ifndef Parameter_h
#define Parameter_h

@interface Parameters : NSObject

+(int) populationSize;
+(int) numGenerations;
+(double) mutationProbabilityUpdateWeight;
+(double) mutationProbabilityReplaceWeight;
+(double) mutationMaximumPerturbation;
+(double) chanceMutateWeight;
+(double) chanceToggleLinks;
+(double) changeReenableLinks;
+(double) c1ExcessCoefficient;
+(double) c2DisjointCoefficient;
+(double) c3weightCoefficient;
+(double) speciesCompatibilityThreshold;
+(int) speciesAgeSinceImprovementLimit;
+(double) speciesPercentOrganismsSurvive;
+(int) maximumNeurons;
+(double) chanceAddLink;
+(double) chanceAddNode;
+(double) mutateWeightOnlyDontCrossover;
+(double) chanceMutate;
+(int) youngSpeciesAgeThreshold;
+(double) youngSpeciesFitnessBonus;
+(int) oldSpeciesAgeThreshold;
+(double) oldSpeciesFitnessBonus;
+(int) randomSeed;

@end


#endif /* Parameter_h */
