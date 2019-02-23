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
}

@property (nonatomic,strong) Keyboard* keyboard;
@property (nonatomic,strong) Screenshot* screen;
@property (nonatomic,strong) MsPacman* msPacman;
@property (nonatomic,readwrite) int logLevel;

- (id)init:(BOOL) debug workingDir:(NSString*) workingDir logLevel:(int)logLvl;
- (void) playEvolve:(NSString*) workingDir populationFile:(NSString*) populationFile;
- (void) playBest:(NSString*) workingDir populationFile:(NSString*) populationFile;
- (void) checkSimilarity:(NSString*) workingDir populationFile:(NSString*) populationFile;
- (void) checkAllSimilarity:(NSString*) workingDir populationFile:(NSString*) populationFile;

@end

NS_ASSUME_NONNULL_END
