//
//  Screenshot.h
//  MsPacman-Neat
//
//  Created by Murphy Crosby on 1/5/19.
//  Copyright © 2019 Murphy Crosby. All rights reserved.
//

#ifndef Screenshot_h
#define Screenshot_h

@interface Screenshot : NSObject {
    NSString *kWindowIDKey;
    NSString *kWindowBounds;
    NSMutableDictionary *window;
    CGWindowID windowID;
    int logLevel;
}

@property (nonatomic) int logLevel;

-(id)init: (int) logLvl;
-(CGImageRef) takeScreenshot;

@end

#endif /* Screenshot_h */
