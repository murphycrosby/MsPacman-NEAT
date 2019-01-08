//
//  playGame.h
//  MsPacman-Neat
//
//  Created by Murphy Crosby on 12/27/18.
//  Copyright © 2018 Murphy Crosby. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Keyboard.h"
#import "Screenshot.h"
#import "MsPacman.h"

NS_ASSUME_NONNULL_BEGIN

@interface Game : NSObject {
    //Keyboard* keyboard;
    //Screenshot* screen;
    //MsPacman* msPacman;
    //dispatch_queue_t queue;
    //dispatch_source_t sighandler;
    //int logLevel;
}

//@property (nonatomic,assign) BOOL exitLoop;
@property (nonatomic,retain) Keyboard* keyboard;
@property (nonatomic,retain) Screenshot* screen;
@property (nonatomic,retain) MsPacman* msPacman;
@property (nonatomic,strong) dispatch_source_t sighandler;
@property (nonatomic,readwrite) int logLevel;

- (id)init: (int)logLvl;
- (void) playEvolve: (int) generations;
- (void) playBest;

@end

NS_ASSUME_NONNULL_END
