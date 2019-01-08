//
//  Keyboard.h
//  MsPacman-Neat
//
//  Created by Murphy Crosby on 12/27/18.
//  Copyright © 2018 Murphy Crosby. All rights reserved.
//

#ifndef Keyboard_h
#define Keyboard_h

@interface Keyboard : NSObject {
    io_connect_t connect;
    io_service_t service;
    int logLevel;
}

@property (nonatomic) io_connect_t connect;
@property (nonatomic) io_service_t service;
@property (nonatomic) int logLevel;

- (id)init: (int) logLvl;
- (BOOL) sendKey: (uint8_t) key;

@end

#endif /* Keyboard_h */
