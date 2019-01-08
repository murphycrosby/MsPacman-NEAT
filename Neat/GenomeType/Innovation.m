//
//  Innovation.m
//  MsPacman-Neat
//
//  Created by Murphy Crosby on 1/2/19.
//  Copyright © 2019 Murphy Crosby. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Innovation.h"
#import "InnovationDb.h"
#import "GenomeLink.h"
#import "GenomeNode.h"

@implementation Innovation
@synthesize nodeOrLink, fromNodeID, toNodeID;

-(NSString *) description {
    if ([nodeOrLink isMemberOfClass: [GenomeLink class]]) {
        return [NSString stringWithFormat: @"Link Innovation %d between node %d and node %d",
                [nodeOrLink getInnovationID], fromNodeID, toNodeID];
    }
    if ([nodeOrLink isMemberOfClass: [GenomeNode class]]) {
        return [NSString stringWithFormat: @"Node Innovation %d between node %d and node %d",
                [nodeOrLink getInnovationID], fromNodeID, toNodeID];
    }
    return @"unknown";
}

@end
