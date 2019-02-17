//
//  Network.h
//  MsPacman-Neat
//
//  Created by Murphy Crosby on 1/2/19.
//  Copyright © 2019 Murphy Crosby. All rights reserved.
//

#ifndef Network_h
#define Network_h

#import <Foundation/Foundation.h>
@class Genome;

@interface Network : NSObject {
}

@property (strong) Genome* genome;
@property int numNodes;
@property int numLinks;
@property (strong) NSMutableArray* allLinks;
@property (strong) NSMutableArray* allNodes;
@property (strong) NSMutableArray* inputNodes;
@property (strong) NSMutableArray* outputNodes;

-(id) initWithGenome:(Genome*) genotype;
-(void) updateSensors: (NSArray*) inputValuesArray;
-(NSArray*) activateNetwork;
-(void) flushNetwork;

+(void) fscalePhenoNode: (NSArray*) nodes min:(int) min max:(int) max;
+(NSArray*) fsoftmax:(NSArray*) nodes;

@end

#endif /* Network_h */
