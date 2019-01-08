//
//  GenomeNode.m
//  MsPacman-Neat
//
//  Created by Murphy Crosby on 1/2/19.
//  Copyright © 2019 Murphy Crosby. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GenomeNode.h"

@implementation GenomeNode

@synthesize nodeID, nodeType, nodePosition;

-(int) getInnovationID {
    return nodeID;
}

-(NSComparisonResult) compareIDWith: (GenomeNode *) anotherNode {
    if (self.nodeID < anotherNode.nodeID) {
        return NSOrderedDescending;
    }
    if (self.nodeID == anotherNode.nodeID) {
        return NSOrderedSame;
    }
    return NSOrderedAscending;
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
    
    return [NSString stringWithFormat:@"%@ Node %i at (%1.1f, %1.1f)",
            nodePositionString, nodeID, nodePosition.x, nodePosition.y];
}

-(GenomeNode *) copyWithZone: (NSZone *) zone {
    GenomeNode * copiedGenoNode = [[GenomeNode alloc] init];
    copiedGenoNode.nodeID = nodeID;
    copiedGenoNode.nodeType = nodeType;
    copiedGenoNode.nodePosition = nodePosition;
    return copiedGenoNode;
}

@end
