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
    NSString* workingDirectory;
}

@property (nonatomic, assign) BOOL canGoUp;
@property (nonatomic, assign) BOOL canGoRight;
@property (nonatomic, assign) BOOL canGoDown;
@property (nonatomic, assign) BOOL canGoLeft;

-(id)init:(NSString*) workingDir logLevel:(int) logLvl;
-(void) saveScreenshot: (CGImageRef) screenshot filename: (NSString*) filename number: (NSString*) num;
-(BOOL) isGameOver: (CGImageRef) screenshot;
-(BOOL) isReady: (CGImageRef) screenshot;
-(long) getScore: (CGImageRef) screenshot;
-(long) getPelletsEaten: (CGImageRef) screenshot;
-(NSArray*) getInputValues: (CGImageRef) screenshot;

@end

#endif /* MsPacman_h */
