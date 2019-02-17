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
    
}

@property (strong) Network* network;
@property (strong) Genome* genome;
@property double fitness;
@property double speciesAdjustedFitness;

-(id)initWithGenome: (Genome*) dna;
-(void) developNetwork;
-(NSArray*) predict: (NSArray*) inputValuesArray;
+(void) saveToHtml: (Organism*) organism directory: (NSString*) directory organismId: (NSString*) organismId;
+(void) saveToFile: (Organism*) organism filename: (NSString*) filename;
+(Organism*) loadFromFile: (NSString*) filename;
-(void) destroyNetwork;
-(Organism*) reproduceChildOrganism;
-(Organism*) reproduceChildOrganismWithOrganism: (Organism*) lessFitMate;
-(NSComparisonResult) compareFitnessWith: (Organism*) anotherOrganism;
-(BOOL) isEqual:(Organism*) organism;

@end

#endif /* Organism_h */
