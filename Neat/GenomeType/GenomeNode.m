//
//  GenomeNode.m
//  MsPacman-Neat
//
//  Created by Murphy Crosby on 1/2/19.
//  Copyright © 2019 Murphy Crosby. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GenomeNode.h"
#import "InnovationDb.h"

@implementation GenomeNode

@synthesize nodeID, nodeType, nodePosition;

-(int) getInnovationID {
    return nodeID;
}

-(NSComparisonResult) compareIDWith: (GenomeNode*) anotherNode {
    if (self.nodeID < anotherNode.nodeID) {
        return NSOrderedDescending;
    }
    if (self.nodeID == anotherNode.nodeID) {
        return NSOrderedSame;
    }
    return NSOrderedAscending;
}

-(NSString*) description {
    
    NSString* nodePositionString = [GenomeNode NodeTypeString:nodeType];
    
    return [NSString stringWithFormat:@"%@ Node %i at (%1.1f, %1.1f)",
            nodePositionString, nodeID, nodePosition.x, nodePosition.y];
}

-(GenomeNode*) copyWithZone: (NSZone*) zone {
    GenomeNode* copiedGenoNode = [[GenomeNode alloc] init];
    copiedGenoNode.nodeID = nodeID;
    copiedGenoNode.nodeType = nodeType;
    copiedGenoNode.nodePosition = nodePosition;
    return copiedGenoNode;
}

-(id) initWithCoder:(NSCoder*) coder {
    self = [super init];
    if (self) {
        nodeID = [coder decodeIntForKey:@"nodeID"];
        nodeType = [coder decodeIntForKey:@"nodeType"];
        
        if(![[InnovationDb sharedDb] nodeExists: nodeID]) {
            [[InnovationDb sharedDb] insertNewNode:self fromNode:0 toNode:0];
            [InnovationDb setNextGenomeNodeID:nodeID];
        }
    }
    return self;
}

-(void) encodeWithCoder:(NSCoder*) coder {
    [coder encodeInt:nodeID forKey:@"nodeID"];
    [coder encodeInt:nodeType forKey:@"nodeType"];
}

+(BOOL) supportsSecureCoding {
    return YES;
}

-(BOOL) isEqual:(GenomeNode*) node {
    if(nodeID != node.nodeID) {
        return FALSE;
    }
    
    if (nodeType != node.nodeType) {
        return FALSE;
    }
    
    return TRUE;
}

+(NSString*) NodeTypeString: (NodeType) nodeType {
    NSString* ntString;
    switch (nodeType) {
        case HIDDEN:
            ntString = @"HIDDEN";
            break;
        case INPUT:
            ntString = @"INPUT";
            break;
        case OUTPUT:
            ntString = @"OUTPUT";
            break;
        case BIAS:
            ntString = @"BIAS";
            break;
        default:
            ntString = @"UNKNOWN"; // error
            break;
    }
    return ntString;
}

@end
