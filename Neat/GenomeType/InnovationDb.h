//
//  InnovationDb.h
//  MsPacman-Neat
//
//  Created by Murphy Crosby on 1/2/19.
//  Copyright © 2019 Murphy Crosby. All rights reserved.
//

#ifndef InnovationDb_h
#define InnovationDb_h

#import <Foundation/Foundation.h>
@class GenomeNode;
@class GenomeLink;

@interface InnovationDb : NSObject {
    NSMutableArray * linkInnovations;
    NSMutableArray * nodeRecord;
}

-(GenomeNode *) getNodeWithID: (int) nodeID;
-(GenomeNode *) possibleNodeExistsFromNode: (int) fNode toNode: (int) tNode;
-(void) insertNewNode:(GenomeNode *) newNode fromNode:(int) fNode toNode: (int) tNode;
-(void) insertNewLink:(GenomeLink *) newLink fromNode:(int) fNode toNode: (int) tNode;
-(GenomeLink *) possibleLinkExistsFromNode: (int) fNode toNode: (int) tNode;
+(InnovationDb *) sharedDb;
+(int) getNextGenomeNodeID;
+(int) getNextInnovationID;

@end

#endif /* InnovationDb_h */
