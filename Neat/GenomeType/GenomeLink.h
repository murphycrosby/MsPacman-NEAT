//
//  GenomeLink.h
//  MsPacman-Neat
//
//  Created by Murphy Crosby on 1/2/19.
//  Copyright © 2019 Murphy Crosby. All rights reserved.
//

#ifndef GenomeLink_h
#define GenomeLink_h

#import "Innovation.h"

@interface GenomeLink : NSObject <InnovationInformationProtocol>{
    int linkID;
    int fromNode;
    int toNode;
    double weight;
    bool isEnabled;
}

@property int linkID;
@property int fromNode;
@property int toNode;
@property double weight;
@property bool isEnabled;

- (id)initNewlyInnovatedLinkFromNode: (int) fNode toNode: (int) tNode withWeight: (double) wght;

@end

#endif /* GenomeLink_h */
