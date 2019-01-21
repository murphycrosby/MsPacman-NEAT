//
//  Species.h
//  MsPacman-Neat
//
//  Created by Murphy Crosby on 1/2/19.
//  Copyright © 2019 Murphy Crosby. All rights reserved.
//

#ifndef Species_h
#define Species_h

#import <Foundation/Foundation.h>
@class Organism;

@interface Species : NSObject {
    int speciesID;
    //NSMutableArray* speciesOrganisms;
    //Organism* fittestOrganism;
    //double speciesFitnessTotal;
    //int age;
    //int ageSinceImprovement;
}

@property (retain) NSMutableArray* speciesOrganisms;
@property (retain) Organism* fittestOrganism;
@property int age;
@property int ageSinceImprovement;

-(void) clearAndAge;
-(bool) shouldIncludeOrganism:(Organism*) org;
-(void) addOrganism: (Organism*) org;
-(NSArray*) spawnOrganisms: (int) numToSpawn;
-(double) numberToSpawnBasedOnAverageFitness: (double) averageFitness;
-(NSComparisonResult) compareBestFitnessWith: (Species*) anotherSpecies;
/*
-(Organism*) fittestOrganism;
*/

@end

#endif /* Species_h */
