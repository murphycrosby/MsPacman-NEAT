//
//  GenomeLink.m
//  MsPacman-Neat
//
//  Created by Murphy Crosby on 1/2/19.
//  Copyright © 2019 Murphy Crosby. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GenomeLink.h"
#import "GenomeNode.h"
#import "InnovationDb.h"

@implementation GenomeLink
@synthesize linkID, weight, fromNode, toNode, isEnabled;

- (id)initNewlyInnovatedLinkFromNode: (int) fNode toNode: (int) tNode withWeight: (double) wght {
    self = [super init];
    if (self) {
        linkID = [InnovationDb getNextInnovationID];
        fromNode = fNode;
        toNode = tNode;
        weight = wght;
        isEnabled = true;
    }
    return self;
}

-(int) getInnovationID {
    return linkID;
}

-(NSComparisonResult) compareIDWith: (GenomeLink*) anotherLink {
    if (self.linkID < anotherLink.linkID) {
        return NSOrderedAscending;
    }
    if (self.linkID == anotherLink.linkID) {
        return NSOrderedSame;
    }
    return NSOrderedDescending;
}


-(NSString*) description {
    return [NSString stringWithFormat:@"Link %d connecting %d to %d with weight: %1.3f %@",
            linkID, fromNode, toNode, weight, (isEnabled)?@"":@"(disabled)"];
}

-(GenomeLink*) copyWithZone: (NSZone*) zone {
    GenomeLink* copiedGenoLink = [[GenomeLink alloc] init];
    copiedGenoLink.linkID = linkID;
    copiedGenoLink.fromNode = fromNode;
    copiedGenoLink.toNode = toNode;
    copiedGenoLink.isEnabled = isEnabled;
    copiedGenoLink.weight = weight;
    return copiedGenoLink;
}

@end
