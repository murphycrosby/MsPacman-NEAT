//
//  MsPacman.h
//  MsPacman-Neat
//
//  Created by Murphy Crosby on 1/6/19.
//  Copyright © 2019 Murphy Crosby. All rights reserved.
//

#ifndef MsPacman_h
#define MsPacman_h

@interface MsPacman : NSObject {
    int logLevel;
}

@property (nonatomic) int logLevel;

-(id)init: (int) logLvl;
-(void) saveScreenshot: (CGImageRef) screenshot number: (int) num;
-(BOOL) isGameOver: (CGImageRef) screenshot;
-(long) getScore: (CGImageRef) screenshot;
-(NSMutableArray*) getInputValues: (CGImageRef) screenshot;

@end

#endif /* MsPacman_h */
