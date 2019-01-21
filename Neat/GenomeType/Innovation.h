//
//  Innovation.h
//  MsPacman-Neat
//
//  Created by Murphy Crosby on 1/2/19.
//  Copyright © 2019 Murphy Crosby. All rights reserved.
//

#ifndef Innovation_h
#define Innovation_h

#import <Foundation/Foundation.h>
@class GenomeNode;
@class GenomeLink;

@protocol InnovationInformationProtocol <NSObject>

-(int) getInnovationID;

@end

@interface Innovation : NSObject {
    //id <InnovationInformationProtocol> nodeOrLink;
    //int fromNodeID;
    //int toNodeID;
}

@property (strong) id nodeOrLink;
@property int fromNodeID;
@property int toNodeID;

@end

#endif /* Innovation_h */
