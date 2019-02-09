//
//  GenomeNode.h
//  MsPacman-Neat
//
//  Created by Murphy Crosby on 1/2/19.
//  Copyright © 2019 Murphy Crosby. All rights reserved.
//

#ifndef GenomeNode_h
#define GenomeNode_h

#import "Innovation.h"

typedef enum NodeType {
    UNKNOWN = 0,
    INPUT,
    HIDDEN,
    OUTPUT,
    BIAS,
} NodeType;

@interface GenomeNode : NSObject <InnovationInformationProtocol, NSCopying, NSSecureCoding> {

}

@property int nodeID;
@property NodeType nodeType;
@property int nodeLayer;
@property CGPoint nodePosition;

-(NSComparisonResult) compareIDWith: (GenomeNode*) anotherNode;
-(BOOL) isEqual:(GenomeNode*) node;
+(NSString*) NodeTypeString: (NodeType) nodeType;

@end

#endif /* GenomeNode_h */
