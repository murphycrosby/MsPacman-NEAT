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

- (id)init: (int) logLvl {
    self = [super init];
    if (!self) {
        return self;
    }
    
    level1Rects = [[NSMutableDictionary alloc] init];
    NSMutableArray* array;
    
    array = [[NSMutableArray alloc] init];
    [array addObject:[NSValue valueWithRect:CGRectMake(31,23,216-31,23)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(279,23,587-279,23)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(650,23,834-650,23)]];
    [level1Rects setObject:array forKey:@"0"];
    
    array = [[NSMutableArray alloc] init];
    [array addObject:[NSValue valueWithRect:CGRectMake(31,47,61-31,22)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(186,47,216-186,22)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(279,47,309-279,22)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(557,47,587-557,22)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(650,47,679-650,22)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(804,47,834-804,22)]];
    [level1Rects setObject:array forKey:@"1"];
    
    array = [[NSMutableArray alloc] init];
    [array addObject:[NSValue valueWithRect:CGRectMake(31,70,61-31,22)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(186,70,216-186,22)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(279,70,309-279,22)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(557,70,587-557,22)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(650,70,679-650,22)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(804,70,834-804,22)]];
    [level1Rects setObject:array forKey:@"2"];
    
    array = [[NSMutableArray alloc] init];
    [array addObject:[NSValue valueWithRect:CGRectMake(31,93,834-31,22)]];
    [level1Rects setObject:array forKey:@"3"];
    
    array = [[NSMutableArray alloc] init];
    [array addObject:[NSValue valueWithRect:CGRectMake(93,116,123-93,23)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(186,116,216-186,23)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(371,116,401-371,23)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(464,116,494-464,23)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(650,116,679-650,23)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(742,116,772-742,23)]];
    [level1Rects setObject:array forKey:@"4"];
    
    array = [[NSMutableArray alloc] init];
    [array addObject:[NSValue valueWithRect:CGRectMake(93,140,123-93,22)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(186,140,216-186,22)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(371,140,401-371,22)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(464,140,494-464,22)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(650,140,679-650,22)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(742,140,772-742,22)]];
    [level1Rects setObject:array forKey:@"5"];
    
    array = [[NSMutableArray alloc] init];
    [array addObject:[NSValue valueWithRect:CGRectMake(0,163,123-0,22)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(186,163,401-186,22)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(464,163,679-464,22)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(742,163,865-742,22)]];
    [level1Rects setObject:array forKey:@"6"];
    
    array = [[NSMutableArray alloc] init];
    [array addObject:[NSValue valueWithRect:CGRectMake(93,186,123-93,22)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(279,186,309-279,22)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(557,186,587-557,22)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(742,186,772-742,22)]];
    [level1Rects setObject:array forKey:@"7"];
    
    array = [[NSMutableArray alloc] init];
    [array addObject:[NSValue valueWithRect:CGRectMake(93,209,123-93,22)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(279,209,309-279,22)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(557,209,587-557,22)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(742,209,772-742,22)]];
    [level1Rects setObject:array forKey:@"8"];
    
    array = [[NSMutableArray alloc] init];
    [array addObject:[NSValue valueWithRect:CGRectMake(93,232,772-93,23)]];
    [level1Rects setObject:array forKey:@"9"];
    
    array = [[NSMutableArray alloc] init];
    [array addObject:[NSValue valueWithRect:CGRectMake(93,256,123-93,22)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(279,256,309-279,22)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(557,256,587-557,22)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(742,256,772-742,22)]];
    [level1Rects setObject:array forKey:@"10"];
    
    array = [[NSMutableArray alloc] init];
    [array addObject:[NSValue valueWithRect:CGRectMake(93,279,123-93,22)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(279,279,309-279,22)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(557,279,587-557,22)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(742,279,772-742,22)]];
    [level1Rects setObject:array forKey:@"11"];
    
    array = [[NSMutableArray alloc] init];
    [array addObject:[NSValue valueWithRect:CGRectMake(93,302,123-93,22)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(186,302,309-186,22)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(557,302,679-557,22)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(742,302,772-742,22)]];
    [level1Rects setObject:array forKey:@"12"];
    
    array = [[NSMutableArray alloc] init];
    [array addObject:[NSValue valueWithRect:CGRectMake(93,325,123-93,22)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(186,325,216-186,22)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(279,325,309-279,22)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(557,325,587-557,22)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(650,325,679-650,22)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(742,325,772-742,22)]];
    [level1Rects setObject:array forKey:@"13"];
    
    array = [[NSMutableArray alloc] init];
    [array addObject:[NSValue valueWithRect:CGRectMake(93,348,123-92,22)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(186,348,216-186,22)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(279,348,309-279,22)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(557,348,587-557,22)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(650,348,679-650,22)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(742,348,772-742,22)]];
    [level1Rects setObject:array forKey:@"14"];
    
    array = [[NSMutableArray alloc] init];
    [array addObject:[NSValue valueWithRect:CGRectMake(0,371,216-0,23)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(279,371,587-279,23)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(650,371,865-650,23)]];
    [level1Rects setObject:array forKey:@"15"];
    
    array = [[NSMutableArray alloc] init];
    [array addObject:[NSValue valueWithRect:CGRectMake(93,395,123-93,22)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(371,395,401-371,22)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(464,395,494-464,22)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(742,395,772-742,22)]];
    [level1Rects setObject:array forKey:@"16"];
    
    array = [[NSMutableArray alloc] init];
    [array addObject:[NSValue valueWithRect:CGRectMake(93,418,123-93,22)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(371,418,401-371,22)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(464,418,494-464,22)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(742,418,772-742,22)]];
    [level1Rects setObject:array forKey:@"17"];
    
    array = [[NSMutableArray alloc] init];
    [array addObject:[NSValue valueWithRect:CGRectMake(93,441,401-93,22)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(464,441,772-464,22)]];
    [level1Rects setObject:array forKey:@"18"];
    
    array = [[NSMutableArray alloc] init];
    [array addObject:[NSValue valueWithRect:CGRectMake(93,464,123-93,22)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(279,464,309-279,22)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(557,464,587-557,22)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(742,464,772-742,22)]];
    [level1Rects setObject:array forKey:@"19"];
    
    array = [[NSMutableArray alloc] init];
    [array addObject:[NSValue valueWithRect:CGRectMake(93,487,123-93,22)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(279,487,309-279,22)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(557,487,587-557,22)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(742,487,772-742,22)]];
    [level1Rects setObject:array forKey:@"20"];
    
    array = [[NSMutableArray alloc] init];
    [array addObject:[NSValue valueWithRect:CGRectMake(31,510,834-31,23)]];
    [level1Rects setObject:array forKey:@"21"];
    
    array = [[NSMutableArray alloc] init];
    [array addObject:[NSValue valueWithRect:CGRectMake(31,534,61-31,22)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(186,534,216-186,22)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(371,534,401-371,22)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(464,534,494-464,22)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(650,534,679-650,22)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(804,534,834-804,22)]];
    [level1Rects setObject:array forKey:@"22"];
    
    array = [[NSMutableArray alloc] init];
    [array addObject:[NSValue valueWithRect:CGRectMake(31,557,61-31,22)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(186,557,216-186,22)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(371,557,401-371,22)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(464,557,494-464,22)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(650,557,679-650,22)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(804,557,834-804,22)]];
    [level1Rects setObject:array forKey:@"23"];
    
    array = [[NSMutableArray alloc] init];
    [array addObject:[NSValue valueWithRect:CGRectMake(31,580,61-31,22)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(186,580,216-186,22)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(279,580,401-279,22)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(464,580,587-464,22)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(650,580,679-650,22)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(804,580,834-804,22)]];
    [level1Rects setObject:array forKey:@"24"];
    
    array = [[NSMutableArray alloc] init];
    [array addObject:[NSValue valueWithRect:CGRectMake(31,603,61-31,22)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(186,603,216-186,22)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(279,603,309-279,22)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(557,603,587-557,22)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(650,603,679-650,22)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(804,603,834-804,22)]];
    [level1Rects setObject:array forKey:@"25"];
    
    array = [[NSMutableArray alloc] init];
    [array addObject:[NSValue valueWithRect:CGRectMake(31,626,61-31,22)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(186,626,216-186,22)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(279,626,309-279,22)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(557,626,587-557,22)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(650,626,679-650,22)]];
    [array addObject:[NSValue valueWithRect:CGRectMake(804,626,834-804,22)]];
    [level1Rects setObject:array forKey:@"26"];
    
    array = [[NSMutableArray alloc] init];
    [array addObject:[NSValue valueWithRect:CGRectMake(31,649,834-31,23)]];
    [level1Rects setObject:array forKey:@"27"];
    
    return self;
}

@end
