//
//  PhenomeNode.m
//  MsPacman-Neat
//
//  Created by Murphy Crosby on 1/2/19.
//  Copyright © 2019 Murphy Crosby. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhenomeNode.h"
#import "PhenomeLink.h"

@implementation PhenomeNode
@synthesize nodeID, nodeType, incomingPhenoLinks, outgoingPhenoLinks, activationValue, lastActivationValue, hasChangedSinceLastTraversal;

- (id)init
{
    self = [super init];
    if (self) {
        incomingPhenoLinks = [[NSMutableArray alloc] init];
        outgoingPhenoLinks = [[NSMutableArray alloc] init];
    }
    return self;
}

-(NSString *) description {
    
    NSString * nodePositionString;
    switch (nodeType) {
        case HIDDEN:
            nodePositionString = @"Hidden";
            break;
        case INPUT:
            nodePositionString = @"Input";
            break;
        case OUTPUT:
            nodePositionString = @"Output";
            break;
        case BIAS:
            nodePositionString = @"Bias";
            break;
        default:
            nodePositionString = @"Unknown"; // error
            break;
    }
    
    return [NSString stringWithFormat:@"%@ Node %i with %lu incoming links and %lu outgoing links",
            nodePositionString, nodeID,
            (unsigned long)[incomingPhenoLinks count], (unsigned long)[outgoingPhenoLinks count]];
}

-(void) activate {
    double activeSum = 0.0;
    for (ONPhenoLink * nextIncomingLink in incomingPhenoLinks) {
        if (nextIncomingLink.isEnabled) {
            activeSum += (nextIncomingLink.fromNode.activationValue * nextIncomingLink.weight);
            //NSLog(@"+%1.3f = %1.3f",(nextIncomingLink.fromNode.activationValue * nextIncomingLink.weight), activeSum);
        }
    }
    lastActivationValue = activationValue;
    activationValue = [PhenomeNode fsigmoid: activeSum slope:4.924273 constant:2.4621365];
    
    // I suspect a more forgiving test will be required here in the future
    hasChangedSinceLastTraversal = (activationValue == lastActivationValue) ? false : true;
}

+(double) fsigmoid:(double) activesum slope:(double) slope constant:(double) constant {
    //RIGHT SHIFTED ---------------------------------------------------------
    //return (1/(1+(exp(-(slope*activesum-constant))))); //ave 3213 clean on 40 runs of p2m and 3468 on another 40
    //41394 with 1 failure on 8 runs
    
    //LEFT SHIFTED ----------------------------------------------------------
    //return (1/(1+(exp(-(slope*activesum+constant))))); //original setting ave 3423 on 40 runs of p2m, 3729 and 1 failure also
    
    //PLAIN SIGMOID ---------------------------------------------------------
    //return (1/(1+(exp(-activesum)))); //3511 and 1 failure
    
    //LEFT SHIFTED NON-STEEPENED---------------------------------------------
    //return (1/(1+(exp(-activesum-constant)))); //simple left shifted
    
    //NON-SHIFTED STEEPENED
    return (1/(1+(exp(-(slope*activesum))))); //Compressed
}

-(void) clearLinks {
    incomingPhenoLinks = nil;
    outgoingPhenoLinks = nil;
}

@end
