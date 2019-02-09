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

-(NSString*) description {
    return [NSString stringWithFormat: @"Nodes: %@ Links: %@",
            [allNodes description],
            [allLinks description]];
}

- (id)initWithGenome:(Genome*) genotype
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
        for (GenomeNode* nextGenoNode in genome.genoNodes) {
            PhenomeNode* newPhenoNode = [[PhenomeNode alloc] init];
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
        for (GenomeLink* nextGenoLink in genome.genoLinks) {
            if (nextGenoLink.isEnabled) {
                PhenoLink* newPhenoLink = [[PhenoLink alloc] init];
                
                PhenomeNode* fNode = [self getNodeWithID:nextGenoLink.fromNode];
                if (fNode == nil) {
                    NSLog(@"Warning - In building Phenotype: PhenoNode %d referred to by a genoLink cannot be found",
                          nextGenoLink.fromNode);
                }
                newPhenoLink.fromNode = fNode;
                [newPhenoLink.fromNode.outgoingPhenoLinks addObject:newPhenoLink];
                
                PhenomeNode* tNode = [self getNodeWithID:nextGenoLink.toNode];
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

-(PhenomeNode*) getNodeWithID: (int) nID {
    for (PhenomeNode* nextPhenoNode in allNodes) {
        if (nextPhenoNode.nodeID == nID) {
            return nextPhenoNode;
        }
    }
    return nil;
}

-(void) updateSensors: (NSArray*) inputValuesArray {
    NSArray* scaledValuesArray = [Network fscale:inputValuesArray min:-3 max:3];
    
    for (int i = 0; i < [inputNodes count]; i++) {
        PhenomeNode* nextInputNode = [inputNodes objectAtIndex:i];
        //NSNumber* nextInputValue = [inputValuesArray objectAtIndex:i];
        NSNumber* nextInputValue = [scaledValuesArray objectAtIndex:i];
        if (nextInputValue != nil) {
            nextInputNode.activationValue = [nextInputValue doubleValue];
            nextInputNode.activated = TRUE;
        }
        else {
            nextInputNode.activationValue = 0.0;
            NSLog(@"Runtime Warning - not enough input parameters to sensors: filling sensor %d with vaue 0.0", i);
        }
    }
    //if ([inputValuesArray count] > [inputNodes count]) {
    if ([scaledValuesArray count] > [inputNodes count]) {
        NSLog(@"Runtime Warning - there are %lu input values but only %lu input sensors in the network: ignoring the extra ones",
              [scaledValuesArray count], [inputNodes count]);
              //[inputValuesArray count], [inputNodes count]);
    }
    for (PhenomeNode* nextPhenoNode in allNodes) {
        if (nextPhenoNode.nodeType == BIAS) {
            nextPhenoNode.activationValue = 1.0;
            nextPhenoNode.activated = TRUE;
        }
    }
}

-(NSArray*) activateNetwork {
    for (PhenomeNode* nextPhenoNode in allNodes) {
        //if (nextPhenoNode.nodeType == INPUT || nextPhenoNode.nodeType == BIAS) {
        if (nextPhenoNode.nodeType != INPUT && nextPhenoNode.nodeType != BIAS) {
            //We need to process in order starting from the input layer
            //[nextPhenoNode activate];
            [nextPhenoNode activateLSTM];
        }
    }
    /*
    NSMutableArray* debugArray = [[NSMutableArray alloc] init];
    for (PhenomeNode* nextPhenoNode in allNodes) {
        if(nextPhenoNode.nodeType == OUTPUT) {
            [debugArray addObject:@(nextPhenoNode.activationValue)];
        }
    }
    NSLog(@"[%1.3f] [%1.3f] [%1.3f] [%1.3f]", [debugArray[0] doubleValue], [debugArray[1] doubleValue], [debugArray[2] doubleValue], [debugArray[3] doubleValue]);
    */
    [Network fscalePhenoNode:allNodes min:-50 max:50];
    return [Network fsoftmax: allNodes];
}

-(void) flushNetwork {
    for (PhenomeNode* nextPhenoNode in allNodes) {
        nextPhenoNode.activationValue = 0;
        nextPhenoNode.activated = FALSE;
    }
}

+(NSArray*) fscale: (NSArray*) nodes min:(int) min max:(int) max {
    NSMutableArray* arr = [[NSMutableArray alloc] init];
    double vmin = 0;
    double vmax = 0;
    BOOL doScale = FALSE;
    
    for (int i = 0; i < nodes.count; i++) {
        double val = [[nodes objectAtIndex:i] doubleValue];
        if(val > max
           || val < min) {
            doScale = TRUE;
        }
        
        if(val < vmin) {
            vmin = val;
        }
        
        if(val > vmax) {
            vmax = val;
        }
    }
    
    if(!doScale) {
        return nodes;
    }
    
    double mult = ((max - min) / (vmax - vmin));
    for (int i = 0; i < nodes.count; i++) {
        double v = [[nodes objectAtIndex:i] doubleValue];
        double val = (mult * (v - vmax)) + max;
        [arr addObject:@(val)];
    }
    
    return arr;
}

+(void) fscalePhenoNode: (NSArray*) nodes min:(int) min max:(int) max {
    double vmin = 0;
    double vmax = 0;
    BOOL doScale = FALSE;
    
    for (PhenomeNode* nextPhenoNode in nodes) {
        if(nextPhenoNode.nodeType != OUTPUT) {
            continue;
        }
        
        if(nextPhenoNode.activationValue > max
           || nextPhenoNode.activationValue < min) {
            doScale = TRUE;
        }
        
        if(nextPhenoNode.activationValue < vmin) {
            vmin = nextPhenoNode.activationValue;
        }
        
        if(nextPhenoNode.activationValue > vmax) {
            vmax = nextPhenoNode.activationValue;
        }
    }
    
    if(!doScale) {
        return;
    }
    
    double mult = ((max - min) / (vmax - vmin));
    for (PhenomeNode* nextPhenoNode in nodes) {
        double val = (mult * (nextPhenoNode.activationValue - vmax)) + max;
        nextPhenoNode.activationValue = val;
    }
}


+(NSArray*) fsoftmax: (NSArray*) nodes {
    NSMutableArray* outputArray = [[NSMutableArray alloc] init];
    double sum = 0.0;
    for (PhenomeNode* nextPhenoNode in nodes) {
        if(nextPhenoNode.nodeType == OUTPUT) {
            double ex = exp(nextPhenoNode.activationValue);
            sum += ex;
        }
    }
    
    for (PhenomeNode* nextPhenoNode in nodes) {
        if(nextPhenoNode.nodeType == OUTPUT) {
            double val = exp(nextPhenoNode.activationValue) / sum;
            nextPhenoNode.activationValue = val;
            [outputArray addObject:@(val)];
        }
    }
    
    return outputArray;
}

@end
