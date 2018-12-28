//
//  playGame.h
//  MsPacman-Neat
//
//  Created by Murphy Crosby on 12/27/18.
//  Copyright © 2018 Murphy Crosby. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Keyboard/Keyboard.h"

NS_ASSUME_NONNULL_BEGIN

@interface Game : NSObject {
    Keyboard *keyboard;
    int logLevel;
}

@property (nonatomic,retain) Keyboard *keyboard;
@property (nonatomic,readwrite) int logLevel;

- (id)init: (int)logLevel;
- (void) play;

@end

NS_ASSUME_NONNULL_END
