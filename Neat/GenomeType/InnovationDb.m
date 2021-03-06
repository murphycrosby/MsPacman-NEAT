//
//  InnovationDb.m
//  MsPacman-Neat
//
//  Created by Murphy Crosby on 1/2/19.
//  Copyright © 2019 Murphy Crosby. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InnovationDb.h"
#import "Innovation.h"
#import "GenomeNode.h"
#import "GenomeLink.h"

@implementation InnovationDb

static int nodeCounter = 0;
static int innovationCounter = 0;
static InnovationDb* sharedInnovationDb;

- (id)init
{
    self = [super init];
    if (self) {
        linkInnovations = [[NSMutableArray alloc] init];
        nodeRecord = [[NSMutableArray alloc] init];
    }
    return self;
}

-(BOOL) nodeExists: (int) nodeID {
    for (Innovation* nextNode in nodeRecord) {
        if ([nextNode.nodeOrLink getInnovationID] == nodeID) {
            return TRUE;
        }
    }
    return FALSE;
}

-(GenomeNode*) getNodeWithID: (int) nodeID {
    for (Innovation* nextNode in nodeRecord) {
        if ([nextNode.nodeOrLink getInnovationID] == nodeID) {
            return [nextNode.nodeOrLink copy];
        }
    }
    return nil;
}

-(GenomeNode*) possibleNodeExistsFromNode: (int) fNode toNode: (int) tNode {
    for (Innovation* nextInnovation in nodeRecord) {
        if (nextInnovation.fromNodeID == fNode &&
            nextInnovation.toNodeID == tNode) {
            return [nextInnovation.nodeOrLink copy];
        }
    }
    return nil;
}

-(void) insertNewNode:(GenomeNode*) newNode fromNode:(int) fNode toNode: (int) tNode {
    Innovation* newInnovation = [[Innovation alloc] init];
    newInnovation.nodeOrLink = [newNode copy];
    newInnovation.fromNodeID = fNode;
    newInnovation.toNodeID = tNode;
    [nodeRecord addObject:newInnovation];
}

-(BOOL) linkExists: (int) fNode toNode:(int) tNode {
    for (Innovation* nextInnovation in linkInnovations) {
        if (nextInnovation.fromNodeID == fNode &&
            nextInnovation.toNodeID == tNode) {
            return TRUE;
        }
    }
    return FALSE;
}

-(GenomeLink*) possibleLinkExistsFromNode: (int) fNode toNode: (int) tNode {
    for (Innovation* nextInnovation in linkInnovations) {
        if (nextInnovation.fromNodeID == fNode &&
            nextInnovation.toNodeID == tNode) {
            return [nextInnovation.nodeOrLink copy];
        }
    }
    return nil;
}

-(void) insertNewLink:(GenomeLink*) newLink fromNode:(int) fNode toNode: (int) tNode {
    Innovation* newInnovation = [[Innovation alloc] init];
    newInnovation.nodeOrLink = [newLink copy];
    newInnovation.fromNodeID = fNode;
    newInnovation.toNodeID = tNode;
    [linkInnovations addObject:newInnovation];
}

-(NSString*) description {
    return [NSString stringWithFormat:@"%@%@", [nodeRecord description], [linkInnovations description]];
}

+(int) getGenomeNodeID {
    return nodeCounter;
}

+(int) getNextGenomeNodeID {
    return nodeCounter++;
}

+(void) setNextGenomeNodeID:(int) num {
    if (num > nodeCounter) {
        nodeCounter = num;
    }
}

+(int) getInnovationID {
    return innovationCounter;
}

+(int) getNextInnovationID {
    return innovationCounter++;
}

+(void) setNextInnovationID:(int) num {
    if (num > innovationCounter) {
        innovationCounter = num;
    }
}

+(InnovationDb*) sharedDb {
    if (sharedInnovationDb == nil) {
        sharedInnovationDb = [[InnovationDb alloc] init];
    }
    return sharedInnovationDb;
}

@end
