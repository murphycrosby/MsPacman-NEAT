//
//  PhenomeNode.h
//  MsPacman-Neat
//
//  Created by Murphy Crosby on 1/2/19.
//  Copyright © 2019 Murphy Crosby. All rights reserved.
//

#ifndef PhenomeNode_h
#define PhenomeNode_h

#import <Foundation/Foundation.h>
#import "GenomeNode.h"

@interface PhenomeNode : NSObject {
    //int nodeID;
    //NodeType nodeType;
    
    //NSMutableArray* incomingPhenoLinks;
    //NSMutableArray* outgoingPhenoLinks;
    
    //double activationValue;
    //double lastActivationValue;
    //bool hasChangedSinceLastTraversal;
}

@property int nodeID;
@property NodeType nodeType;
@property (retain) NSMutableArray* incomingPhenoLinks;
@property (retain) NSMutableArray* outgoingPhenoLinks;
@property double activationValue;
@property BOOL activated;

-(void) activate;
-(void) clearLinks;

+(double) fsigmoid:(double) activesum slope:(double) slope constant:(double) constant;
//-(double) gaussrand;

@end

#endif /* PhenomeNode_h */
