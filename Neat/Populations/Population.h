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

@interface Population : NSObject {
    NSMutableArray * allOrganisms;
    NSMutableArray * allSpecies;
    Organism * fittestOrganismEver;
    int generation;
}

@property (strong, nonatomic) NSMutableArray * allOrganisms;
@property (strong, nonatomic) NSMutableArray * allSpecies;
@property int generation;

//-(void) rePopulateFromFittest;
+(Population *) spawnInitialGenerationFromGenome: (int) nOrganisms genome:(Genome *) genesisGenome;

@end

#endif /* Population_h */
