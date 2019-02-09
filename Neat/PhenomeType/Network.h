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
    //Genome* genome;
    //int numNodes;
    //int numLinks;
    
    //NSMutableArray* allNodes;
    //NSMutableArray* inputNodes;
    //NSMutableArray* outputNodes;
    NSMutableArray* allLinks;
}

@property (retain) Genome* genome;
@property int numNodes;
@property int numLinks;
@property (retain) NSMutableArray* allNodes;
@property (retain) NSMutableArray* inputNodes;
@property (retain) NSMutableArray* outputNodes;

-(id) initWithGenome:(Genome*) genotype;
-(void) updateSensors: (NSArray*) inputValuesArray;
-(NSArray*) activateNetwork;
-(void) flushNetwork;

+(void) fscalePhenoNode: (NSArray*) nodes min:(int) min max:(int) max;
+(NSArray*) fscale: (NSArray*) nodes min:(int) min max:(int) max;
+(NSArray*) fsoftmax:(NSArray*) nodes;

@end

#endif /* Network_h */
