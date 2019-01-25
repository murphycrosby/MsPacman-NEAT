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
@synthesize nodeID, nodeType, incomingPhenoLinks, outgoingPhenoLinks, activationValue, activated;

- (id)init
{
    self = [super init];
    if (self) {
        incomingPhenoLinks = [[NSMutableArray alloc] init];
        outgoingPhenoLinks = [[NSMutableArray alloc] init];
        activated = FALSE;
    }
    return self;
}

-(NSString*) description {
    
    NSString* nodePositionString = [GenomeNode NodeTypeString:nodeType];
    
    return [NSString stringWithFormat:@"%@ Node %i with %lu incoming links and %lu outgoing links",
            nodePositionString, nodeID,
            (unsigned long)[incomingPhenoLinks count], (unsigned long)[outgoingPhenoLinks count]];
}

-(void) describe {
    NSString* nt = [GenomeNode NodeTypeString:nodeType];
    
    NSLog(@"Id: %d - %@ (%1.3f)", nodeID, nt, activationValue);
    for(PhenoLink* ph in incomingPhenoLinks) {
        NSLog(@"Node: %d ()", ph.fromNode.nodeID);
    }
}

-(void) activate {
    double activeSum = 0.0;
    
    if(activated) {
        return;
    }
    
    for (PhenoLink* nextIncomingLink in incomingPhenoLinks) {
        if (nextIncomingLink.isEnabled) {
            activeSum += (nextIncomingLink.fromNode.activationValue * nextIncomingLink.weight);
            /*
            NSLog(@"F(%i) [%1.3f] --[%1.3f]--> T(%i) [%1.3f] == +%1.3f = %1.3f",
                  nextIncomingLink.fromNode.nodeID,
                  nextIncomingLink.fromNode.activationValue,
                  nextIncomingLink.weight,
                  nextIncomingLink.toNode.nodeID,
                  nextIncomingLink.toNode.activationValue,
                  (nextIncomingLink.fromNode.activationValue * nextIncomingLink.weight),
                  activeSum);
            */
        }
    }
    //NSLog(@"activationValue B: %1.3f :  %1.3f", activationValue, activeSum);
    activationValue += [PhenomeNode fsigmoid: activeSum slope:0 constant:0];
    //NSLog(@"activationValue A: %1.3f", activationValue);
    //activationValue += activeSum;
    activated = TRUE;
    
    for(PhenoLink* outgoingLink in outgoingPhenoLinks) {
        if(outgoingLink.isEnabled) {
            [outgoingLink.toNode activate];
        }
    }
    
    //lastActivationValue = activationValue;
    //NSLog(@"Before Sigmoid = %1.3f",activeSum);
    //activationValue = [PhenomeNode fsigmoid: activeSum slope:4.924273 constant:2.4621365];
    //NSLog(@"After Sigmoid = %1.3f",activationValue);
    
    // I suspect a more forgiving test will be required here in the future
    //hasChangedSinceLastTraversal = (activationValue == lastActivationValue) ? false : true;
}

+(double) fsigmoid:(double) activesum slope:(double) slope constant:(double) constant {
    //RIGHT SHIFTED ---------------------------------------------------------
    //return (1/(1+(exp(-(slope*activesum-constant))))); //ave 3213 clean on 40 runs of p2m and 3468 on another 40
    //41394 with 1 failure on 8 runs
    
    //LEFT SHIFTED ----------------------------------------------------------
    //return (1/(1+(exp(-(slope*activesum+constant))))); //original setting ave 3423 on 40 runs of p2m, 3729 and 1 failure also
    
    //PLAIN SIGMOID ---------------------------------------------------------
    return (1/(1+(exp(-activesum)))); //3511 and 1 failure
    
    //LEFT SHIFTED NON-STEEPENED---------------------------------------------
    //return (1/(1+(exp(-activesum-constant)))); //simple left shifted
    
    //NON-SHIFTED STEEPENED
    //return (1/(1+(exp(-(slope*activesum))))); //Compressed
}

-(void) clearLinks {
    incomingPhenoLinks = nil;
    outgoingPhenoLinks = nil;
}

@end
