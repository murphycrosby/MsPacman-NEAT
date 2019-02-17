//
//  Population.h
//  MsPacman-Neat
//
//  Created by Murphy Crosby on 1/2/19.
//  Copyright © 2019 Murphy Crosby. All rights reserved.
//

#ifndef Population_h
#define Population_h

#import <Foundation/Foundation.h>
@class Organism;
@class Genome;

@interface Population : NSObject <NSSecureCoding> {
}

@property (strong, nonatomic) NSMutableArray* allOrganisms;
@property (strong, nonatomic) NSMutableArray* allSpecies;
@property (strong, nonatomic) Organism* fittestOrganismEver;
@property int generation;

-(void) evolvePopulation;
-(Organism*) bestFitness;
+(void) saveToHtml: (Population*) population directory: (NSString*) directory populationId: (NSString*) populationId;
+(void) saveToFile: (Population*) population filename: (NSString*) filename;
+(Population*) loadFromFile: (NSString*) filename;
+(Population*) spawnInitialGenerationFromGenome: (Genome*) genesisGenome;

@end

#endif /* Population_h */
