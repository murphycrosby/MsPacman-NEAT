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
    //for LSTM
    double hiddenState;
    double cellState;
}

@property int nodeID;
@property NodeType nodeType;
@property (strong) NSMutableArray* incomingPhenoLinks;
@property (strong) NSMutableArray* outgoingPhenoLinks;
@property double activationValue;
@property BOOL activated;

-(void) activate;
-(void) activateLSTM;
-(void) clearLinks;

+(double) fsigmoid:(double) activesum;
//-(double) gaussrand;

@end

#endif /* PhenomeNode_h */
