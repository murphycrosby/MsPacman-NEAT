//
//  PhenomeLink.m
//  MsPacman-Neat
//
//  Created by Murphy Crosby on 1/2/19.
//  Copyright © 2019 Murphy Crosby. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhenomeLink.h"
#import "PhenomeNode.h"

@implementation PhenoLink
@synthesize weight, fromNode, toNode, isEnabled;

-(NSString*) description {
    return [NSString stringWithFormat:@"Link connecting %d to %d with weight: %1.3f %@",
            fromNode.nodeID, toNode.nodeID, weight, (isEnabled)?@"":@"(disabled)"];
}

-(void) dealloc {
    fromNode = nil;
    toNode = nil;
}

@end
