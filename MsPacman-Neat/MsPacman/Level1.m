//
//  Level1.m
//  MsPacman-Neat
//
//  Created by Murphy Crosby on 1/12/19.
//  Copyright © 2019 Murphy Crosby. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Level1.h"

@implementation Level1

@synthesize level1Rects;
@synthesize level1Pellets;

- (id)init: (int) logLvl {
    self = [super init];
    if (!self) {
        return self;
    }
    
    //LogLevel: 2 - Error Messages
    //LogLevel:3 - Notification Messages
    logLevel = logLvl;
    
    level1Rects = [[NSMutableDictionary alloc] init];
    
    NSMutableArray* array;
    
    array = [[NSMutableArray alloc] init];
    [array addObject:[NSValue valueWithRect:CGRectMake(17,13,214,46)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(264,13,338,46)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(635,13,214,46)]];
    [level1Rects setObject:array forKey:@"0"];
    
    array = [[NSMutableArray alloc] init];
    [array addObject:[NSValue valueWithRect:CGRectMake(17,58,60,25)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(171,58,60,25)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(264,58,60,25)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(542,58,60,25)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(635,58,60,25)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(789,58,60,25)]];
    [level1Rects setObject:array forKey:@"1"];
    
    array = [[NSMutableArray alloc] init];
    [array addObject:[NSValue valueWithRect:CGRectMake(17,82,832,46)]];
    [level1Rects setObject:array forKey:@"2"];
    
    array = [[NSMutableArray alloc] init];
    [array addObject:[NSValue valueWithRect:CGRectMake(78,127,61,26)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(171,127,60,26)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(357,127,60,26)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(449,127,60,26)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(635,127,60,26)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(727,127,61,26)]];
    [level1Rects setObject:array forKey:@"3"];
    
    array = [[NSMutableArray alloc] init];
    [array addObject:[NSValue valueWithRect:CGRectMake(0,152,139,46)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(171,152,246,46)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(449,152,246,46)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(727,152,138,46)]];
    [level1Rects setObject:array forKey:@"4"];
    
    array = [[NSMutableArray alloc] init];
    [array addObject:[NSValue valueWithRect:CGRectMake(78,197,61,25)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(264,197,60,25)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(542,197,60,25)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(727,197,61,25)]];
    [level1Rects setObject:array forKey:@"5"];
    
    array = [[NSMutableArray alloc] init];
    [array addObject:[NSValue valueWithRect:CGRectMake(78,221,710,46)]];
    [level1Rects setObject:array forKey:@"6"];
    
    array = [[NSMutableArray alloc] init];
    [array addObject:[NSValue valueWithRect:CGRectMake(78,266,61,26)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(264,266,60,26)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(542,266,60,26)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(727,266,61,26)]];
    [level1Rects setObject:array forKey:@"7"];
    
    array = [[NSMutableArray alloc] init];
    [array addObject:[NSValue valueWithRect:CGRectMake(78,291,61,46)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(171,291,153,46)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(542,291,153,46)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(727,291,61,46)]];
    [level1Rects setObject:array forKey:@"8"];
    
    array = [[NSMutableArray alloc] init];
    [array addObject:[NSValue valueWithRect:CGRectMake(78,336,61,25)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(171,336,60,25)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(264,336,60,25)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(542,336,60,25)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(635,336,60,25)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(727,336,61,25)]];
    [level1Rects setObject:array forKey:@"9"];
    
    array = [[NSMutableArray alloc] init];
    [array addObject:[NSValue valueWithRect:CGRectMake(0,360,231,46)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(264,360,338,46)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(635,360,230,46)]];
    [level1Rects setObject:array forKey:@"10"];
    
    array = [[NSMutableArray alloc] init];
    [array addObject:[NSValue valueWithRect:CGRectMake(78,405,61,26)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(357,405,60,26)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(449,405,60,26)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(727,405,61,26)]];
    [level1Rects setObject:array forKey:@"11"];
    
    array = [[NSMutableArray alloc] init];
    [array addObject:[NSValue valueWithRect:CGRectMake(78,430,339,46)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(449,430,339,46)]];
    [level1Rects setObject:array forKey:@"12"];
    
    array = [[NSMutableArray alloc] init];
    [array addObject:[NSValue valueWithRect:CGRectMake(78,475,61,25)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(264,475,60,25)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(542,475,60,25)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(727,475,61,25)]];
    [level1Rects setObject:array forKey:@"13"];
    
    array = [[NSMutableArray alloc] init];
    [array addObject:[NSValue valueWithRect:CGRectMake(17,499,832,46)]];
    [level1Rects setObject:array forKey:@"14"];
    
    array = [[NSMutableArray alloc] init];
    [array addObject:[NSValue valueWithRect:CGRectMake(17,544,60,26)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(171,544,60,26)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(357,544,60,26)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(449,544,60,26)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(635,544,60,26)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(789,544,60,26)]];
    [level1Rects setObject:array forKey:@"15"];
    
    array = [[NSMutableArray alloc] init];
    [array addObject:[NSValue valueWithRect:CGRectMake(17,569,60,46)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(171,569,60,46)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(264,569,153,46)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(449,569,153,46)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(635,569,60,46)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(789,569,60,46)]];
    [level1Rects setObject:array forKey:@"16"];
    
    array = [[NSMutableArray alloc] init];
    [array addObject:[NSValue valueWithRect:CGRectMake(17,614,60,25)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(171,614,60,25)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(264,614,60,25)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(542,614,60,25)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(635,614,60,25)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(789,614,60,25)]];
    [level1Rects setObject:array forKey:@"17"];
    
    array = [[NSMutableArray alloc] init];
    [array addObject:[NSValue valueWithRect:CGRectMake(17,638,832,45)]];
    [level1Rects setObject:array forKey:@"18"];
    
    //Pellets
    level1Pellets = [[NSMutableArray alloc] init];
    
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(40, 32, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(71, 32, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(102, 32, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(133, 32, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(164, 32, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(195, 32, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(40, 55, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(195, 55, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(287, 32, 13, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(318, 32, 13, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(349, 32, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(380, 32, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(411, 32, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(442, 32, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(473, 32, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(504, 32, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(534, 32, 13, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(565, 32, 13, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(287, 55, 13, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(565, 55, 13, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(658, 32, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(689, 32, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(720, 32, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(751, 32, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(782, 32, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(813, 32, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(658, 55, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(813, 55, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(32, 71, 28, 21)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(195, 79, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(287, 79, 13, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(565, 79, 13, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(658, 79, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(805, 71, 28, 21)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(40, 102, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(71, 102, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(102, 102, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(133, 102, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(164, 102, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(195, 102, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(225, 102, 13, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(256, 102, 13, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(287, 102, 13, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(318, 102, 13, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(349, 102, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(380, 102, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(411, 102, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(442, 102, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(473, 102, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(504, 102, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(534, 102, 13, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(565, 102, 13, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(596, 102, 13, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(627, 102, 13, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(658, 102, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(689, 102, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(720, 102, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(751, 102, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(782, 102, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(813, 102, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(102, 125, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(195, 125, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(380, 125, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(473, 125, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(658, 125, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(751, 125, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(102, 148, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(195, 148, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(380, 148, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(473, 148, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(658, 148, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(751, 148, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(102, 171, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(102, 194, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(195, 171, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(225, 171, 13, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(256, 171, 13, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(287, 171, 13, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(318, 171, 13, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(349, 171, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(380, 171, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(473, 171, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(504, 171, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(534, 171, 13, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(565, 171, 13, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(596, 171, 13, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(627, 171, 13, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(658, 171, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(751, 171, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(751, 194, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(102, 218, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(751, 218, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(102, 241, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(751, 241, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(102, 264, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(751, 264, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(102, 287, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(751, 287, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(102, 310, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(102, 333, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(751, 310, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(751, 333, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(102, 357, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(751, 357, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(102, 380, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(102, 403, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(751, 380, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(751, 403, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(102, 426, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(751, 426, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(102, 449, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(133, 449, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(164, 449, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(195, 449, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(225, 449, 13, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(256, 449, 13, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(287, 449, 13, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(102, 473, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(287, 473, 13, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(565, 449, 13, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(596, 449, 13, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(627, 449, 13, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(658, 449, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(689, 449, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(720, 449, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(751, 449, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(565, 473, 13, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(751, 473, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(102, 496, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(287, 496, 13, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(565, 496, 13, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(751, 496, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(40, 519, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(71, 519, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(102, 519, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(133, 519, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(164, 519, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(195, 519, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(225, 519, 13, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(256, 519, 13, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(287, 519, 13, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(318, 519, 13, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(349, 519, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(380, 519, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(473, 519, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(504, 519, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(534, 519, 13, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(565, 519, 13, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(596, 519, 13, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(627, 519, 13, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(658, 519, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(689, 519, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(720, 519, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(751, 519, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(782, 519, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(813, 519, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(40, 542, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(195, 542, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(380, 542, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(473, 542, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(658, 542, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(813, 542, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(40, 565, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(195, 565, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(380, 565, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(473, 565, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(658, 565, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(813, 565, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(32, 581, 28, 21)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(40, 612, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(195, 588, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(195, 612, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(287, 588, 13, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(318, 588, 13, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(349, 588, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(380, 588, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(287, 612, 13, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(473, 588, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(504, 588, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(534, 588, 13, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(565, 588, 13, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(565, 612, 13, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(658, 588, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(658, 612, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(805, 581, 28, 21)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(813, 612, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(40, 635, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(195, 635, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(287, 635, 13, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(565, 635, 13, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(658, 635, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(813, 635, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(40, 658, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(71, 658, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(102, 658, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(133, 658, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(164, 658, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(195, 658, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(225, 658, 13, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(256, 658, 13, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(287, 658, 13, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(318, 658, 13, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(349, 658, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(380, 658, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(411, 658, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(442, 658, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(473, 658, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(504, 658, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(534, 658, 13, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(565, 658, 13, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(596, 658, 13, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(627, 658, 13, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(658, 658, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(689, 658, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(720, 658, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(751, 658, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(782, 658, 12, 6)]];
    [level1Pellets addObject:[NSValue valueWithRect:CGRectMake(813, 658, 12, 6)]];
    
    if(logLevel >= 3) {
        NSLog(@"Level 1 - Play Rect Count: %lu", (unsigned long)[level1Rects count]);
        NSLog(@"Level 1 - Pellet Count: %lu", (unsigned long)[level1Pellets count]);
    }
    return self;
}

@end
