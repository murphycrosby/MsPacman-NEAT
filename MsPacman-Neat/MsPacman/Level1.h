//
//  Level1_h
//  MsPacman-Neat
//
//  Created by Murphy Crosby on 1/12/19.
//  Copyright © 2019 Murphy Crosby. All rights reserved.
//

#ifndef Level1_h
#define Level1_h

@interface Level1 : NSObject {
    NSMutableDictionary* level1Rects;
}

@property (nonatomic) NSMutableDictionary* level1Rects;

-(id)init: (int) logLvl;

@end

#endif /* Level1_h */
