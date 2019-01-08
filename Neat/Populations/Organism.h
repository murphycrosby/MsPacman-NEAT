//
//  Organism.h
//  MsPacman-Neat
//
//  Created by Murphy Crosby on 1/2/19.
//  Copyright © 2019 Murphy Crosby. All rights reserved.
//

#ifndef Organism_h
#define Organism_h

#import <Foundation/Foundation.h>
@class Genome;
@class Network;

@interface Organism : NSObject {
    Genome* genome;
    Network* network;
    
    double fitness;
    double speciesAdjustedFitness;
}

@property (retain) Genome * genome;
@property double fitness;
@property double speciesAdjustedFitness;

-(Network *) network;
-(id)initWithGenome: (Genome *) dna;
-(void) developNetwork;
-(void) processInput: (NSArray *) inputValuesArray;
-(void) destroyNetwork;
/*
-(Organism *) reproduceChildOrganism;
-(Organism *) reproduceChildOrganismWithOrganism: (Organism *) lessFitMate;
-(NSComparisonResult) compareFitnessWith: (Organism *) anotherOrganism;
*/

@end

#endif /* Organism_h */
