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

-(id) initWithCoder:(NSCoder*) coder {
    self = [super init];
    if (self) {
        linkID = [coder decodeIntForKey:@"linkID"];
        fromNode = [coder decodeIntForKey:@"fromNode"];
        toNode = [coder decodeIntForKey:@"toNode"];
        weight = [coder decodeDoubleForKey:@"weight"];
        isEnabled = [coder decodeBoolForKey:@"isEnabled"];
        
        if(![[InnovationDb sharedDb] linkExists:fromNode toNode:toNode]) {
            [[InnovationDb sharedDb] insertNewLink:self fromNode:fromNode toNode:toNode];
            [InnovationDb setNextInnovationID: linkID];
        }
    }
    return self;
}

-(void) encodeWithCoder:(NSCoder*) coder {
    [coder encodeInt:linkID forKey:@"linkID"];
    [coder encodeInt:fromNode forKey:@"fromNode"];
    [coder encodeInt:toNode forKey:@"toNode"];
    [coder encodeDouble:weight forKey:@"weight"];
    [coder encodeBool:isEnabled forKey:@"isEnabled"];
}

+(BOOL) supportsSecureCoding {
    return YES;
}

-(BOOL) isEqual:(GenomeLink*) link {
    if(linkID != link.linkID) {
        return FALSE;
    }
    
    if(fromNode != link.fromNode) {
        return FALSE;
    }
    
    if(toNode != link.toNode) {
        return FALSE;
    }
    
    if(weight != link.weight) {
        return FALSE;
    }
    
    if(isEnabled != link.isEnabled) {
        return FALSE;
    }
    
    return TRUE;
}

@end
