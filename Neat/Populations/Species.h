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
    NSMutableArray * speciesOrganisms;
    Organism * fittestOrganism;
    //double speciesFitnessTotal;
    int age;
    int ageSinceImprovement;
}

@property (retain) NSMutableArray * speciesOrganisms;
@property (retain) Organism * fittestOrganism;
@property int age;
@property int ageSinceImprovement;

/*
-(bool) shouldIncludeOrganism:(Organism *) org;
-(void) addOrganism: (Organism *) org;
-(Organism *) fittestOrganism;
-(void) clearAndAge;
-(double) numberToSpawnBasedOnAverageFitness: (double) averageFitness;
-(NSArray *) spawnOrganisms: (int) numToSpawn;
*/

@end

#endif /* Species_h */
