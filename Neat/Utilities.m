//
//  Utilities.m
//  MsPacman-Neat
//
//  Created by Murphy Crosby on 1/2/19.
//  Copyright © 2019 Murphy Crosby. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Utilities.h"

#define ARC4RANDOM_MAX 0x100000000

@implementation Utilities

double randomDouble (void) {
    //return (rand())/(RAND_MAX+1.0);
    return ((double)arc4random()) / (ARC4RANDOM_MAX + 1.0);
}

double randomClampedDouble (void) {
    return randomDouble() - randomDouble();
}

@end
