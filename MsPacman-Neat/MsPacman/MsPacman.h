//
//  MsPacman.h
//  MsPacman-Neat
//
//  Created by Murphy Crosby on 1/6/19.
//  Copyright © 2019 Murphy Crosby. All rights reserved.
//

#import "Level1.h"

#ifndef MsPacman_h
#define MsPacman_h

@interface MsPacman : NSObject {
    int logLevel;
    Level1* lvl1;
    
    NSMutableArray* msPacmanHistory;
    NSMutableArray* blinkyHistory;
    NSMutableArray* pinkyHistory;
    NSMutableArray* inkyHistory;
    NSMutableArray* sueHistory;
    NSMutableArray* scaredGhostHistory;
    
}

-(id)init: (int) logLvl;
-(void) saveScreenshot: (CGImageRef) screenshot filename: (NSString*) filename number: (NSString*) num;
-(BOOL) isGameOver: (CGImageRef) screenshot;
-(long) getScore: (CGImageRef) screenshot;
-(NSMutableArray*) getInputValues: (CGImageRef) screenshot;

@end

#endif /* MsPacman_h */
