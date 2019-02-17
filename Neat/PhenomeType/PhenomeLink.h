//
//  PhenomeLink.h
//  MsPacman-Neat
//
//  Created by Murphy Crosby on 1/2/19.
//  Copyright © 2019 Murphy Crosby. All rights reserved.
//

#ifndef PhenomeLink_h
#define PhenomeLink_h

@class PhenomeNode;

@interface PhenoLink : NSObject {

}

@property (strong) PhenomeNode* fromNode;
@property (strong) PhenomeNode* toNode;
@property double weight;
@property bool isEnabled;

@end

#endif /* PhenomeLink_h */
