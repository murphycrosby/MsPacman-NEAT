//
//  Network.m
//  MsPacman-Neat
//
//  Created by Murphy Crosby on 1/2/19.
//  Copyright © 2019 Murphy Crosby. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Network.h"
#import "Genome.h"
#import "GenomeNode.h"
#import "GenomeLink.h"
#import "PhenomeNode.h"
#import "PhenomeLink.h"
//#import "ParameterController.h"

@implementation Network
@synthesize genome, numLinks, numNodes, allNodes, inputNodes, outputNodes;

-(NSString *) description {
    return [NSString stringWithFormat: @"Nodes: %@ Links: %@",
            [allNodes description],
            [allLinks description]];
}

- (id)initWithGenome:(Genome *) genotype
{
    self = [super init];
    if (self) {
        genome = genotype;
        
        allNodes = [[NSMutableArray alloc] init];
        inputNodes = [[NSMutableArray alloc] init];
        outputNodes = [[NSMutableArray alloc] init];
        allLinks = [[NSMutableArray alloc] init];
        
        numNodes = 0;
        
        // set up phenonodes
        for (GenomeNode * nextGenoNode in genome.genoNodes) {
            PhenomeNode * newPhenoNode = [[PhenomeNode alloc] init];
            newPhenoNode.nodeID = nextGenoNode.nodeID;
            newPhenoNode.nodeType = nextGenoNode.nodeType;
            
            [allNodes addObject:newPhenoNode];
    
            if (nextGenoNode.nodeType == INPUT) {
                [inputNodes addObject:newPhenoNode];
            }
            if (nextGenoNode.nodeType == OUTPUT) {
                [outputNodes addObject:newPhenoNode];
            }
            numNodes++;
        }
        
        // set up phenolinks
        for (GenomeLink * nextGenoLink in genome.genoLinks) {
            if (nextGenoLink.isEnabled) {
                ONPhenoLink * newPhenoLink = [[ONPhenoLink alloc] init];
                
                PhenomeNode * fNode = [self getNodeWithID:nextGenoLink.fromNode];
                if (fNode == nil) {
                    NSLog(@"Warning - In building Phenotype: PhenoNode %d referred to by a genoLink cannot be found",
                          nextGenoLink.fromNode);
                }
                newPhenoLink.fromNode = fNode;
                [newPhenoLink.fromNode.outgoingPhenoLinks addObject:newPhenoLink];
                
                PhenomeNode * tNode = [self getNodeWithID:nextGenoLink.toNode];
                if (tNode == nil) {
                    NSLog(@"Warning - In building Phenotype: PhenoNode %d referred to by a genoLink cannot be found",
                          nextGenoLink.toNode);
                }
                newPhenoLink.toNode = tNode;
                [newPhenoLink.toNode.incomingPhenoLinks addObject:newPhenoLink];
                
                newPhenoLink.weight = nextGenoLink.weight;
                newPhenoLink.isEnabled = nextGenoLink.isEnabled;
                
                [allLinks addObject:newPhenoLink];
                
                numLinks++;
            }
        }
    }
    return self;
}

-(PhenomeNode *) getNodeWithID: (int) nID {
    for (PhenomeNode * nextPhenoNode in allNodes) {
        if (nextPhenoNode.nodeID == nID) {
            return nextPhenoNode;
        }
    }
    return nil;
}
/*
-(void) updateSensors: (NSArray *) inputValuesArray {
    for (int i = 0; i < [inputNodes count]; i++) {
        PhenomeNode * nextInputNode = [inputNodes objectAtIndex:i];
        NSNumber * nextInputValue = [inputValuesArray objectAtIndex:i];
        if (nextInputValue != nil) {
            nextInputNode.activationValue = [nextInputValue doubleValue];
        }
        else {
            nextInputNode.activationValue = 0.0;
            NSLog(@"Runtime Warning - not enough input parameters to sensors: filling sensor %d with vaue 0.0", i);
        }
    }
    if ([inputValuesArray count] > [inputNodes count]) {
        NSLog(@"Runtime Warning - there are %lu input values but only %lu input sensors in the network: ignoring the extra ones",
              [inputValuesArray count], [inputNodes count]);
    }
    for (PhenomeNode * nextPhenoNode in allNodes) {
        if (nextPhenoNode.nodeType == BIAS) {
            nextPhenoNode.activationValue = 1.0;
        }
    }
}

-(void) activateNetwork {
    
    bool stabilised = false;
    int remainingLoops = [ONParameterController maxNeuralNetworkLoops];
    
    while (!stabilised && remainingLoops > 0) {
        stabilised = true;
        // run forward through each node
        for (PhenomeNode * nextPhenoNode in allNodes) {
            if (nextPhenoNode.nodeType == HIDDEN ||
                nextPhenoNode.nodeType == OUTPUT) {
                [nextPhenoNode activate];
                if (nextPhenoNode.hasChangedSinceLastTraversal) {
                    stabilised = false;
                }
            }
        }
        remainingLoops--;
        
    }
    
}

-(void) flushNetwork {
    for (PhenomeNode * nextPhenoNode in allNodes) {
        nextPhenoNode.activationValue = 0;
        nextPhenoNode.lastActivationValue = 0;
    }
}
*/

@end
