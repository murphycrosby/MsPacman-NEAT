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
        hiddenState = 0.0;
        cellState = 0.0;
    }
    return self;
}

-(NSString*) description {
    
    NSString* nodeTypeString = [GenomeNode NodeTypeString:nodeType];
    
    return [NSString stringWithFormat:@"%@ Node %i with %lu incoming links and %lu outgoing links",
            nodeTypeString, nodeID,
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
        if(nextIncomingLink.fromNode.activated == false) {
            return;
        }
        
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
    
    if (nodeType == OUTPUT) {
        //We SOFTMAX the last layer
        activationValue += activeSum;
    } else {
        //NSLog(@"activationValue B: %1.3f :  %1.3f", activationValue, activeSum);
        activationValue += [PhenomeNode fsigmoid: activeSum];
        //NSLog(@"activationValue A: %1.3f", activationValue);
    }
    
    activated = TRUE;
    
    for(PhenoLink* outgoingLink in outgoingPhenoLinks) {
        if(outgoingLink.isEnabled) {
            [outgoingLink.toNode activate];
        }
    }
}

-(void) activateLSTM {
    double activeSum = 0.0;
    
    if(activated) {
        return;
    }
    
    if(nodeType != INPUT && nodeType != BIAS) {
        for (PhenoLink* nextIncomingLink in incomingPhenoLinks) {
            if(nextIncomingLink.fromNode.activated == false) {
                return;
            }
            
            if (nextIncomingLink.isEnabled) {
                activeSum += (nextIncomingLink.fromNode.activationValue * nextIncomingLink.weight);
            }
        }
        
        double ft = [PhenomeNode fsigmoid:(hiddenState + activeSum)];
        double it = ft;
        double ot = ft;
        double candidate = tanh(hiddenState + activeSum);
        cellState = (ft * cellState) + (candidate * it);
        hiddenState = ot * tanh(cellState);
        
        activationValue = hiddenState;
    }
    
    activated = TRUE;
    
    for(PhenoLink* outgoingLink in outgoingPhenoLinks) {
        if(outgoingLink.isEnabled) {
            [outgoingLink.toNode activateLSTM];
        }
    }
}

+(double) fsigmoid:(double) activesum {
    return (1/(1+(exp(-activesum))));
}

-(void) clearLinks {
    incomingPhenoLinks = nil;
    outgoingPhenoLinks = nil;
}

-(void) dealloc {
    incomingPhenoLinks = nil;
    outgoingPhenoLinks = nil;

}

@end
