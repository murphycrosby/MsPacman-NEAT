//
//  Genome.h
//  MsPacman-Neat
//
//  Created by Murphy Crosby on 1/2/19.
//  Copyright © 2019 Murphy Crosby. All rights reserved.
//

#ifndef Genome_h
#define Genome_h

#import <Foundation/Foundation.h>

@interface Genome : NSObject<NSCopying, NSSecureCoding> {
}

@property int genomeID;
@property (strong) NSMutableArray* genoNodes;
@property (strong) NSMutableArray* genoLinks;

+(Genome*) createGenome: (int) nInputs outputs: (int) nOutputs;
+(void) balanceGenome:(Genome*) genome;
+(NSString*) saveGenomeToSvg:(Genome*) genome;
-(Genome*) randomiseWeights;
-(void) perturbSingleLinkWeight;
-(void) perturbAllLinkWeights;
-(void) reEnableRandomLink;
-(void) toggleRandomLink;
-(void) addNode;
-(void) addStarterLink;
-(void) addLink;
-(Genome*) mutateGenome;
-(Genome*) offspringWithGenome: (Genome*) mumGenome;
-(void) verifyGenome;
-(double) similarityScoreWithGenome: (Genome*) otherGenome;
-(BOOL) isEqual:(Genome*) genome;
+(double) gaussrand;

@end

#endif /* Genome_h */
