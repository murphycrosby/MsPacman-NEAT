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

@interface Organism : NSObject <NSCopying, NSSecureCoding> {
    //Genome* genome;
    //Network* network;
    
    //double fitness;
    //double speciesAdjustedFitness;
}

@property (retain) Network* network;
@property (retain) Genome* genome;
@property int generation;
@property double fitness;
@property double speciesAdjustedFitness;

//-(Network*) network;
-(id)initWithGenome: (Genome*) dna;
-(void) developNetwork;
-(NSArray*) predict: (NSArray*) inputValuesArray;
+(void) printToFile: (Organism*) organism filename: (NSString*) filename;
+(void) saveToFile: (Organism*) organism filename: (NSString*) filename;
+(Organism*) loadFromFile: (NSString*) filename;
-(void) destroyNetwork;
-(Organism*) reproduceChildOrganism;
-(Organism*) reproduceChildOrganismWithOrganism: (Organism*) lessFitMate;
-(NSComparisonResult) compareFitnessWith: (Organism*) anotherOrganism;
-(BOOL) isEqual:(Organism*) organism;

@end

#endif /* Organism_h */
