//
//  MsPacman.m
//  MsPacman-Neat
//
//  Created by Murphy Crosby on 1/6/19.
//  Copyright © 2019 Murphy Crosby. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MsPacman.h"

@implementation MsPacman

@synthesize msPacman;
@synthesize canGoUp;
@synthesize canGoRight;
@synthesize canGoDown;
@synthesize canGoLeft;
@synthesize blinky;
@synthesize pinky;
@synthesize inky;
@synthesize sue;

- (id)init: (int) logLvl {
    self = [super init];
    if (!self) {
        return self;
    }
    
    //LogLevel:2 - Error Messages
    //LogLevel:3 - Notification Messages
    //LogLevel:4 - Verbose Messages
    logLevel = logLvl;
    
    lvl1 = [[Level1 alloc] init: logLvl];
    msPacmanHistory = [[NSMutableArray alloc] init];
    blinkyHistory = [[NSMutableArray alloc] init];
    pinkyHistory = [[NSMutableArray alloc] init];
    inkyHistory = [[NSMutableArray alloc] init];
    sueHistory = [[NSMutableArray alloc] init];
    scaredGhostHistory = [[NSMutableArray alloc] init];
    
    for(int i = 0; i < 4; i++) {
        [msPacmanHistory insertObject:[NSValue valueWithRect:CGRectZero] atIndex:0];
        [blinkyHistory insertObject:[NSValue valueWithRect:CGRectZero] atIndex:0];
        [pinkyHistory insertObject:[NSValue valueWithRect:CGRectZero] atIndex:0];
        [inkyHistory insertObject:[NSValue valueWithRect:CGRectZero] atIndex:0];
        [sueHistory insertObject:[NSValue valueWithRect:CGRectZero] atIndex:0];
        //Scared Ghost 1
        [scaredGhostHistory insertObject:[NSValue valueWithRect:CGRectZero] atIndex:0];
        //Scared Ghost 2
        [scaredGhostHistory insertObject:[NSValue valueWithRect:CGRectZero] atIndex:0];
        //Scared Ghost 3
        [scaredGhostHistory insertObject:[NSValue valueWithRect:CGRectZero] atIndex:0];
        //Scared Ghost 4
        [scaredGhostHistory insertObject:[NSValue valueWithRect:CGRectZero] atIndex:0];
    }
    
    return self;
}

-(BOOL) isGameOver: (CGImageRef) screenshot {
    size_t width;
    size_t height;
    size_t bitsPerComponent;
    size_t bitmapBytesPerRow;
    size_t bitmapByteCount;
    CGRect rect;
    CGImageRef imageRef;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);
    
    int count = 0;
    int items = 0;
    int x = 746;
    
    while(x >= 466) {
        rect = CGRectMake(x, 554, 30, 25);
        imageRef = CGImageCreateWithImageInRect(screenshot, rect);
        
        width = CGImageGetWidth(imageRef);
        height = CGImageGetHeight(imageRef);
        bitsPerComponent = CGImageGetBitsPerComponent(imageRef);
        bitmapBytesPerRow = (width * 4);
        bitmapByteCount = (bitmapBytesPerRow * height);
        
        void* bitmapData = malloc( bitmapByteCount );
        
        CGContextRef context = CGBitmapContextCreate (bitmapData,
                                                      width,
                                                      height,
                                                      bitsPerComponent,
                                                      bitmapBytesPerRow,
                                                      colorSpace,
                                                      kCGImageAlphaPremultipliedFirst);
        
        rect = CGRectMake(0, 0, width, height);
        CGContextDrawImage(context, rect, imageRef);
        
        unsigned char* data = CGBitmapContextGetData (context);
        BOOL pix1 = (data[(4*((width*8)+7))+1] != 0 && data[(4*((width*8)+7))+2] != 0 && data[(4*((width*8)+7))+3] != 0);
        BOOL pix2 = (data[(4*((width*8)+14))+1] != 0 && data[(4*((width*8)+14))+2] != 0 && data[(4*((width*8)+14))+3] != 0);
        BOOL pix3 = (data[(4*((width*8)+22))+1] != 0 && data[(4*((width*8)+22))+2] != 0 && data[(4*((width*8)+22))+3] != 0);
        BOOL pix4 = (data[(4*((width*16)+7))+1] != 0 && data[(4*((width*16)+7))+2] != 0 && data[(4*((width*16)+7))+3] != 0);
        BOOL pix5 = (data[(4*((width*16)+14))+1] != 0 && data[(4*((width*16)+14))+2] != 0 && data[(4*((width*16)+14))+3] != 0);
        BOOL pix6 = (data[(4*((width*16)+22))+1] != 0 && data[(4*((width*16)+22))+2] != 0 && data[(4*((width*16)+22))+3] != 0);
        
        if(count == 0) {
            //R
            if(pix1 && !pix2 && pix3 && pix4 && pix5 && !pix6) {
                items++;
            }
        } else if (count == 1){
            //E
            if(pix1 && !pix2 && !pix3 && pix4 && !pix5 && !pix6) {
                items++;
            }
        } else if (count == 2){
            //V
            if(pix1 && !pix2 && pix3 && !pix4 && pix5 && !pix6) {
                items++;
            }
        } else if (count == 3){
            //O
            if(pix1 && !pix2 && pix3 && pix4 && !pix5 && pix6) {
                items++;
            }
        } else if (count == 6){
            //E
            if(pix1 && !pix2 && !pix3 && pix4 && !pix5 && !pix6) {
                items++;
            }
        } else if (count == 7){
            //M
            if(pix1 && pix2 && pix3 && pix4 && !pix5 && pix6) {
                items++;
            }
        } else if (count == 8){
            //A
            if(pix1 && !pix2 && pix3 && pix4 && !pix5 && pix6) {
                items++;
            }
        } else if (count == 9){
            //G
            if(pix1 && !pix2 && !pix3 && pix4 && !pix5 && pix6) {
                items++;
            }
        }
        
        if (data) { free(data); }
        CGContextRelease(context);
        CGImageRelease(imageRef);
        
        count++;
        x = x - 30 - 1;
    }
    
    CGColorSpaceRelease(colorSpace);
    
    return items >= 5;
}

-(BOOL) isReady: (CGImageRef) screenshot {
    size_t width;
    size_t height;
    size_t bitsPerComponent;
    size_t bitmapBytesPerRow;
    size_t bitmapByteCount;
    CGRect rect;
    CGImageRef imageRef;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);
    
    int count = 0;
    int items = 0;
    int x = 684;
    
    while(x >= 500) {
        rect = CGRectMake(x, 554, 30, 25);
        imageRef = CGImageCreateWithImageInRect(screenshot, rect);
        
        width = CGImageGetWidth(imageRef);
        height = CGImageGetHeight(imageRef);
        bitsPerComponent = CGImageGetBitsPerComponent(imageRef);
        bitmapBytesPerRow = (width * 4);
        bitmapByteCount = (bitmapBytesPerRow * height);
        
        void* bitmapData = malloc( bitmapByteCount );
        
        CGContextRef context = CGBitmapContextCreate (bitmapData,
                                                      width,
                                                      height,
                                                      bitsPerComponent,
                                                      bitmapBytesPerRow,
                                                      colorSpace,
                                                      kCGImageAlphaPremultipliedFirst);
        
        rect = CGRectMake(0, 0, width, height);
        CGContextDrawImage(context, rect, imageRef);
        
        unsigned char* data = CGBitmapContextGetData (context);
        BOOL pix1 = (data[(4*((width*8)+7))+1] != 0 && data[(4*((width*8)+7))+2] != 0 && data[(4*((width*8)+7))+3] != 0);
        BOOL pix2 = (data[(4*((width*8)+14))+1] != 0 && data[(4*((width*8)+14))+2] != 0 && data[(4*((width*8)+14))+3] != 0);
        BOOL pix3 = (data[(4*((width*8)+22))+1] != 0 && data[(4*((width*8)+22))+2] != 0 && data[(4*((width*8)+22))+3] != 0);
        BOOL pix4 = (data[(4*((width*16)+7))+1] != 0 && data[(4*((width*16)+7))+2] != 0 && data[(4*((width*16)+7))+3] != 0);
        BOOL pix5 = (data[(4*((width*16)+14))+1] != 0 && data[(4*((width*16)+14))+2] != 0 && data[(4*((width*16)+14))+3] != 0);
        BOOL pix6 = (data[(4*((width*16)+22))+1] != 0 && data[(4*((width*16)+22))+2] != 0 && data[(4*((width*16)+22))+3] != 0);
        
        if(count == 0) {
            //!
            if(!pix1 && pix2 && !pix3 && !pix4 && !pix5 && !pix6) {
                items++;
            }
        } else if(count == 1) {
            //Y
            if(pix1 && !pix2 && pix3 && !pix4 && pix5 && !pix6) {
                items++;
            }
        }
        else if (count == 2){
            //D
            if(pix1 && !pix2 && pix3 && pix4 && !pix5 && pix6) {
                items++;
            }
        } else if (count == 3){
            //A
            if(pix1 && !pix2 && pix3 && pix4 && !pix5 && pix6) {
                items++;
            }
        } else if (count == 4){
            //E
            if(pix1 && !pix2 && !pix3 && pix4 && !pix5 && !pix6) {
                items++;
            }
        } else if (count == 5){
            //R
            if(pix1 && !pix2 && pix3 && pix4 && pix5 && !pix6) {
                items++;
            }
        }
        
        if (data) { free(data); }
        CGContextRelease(context);
        CGImageRelease(imageRef);
        
        count++;
        x = x - 30 - 1;
    }
    
    CGColorSpaceRelease(colorSpace);
    
    return items >= 3;
}

-(long) getPelletsEaten: (CGImageRef) screenshot {
    long pelletsEaten = 0;
    
    CGRect rect = CGRectMake(185, 185, 865, 695);
    CGImageRef playzone = CGImageCreateWithImageInRect(screenshot, rect);
    size_t width = CGImageGetWidth(playzone);
    
    unsigned char* data = [self getArrayFromImage:playzone];
    
    for(int c = 0; c < [lvl1.level1Pellets count]; c++) {
        CGRect rect = [[lvl1.level1Pellets objectAtIndex:c] rectValue];
        int x = CGRectGetMidX(rect);
        int y = CGRectGetMidY(rect);
        
        int offset = 4 * ((width * y) + round(x));
        int red   = data[offset + 1];
        int green = data[offset + 2];
        int blue  = data[offset + 3];
        
        //Pellet - [0][167][255]
        if (red != 0 || green != 167 || blue != 255) {
            pelletsEaten++;
        }
    }
    
    return pelletsEaten;
}

-(long) getScore: (CGImageRef) screenshot {
    size_t width;
    size_t height;
    size_t bitsPerComponent;
    size_t bitmapBytesPerRow;
    size_t bitmapByteCount;
    CGRect rect;
    CGImageRef imageRef;
    NSMutableString* score = [[NSMutableString alloc] init];
    
    //Whole score
    if(logLevel >= 4) {
        CGRect rect = CGRectMake(185, 160, 220, 25);
        CGImageRef imageRef = CGImageCreateWithImageInRect(screenshot, rect);
        [self saveScreenshot:imageRef filename:@"whole_score" number:0];
        CGImageRelease(imageRef);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);
    
    int x = 185+220-30;
    
    while(x >= 185) {
        rect = CGRectMake(x, 160, 30, 25);
        imageRef = CGImageCreateWithImageInRect(screenshot, rect);
        
        width = CGImageGetWidth(imageRef);
        height = CGImageGetHeight(imageRef);
        bitsPerComponent = CGImageGetBitsPerComponent(imageRef);
        bitmapBytesPerRow = (width * 4);
        bitmapByteCount = (bitmapBytesPerRow * height);
    
        void* bitmapData = malloc( bitmapByteCount );
    
        CGContextRef context = CGBitmapContextCreate (bitmapData,
                                                      width,
                                                      height,
                                                      bitsPerComponent,
                                                      bitmapBytesPerRow,
                                                      colorSpace,
                                                      kCGImageAlphaPremultipliedFirst);
    
        rect = CGRectMake(0, 0, width, height);
        CGContextDrawImage(context, rect, imageRef);
    
        unsigned char* data = CGBitmapContextGetData (context);
    
        if (logLevel >= 4) {
            NSLog(@"pix1: [%d,%d,%d]",data[(4*((width*4)+15))+1],data[(4*((width*4)+15))+2],data[(4*((width*4)+15))+3]);
            NSLog(@"pix2: [%d,%d,%d]",data[(4*((width*8)+7))+1],data[(4*((width*8)+7))+2],data[(4*((width*8)+7))+3]);
            NSLog(@"pix3: [%d,%d,%d]",data[(4*((width*8)+22))+1],data[(4*((width*8)+22))+2],data[(4*((width*8)+22))+3]);
            NSLog(@"pix4: [%d,%d,%d]",data[(4*((width*12)+7))+1],data[(4*((width*12)+7))+2],data[(4*((width*12)+7))+3]);
            NSLog(@"pix5: [%d,%d,%d]",data[(4*((width*12)+15))+1],data[(4*((width*12)+15))+2],data[(4*((width*12)+15))+3]);
            NSLog(@"pix6: [%d,%d,%d]",data[(4*((width*12)+22))+1],data[(4*((width*12)+22))+2],data[(4*((width*12)+22))+3]);
            NSLog(@"pix7: [%d,%d,%d]",data[(4*((width*15)+7))+1],data[(4*((width*15)+7))+2],data[(4*((width*15)+7))+3]);
            NSLog(@"pix8: [%d,%d,%d]",data[(4*((width*15)+22))+1],data[(4*((width*15)+22))+2],data[(4*((width*15)+22))+3]);
            NSLog(@"pix9: [%d,%d,%d]",data[(4*((width*19)+15))+1],data[(4*((width*19)+15))+2],data[(4*((width*19)+15))+3]);
        }
        
        BOOL pix1 = (data[(4*((width*4)+15))+1] != 0 && data[(4*((width*4)+15))+2] != 0 && data[(4*((width*4)+15))+3] != 0);
        BOOL pix2 = (data[(4*((width*8)+7))+1] != 0 && data[(4*((width*8)+7))+2] != 0 && data[(4*((width*8)+7))+3] != 0);
        BOOL pix3 = (data[(4*((width*8)+22))+1] != 0 && data[(4*((width*8)+22))+2] != 0 && data[(4*((width*8)+22))+3] != 0);
        BOOL pix4 = (data[(4*((width*12)+7))+1] != 0 && data[(4*((width*12)+7))+2] != 0 && data[(4*((width*12)+7))+3] != 0);
        BOOL pix5 = (data[(4*((width*12)+15))+1] != 0 && data[(4*((width*12)+15))+2] != 0 && data[(4*((width*12)+15))+3] != 0);
        BOOL pix6 = (data[(4*((width*12)+22))+1] != 0 && data[(4*((width*12)+22))+2] != 0 && data[(4*((width*12)+22))+3] != 0);
        BOOL pix7 = (data[(4*((width*15)+7))+1] != 0 && data[(4*((width*15)+7))+2] != 0 && data[(4*((width*15)+7))+3] != 0);
        BOOL pix8 = (data[(4*((width*15)+22))+1] != 0 && data[(4*((width*15)+22))+2] != 0 && data[(4*((width*15)+22))+3] != 0);
        BOOL pix9 = (data[(4*((width*19)+15))+1] != 0 && data[(4*((width*19)+15))+2] != 0 && data[(4*((width*19)+15))+3] != 0);
        
        if (pix1 && pix2 && pix3 && pix4 && !pix5 && pix6 && pix7 && pix8 && pix9) {
            [score insertString:@"0" atIndex:0];
        } else if (pix1 && pix2 && !pix3 && !pix4 && pix5 && !pix6 && !pix7 && !pix8 && pix9) {
            [score insertString:@"1" atIndex:0];
        } else if (pix1 && !pix2 && pix3 && pix4 && pix5 && pix6 && pix7 && !pix8 && pix9) {
            [score insertString:@"2" atIndex:0];
        } else if (pix1 && !pix2 && pix3 && pix4 && pix5 && pix6 && !pix7 && pix8 && pix9) {
            [score insertString:@"3" atIndex:0];
        } else if (!pix1 && pix2 && pix3 && pix4 && pix5 && pix6 && !pix7 && pix8 && !pix9) {
            [score insertString:@"4" atIndex:0];
        } else if (pix1 && pix2 && !pix3 && pix4 && pix5 && pix6 && !pix7 && pix8 && pix9) {
            [score insertString:@"5" atIndex:0];
        } else if (pix1 && pix2 && !pix3 && pix4 && pix5 && pix6 && pix7 && pix8 && pix9) {
            [score insertString:@"6" atIndex:0];
        } else if (pix1 && !pix2 && pix3 && !pix4 && !pix5 && pix6 && !pix7 && pix8 && !pix9) {
            [score insertString:@"7" atIndex:0];
        } else if (pix1 && pix2 && pix3 && pix4 && pix5 && pix6 && pix7 && pix8 && pix9) {
            [score insertString:@"8" atIndex:0];
        } else if (pix1 && pix2 && pix3 && pix4 && pix5 && pix6 && !pix7 && pix8 && !pix9) {
            [score insertString:@"9" atIndex:0];
        }
        
        if (data) { free(data); }
        CGContextRelease(context);
        CGImageRelease(imageRef);
        
        x = x - 30 - 1;
    }
    
    CGColorSpaceRelease(colorSpace);
    
    return [score longLongValue];
}

-(NSMutableArray*) getInputValues: (CGImageRef) screenshot {
    //int expectedInputCount = 366;
    //int history = 4;
    int expectedInputCount = 40;
    int history = 1;
    
    NSMutableArray* nsa = [[NSMutableArray alloc] init];
    
    CGRect rect = CGRectMake(185, 185, 865, 695);
    CGImageRef playzone = CGImageCreateWithImageInRect(screenshot, rect);
    
    //if(logLevel >= 3) {
        //[self saveScreenshot:playzone filename:@"input_values_playzone-" number:@"0"];
    //}
    
    size_t width = CGImageGetWidth(playzone);
    //size_t height = CGImageGetHeight(playzone);
    
    unsigned char* data = [self getArrayFromImage:playzone];
    
    NSMutableArray* mspacman_array = [[NSMutableArray alloc] init];
    NSMutableArray* blinky_array = [[NSMutableArray alloc] init];
    NSMutableArray* pinky_array = [[NSMutableArray alloc] init];
    NSMutableArray* inky_array = [[NSMutableArray alloc] init];
    NSMutableArray* sue_array = [[NSMutableArray alloc] init];
    NSMutableArray* scared_blue_array = [[NSMutableArray alloc] init];
    NSMutableArray* scared_gray_array = [[NSMutableArray alloc] init];
    
    for(int row = 0; row < [lvl1.level1Rects count]; row++) {
        NSArray* rects = [lvl1.level1Rects objectForKey:[NSString stringWithFormat:@"%d",row]];
        
        CGRect mspacman_temp = CGRectNull;
        CGRect blinky_temp = CGRectNull;
        CGRect pinky_temp = CGRectNull;
        CGRect inky_temp = CGRectNull;
        CGRect sue_temp = CGRectNull;
        CGRect scared_blue_temp = CGRectNull;
        CGRect scared_gray_temp = CGRectNull;
        
        BOOL mspacman_data = FALSE;
        BOOL blinky_data = FALSE;
        BOOL pinky_data = FALSE;
        BOOL inky_data = FALSE;
        BOOL sue_data = FALSE;
        BOOL scared_blue_data = FALSE;
        BOOL scared_gray_data = FALSE;
        
        for (int r = 0; r < [rects count]; r++) {
            CGRect rect = [[rects objectAtIndex:r] rectValue];
            
            for(int y = rect.origin.y; y < (rect.origin.y + rect.size.height); y++) {
                for(int x = rect.origin.x; x < (rect.origin.x + rect.size.width); x++) {
                    int offset = 4 * ((width * y) + round(x));
                    int red   = data[offset + 1];
                    int green = data[offset + 2];
                    int blue  = data[offset + 3];
                    
                    //MsPacman - [255,255,0]
                    mspacman_array = [self groupColors:&mspacman_data colorArray:mspacman_array rect:&mspacman_temp x:x y:y red:red green:green blue:blue
                             redMatch:255 greenMatch:255 blueMatch:0 logLvl:0];
                    
                    //Blinky - [224][42][172] (Dark Pink Ghost)
                    blinky_array = [self groupColors:&blinky_data colorArray:blinky_array rect:&blinky_temp x:x y:y red:red green:green blue:blue
                             redMatch:224 greenMatch:42 blueMatch:172 logLvl:0];
                    
                    //Pinky - [255][145][233] (Light Pink Ghost)
                    pinky_array = [self groupColors:&pinky_data colorArray:pinky_array rect:&pinky_temp x:x y:y red:red green:green blue:blue
                             redMatch:255 greenMatch:145 blueMatch:233 logLvl:0];
                    
                    //Inky - [73][248][255] (Blue Ghost)
                    inky_array = [self groupColors:&inky_data colorArray:inky_array rect:&inky_temp x:x y:y red:red green:green blue:blue
                             redMatch:73 greenMatch:248 blueMatch:255 logLvl:0];
                    
                    //Sue - [255][170][0] (Orange Ghost)
                    sue_array = [self groupColors:&sue_data colorArray:sue_array rect:&sue_temp x:x y:y red:red green:green blue:blue
                                 redMatch:255 greenMatch:170 blueMatch:0 logLvl:0];
                    
                    //Scared Blue Ghost - [7][0][187]
                    scared_blue_array = [self groupColors:&scared_blue_data colorArray:scared_blue_array rect:&scared_blue_temp x:x y:y
                                  red:red green:green blue:blue redMatch:7 greenMatch:0 blueMatch:187 logLvl:0];
                    //Scared Gray Ghost - [206][206][206] - Before ghosts go back to normal they blinky gray and blue
                    scared_gray_array = [self groupColors:&scared_gray_data colorArray:scared_gray_array rect:&scared_gray_temp x:x y:y
                                  red:red green:green blue:blue redMatch:206 greenMatch:206 blueMatch:206 logLvl:0];
                }
            }
        }
    }
    if (data) { free(data); }
    CGImageRelease(playzone);
    
    canGoUp = FALSE;
    canGoRight = FALSE;
    canGoDown = FALSE;
    canGoLeft = FALSE;
    
    if(logLevel >= 3) {
        NSLog(@"===== MsPacman =====");
    }
    for(int ms = 0; ms < [mspacman_array count]; ms++) {
        CGRect rect = [[mspacman_array objectAtIndex:ms] rectValue];
        if(rect.size.width >= 25 && rect.size.height >= 25) {
            if(ms == 0) {
                msPacman = rect;
            }
            CGRect up = CGRectMake(rect.origin.x + 8, rect.origin.y - 10, rect.size.width - 16, 5);
            CGRect right = CGRectMake(rect.origin.x + rect.size.width + 10, rect.origin.y + 8, 5, rect.size.height - 16);
            CGRect down = CGRectMake(rect.origin.x + 8, rect.origin.y + rect.size.height + 10, rect.size.width - 16, 5);
            CGRect left = CGRectMake(rect.origin.x - 10, rect.origin.y + 8, 5, rect.size.height - 16);
            
            for(int row = 0; row < [lvl1.level1Rects count]; row++) {
                NSArray* rects = [lvl1.level1Rects objectForKey:[NSString stringWithFormat:@"%d",row]];
                for (int r = 0; r < [rects count]; r++) {
                    CGRect play = [[rects objectAtIndex:r] rectValue];
                    //CGRectContainsPoint(rect, point)
                    if(CGRectContainsRect(play, up)) {
                        canGoUp = TRUE;
                    }
                    if(CGRectContainsRect(play, right)) {
                        canGoRight = TRUE;
                    }
                    if(CGRectContainsRect(play, down)) {
                        canGoDown = TRUE;
                    }
                    if(CGRectContainsRect(play, left)) {
                        canGoLeft = TRUE;
                    }
                }
            }
            
            [msPacmanHistory insertObject:[NSValue valueWithRect:rect] atIndex:0];
            [msPacmanHistory removeObjectAtIndex:history];
            
            if(logLevel >= 3) {
                NSLog(@"%d.  %d,%d,%d,%d w:%d h:%d", ms,
                      (int)rect.origin.x, (int)rect.origin.y,
                      (int)rect.origin.x + (int)rect.size.width,
                      (int)rect.origin.y + (int)rect.size.height,
                      (int)rect.size.width, (int)rect.size.height);
                NSLog(@"Up: %d - Right: %d - Down: %d - Left: %d", canGoUp, canGoRight, canGoDown, canGoLeft);
            }
            break;
        }
    }
    for(int i = 0; i < history; i++) {
        CGRect h = [[msPacmanHistory objectAtIndex:i] rectValue];
        if(logLevel >= 3) {
            NSLog(@"History: %d.  %d,%d,%d,%d w:%d h:%d", i,
                  (int)h.origin.x, (int)h.origin.y,
                  (int)h.origin.x + (int)h.size.width,
                  (int)h.origin.y + (int)h.size.height,
                  (int)h.size.width, (int)h.size.height);
        }
        [nsa addObject:[NSNumber numberWithInt:h.origin.x]];
        [nsa addObject:[NSNumber numberWithInt:h.origin.y]];
        [nsa addObject:[NSNumber numberWithInt:h.origin.x + h.size.width]];
        [nsa addObject:[NSNumber numberWithInt:h.origin.y + h.size.height]];
        //[nsa addObject:[NSNumber numberWithInt:h.origin.x]];
        //[nsa addObject:[NSNumber numberWithInt:h.origin.y]];
        //[nsa addObject:[NSNumber numberWithInt:h.size.width]];
        //[nsa addObject:[NSNumber numberWithInt:h.size.height]];
        //NSLog(@"MsPacman History: %d, %d, %d, %d", (int)h.origin.x,(int)h.origin.y,(int)h.size.width,(int)h.size.height);
    }
    [nsa addObject:[NSNumber numberWithInt:canGoUp]];
    [nsa addObject:[NSNumber numberWithInt:canGoRight]];
    [nsa addObject:[NSNumber numberWithInt:canGoDown]];
    [nsa addObject:[NSNumber numberWithInt:canGoLeft]];
    if(logLevel >= 3) {
        NSLog(@"====================");
        NSLog(@" ");
    }
    
    if(logLevel >= 3) {
        NSLog(@"===== Blinky =====");
    }
    BOOL blinky_found = FALSE;
    for(int ms = 0; ms < [blinky_array count]; ms++) {
        CGRect rect = [[blinky_array objectAtIndex:ms] rectValue];
        if(rect.size.width >= 30 && rect.size.height >= 30) {
            if(ms == 0) {
                blinky = rect;
            }
            [blinkyHistory insertObject:[NSValue valueWithRect:rect] atIndex:0];
            [blinkyHistory removeObjectAtIndex:history];
            if(logLevel >= 3) {
                NSLog(@"%d.  %d,%d,%d,%d w:%d h:%d", ms,
                      (int)rect.origin.x, (int)rect.origin.y,
                      (int)rect.origin.x + (int)rect.size.width,
                      (int)rect.origin.y + (int)rect.size.height,
                      (int)rect.size.width, (int)rect.size.height);
            }
            blinky_found = TRUE;
            //break;
        }
    }
    if(!blinky_found) {
        //Couldn't find it, insert a 0
        [blinkyHistory insertObject:[NSValue valueWithRect:CGRectZero] atIndex:0];
        [blinkyHistory removeObjectAtIndex:4];
    }
    for(int i = 0; i < history; i++) {
        CGRect h = [[blinkyHistory objectAtIndex:i] rectValue];
        if(logLevel >= 3) {
            NSLog(@"History: %d.  %d,%d,%d,%d w:%d h:%d", i,
                  (int)h.origin.x, (int)h.origin.y,
                  (int)h.origin.x + (int)h.size.width,
                  (int)h.origin.y + (int)h.size.height,
                  (int)h.size.width, (int)h.size.height);
        }
        [nsa addObject:[NSNumber numberWithInt:h.origin.x]];
        [nsa addObject:[NSNumber numberWithInt:h.origin.y]];
        [nsa addObject:[NSNumber numberWithInt:h.origin.x + h.size.width]];
        [nsa addObject:[NSNumber numberWithInt:h.origin.y + h.size.height]];
        //[nsa addObject:[NSNumber numberWithInt:h.origin.x]];
        //[nsa addObject:[NSNumber numberWithInt:h.origin.y]];
        //[nsa addObject:[NSNumber numberWithInt:h.size.width]];
        //[nsa addObject:[NSNumber numberWithInt:h.size.height]];
    }
    if(logLevel >= 3) {
        NSLog(@"====================");
        NSLog(@" ");
    }
    
    if(logLevel >= 3) {
        NSLog(@"===== Pinky =====");
    }
    for(int ms = 0; ms < [pinky_array count]; ms++) {
        CGRect rect = [[pinky_array objectAtIndex:ms] rectValue];
        if(rect.size.width >= 30 && rect.size.height >= 30) {
            if(ms == 0) {
                pinky = rect;
            }
            [pinkyHistory insertObject:[NSValue valueWithRect:rect] atIndex:0];
            [pinkyHistory removeObjectAtIndex:history];
            
            if(logLevel >= 3) {
                NSLog(@"%d.  %d,%d,%d,%d w:%d h:%d", ms,
                      (int)rect.origin.x, (int)rect.origin.y,
                      (int)rect.origin.x + (int)rect.size.width,
                      (int)rect.origin.y + (int)rect.size.height,
                      (int)rect.size.width, (int)rect.size.height);
            }
            break;
        }
    }
    for(int i = 0; i < history; i++) {
        CGRect h = [[pinkyHistory objectAtIndex:i] rectValue];
        if(logLevel >= 3) {
            NSLog(@"History: %d.  %d,%d,%d,%d w:%d h:%d", i,
                  (int)h.origin.x, (int)h.origin.y,
                  (int)h.origin.x + (int)h.size.width,
                  (int)h.origin.y + (int)h.size.height,
                  (int)h.size.width, (int)h.size.height);
        }
        [nsa addObject:[NSNumber numberWithInt:h.origin.x]];
        [nsa addObject:[NSNumber numberWithInt:h.origin.y]];
        [nsa addObject:[NSNumber numberWithInt:h.origin.x + h.size.width]];
        [nsa addObject:[NSNumber numberWithInt:h.origin.y + h.size.height]];
        //[nsa addObject:[NSNumber numberWithInt:h.origin.x]];
        //[nsa addObject:[NSNumber numberWithInt:h.origin.y]];
        //[nsa addObject:[NSNumber numberWithInt:h.size.width]];
        //[nsa addObject:[NSNumber numberWithInt:h.size.height]];
    }
    if(logLevel >= 3) {
        NSLog(@"====================");
        NSLog(@" ");
    }
    
    if(logLevel >= 3) {
        NSLog(@"===== Inky =====");
    }
    for(int ms = 0; ms < [inky_array count]; ms++) {
        CGRect rect = [[inky_array objectAtIndex:ms] rectValue];
        if(rect.size.width >= 30 && rect.size.height >= 30) {
            if(ms == 0) {
                inky = rect;
            }
            [inkyHistory insertObject:[NSValue valueWithRect:rect] atIndex:0];
            [inkyHistory removeObjectAtIndex:history];
            
            if(logLevel >= 3) {
                NSLog(@"%d.  %d,%d,%d,%d w:%d h:%d", ms,
                      (int)rect.origin.x, (int)rect.origin.y,
                      (int)rect.origin.x + (int)rect.size.width,
                      (int)rect.origin.y + (int)rect.size.height,
                      (int)rect.size.width, (int)rect.size.height);
            }
            break;
        }
    }
    for(int i = 0; i < history; i++) {
        CGRect h = [[inkyHistory objectAtIndex:i] rectValue];
        if(logLevel >= 3) {
            NSLog(@"History: %d.  %d,%d,%d,%d w:%d h:%d", i,
                  (int)h.origin.x, (int)h.origin.y,
                  (int)h.origin.x + (int)h.size.width,
                  (int)h.origin.y + (int)h.size.height,
                  (int)h.size.width, (int)h.size.height);
        }
        [nsa addObject:[NSNumber numberWithInt:h.origin.x]];
        [nsa addObject:[NSNumber numberWithInt:h.origin.y]];
        [nsa addObject:[NSNumber numberWithInt:h.origin.x + h.size.width]];
        [nsa addObject:[NSNumber numberWithInt:h.origin.y + h.size.height]];
        //[nsa addObject:[NSNumber numberWithInt:h.origin.x]];
        //[nsa addObject:[NSNumber numberWithInt:h.origin.y]];
        //[nsa addObject:[NSNumber numberWithInt:h.size.width]];
        //[nsa addObject:[NSNumber numberWithInt:h.size.height]];
    }
    if(logLevel >= 3) {
        NSLog(@"====================");
        NSLog(@" ");
    }
    
    if(logLevel >= 3) {
        NSLog(@"===== Sue =====");
    }
    for(int ms = 0; ms < [sue_array count]; ms++) {
        CGRect rect = [[sue_array objectAtIndex:ms] rectValue];
        if(rect.size.width >= 30 && rect.size.height >= 30) {
            if(ms == 0) {
                sue = rect;
            }
            [sueHistory insertObject:[NSValue valueWithRect:rect] atIndex:0];
            [sueHistory removeObjectAtIndex:history];
            
            if(logLevel >= 3) {
                NSLog(@"%d.  %d,%d,%d,%d w:%d h:%d", ms,
                      (int)rect.origin.x, (int)rect.origin.y,
                      (int)rect.origin.x + (int)rect.size.width,
                      (int)rect.origin.y + (int)rect.size.height,
                      (int)rect.size.width, (int)rect.size.height);
            }
            break;
        }
    }
    for(int i = 0; i < history; i++) {
        CGRect h = [[sueHistory objectAtIndex:i] rectValue];
        if(logLevel >= 3) {
            NSLog(@"History: %d.  %d,%d,%d,%d w:%d h:%d", i,
                  (int)h.origin.x, (int)h.origin.y,
                  (int)h.origin.x + (int)h.size.width,
                  (int)h.origin.y + (int)h.size.height,
                  (int)h.size.width, (int)h.size.height);
        }
        [nsa addObject:[NSNumber numberWithInt:h.origin.x]];
        [nsa addObject:[NSNumber numberWithInt:h.origin.y]];
        [nsa addObject:[NSNumber numberWithInt:h.origin.x + h.size.width]];
        [nsa addObject:[NSNumber numberWithInt:h.origin.y + h.size.height]];
        //[nsa addObject:[NSNumber numberWithInt:h.origin.x]];
        //[nsa addObject:[NSNumber numberWithInt:h.origin.y]];
        //[nsa addObject:[NSNumber numberWithInt:h.size.width]];
        //[nsa addObject:[NSNumber numberWithInt:h.size.height]];
    }
    if(logLevel >= 3) {
        NSLog(@"====================");
        NSLog(@" ");
    }
    
    if(logLevel >= 3) {
        NSLog(@"===== Scared Blue Ghosts =====");
    }
    for(int ms = 0; ms < [scared_blue_array count]; ms++) {
        CGRect rect = [[scared_blue_array objectAtIndex:ms] rectValue];
        if(rect.size.width >= 30 && rect.size.height >= 30) {
            [scaredGhostHistory insertObject:[NSValue valueWithRect:rect] atIndex:0];
            [scaredGhostHistory removeObjectAtIndex:(history * 4)];
            
            if(logLevel >= 3) {
                NSLog(@"%d.  %d,%d,%d,%d w:%d h:%d", ms,
                      (int)rect.origin.x, (int)rect.origin.y,
                      (int)rect.origin.x + (int)rect.size.width,
                      (int)rect.origin.y + (int)rect.size.height,
                      (int)rect.size.width, (int)rect.size.height);
            }
        }
    }
    if(logLevel >= 3) {
        NSLog(@"====================");
        NSLog(@" ");
    }
    
    if(logLevel >= 3) {
        NSLog(@"===== Scared Gray Ghosts =====");
    }
    for(int ms = 0; ms < [scared_gray_array count]; ms++) {
        CGRect rect = [[scared_gray_array objectAtIndex:ms] rectValue];
        if(rect.size.width >= 30 && rect.size.height >= 30) {
            [scaredGhostHistory insertObject:[NSValue valueWithRect:rect] atIndex:0];
            [scaredGhostHistory removeObjectAtIndex:(history * 4)];
            
            if(logLevel >= 3) {
                NSLog(@"%d.  %d,%d,%d,%d w:%d h:%d", ms,
                      (int)rect.origin.x, (int)rect.origin.y,
                      (int)rect.origin.x + (int)rect.size.width,
                      (int)rect.origin.y + (int)rect.size.height,
                      (int)rect.size.width, (int)rect.size.height);
            }
        }
    }
    if(logLevel >= 3) {
        NSLog(@"====================");
        NSLog(@" ");
    }
    
    if(logLevel >= 3) {
        NSLog(@"===== Ghosts =====");
    }
    for(int i = 0; i < (history * 4); i++) {
        CGRect h = [[scaredGhostHistory objectAtIndex:i] rectValue];
        if(logLevel >= 3) {
            NSLog(@"History: %d.  %d,%d,%d,%d w:%d h:%d", i,
                  (int)h.origin.x, (int)h.origin.y,
                  (int)h.origin.x + (int)h.size.width,
                  (int)h.origin.y + (int)h.size.height,
                  (int)h.size.width, (int)h.size.height);
        }
        [nsa addObject:[NSNumber numberWithInt:h.origin.x]];
        [nsa addObject:[NSNumber numberWithInt:h.origin.y]];
        [nsa addObject:[NSNumber numberWithInt:h.origin.x + h.size.width]];
        [nsa addObject:[NSNumber numberWithInt:h.origin.y + h.size.height]];
        //[nsa addObject:[NSNumber numberWithInt:h.origin.x]];
        //[nsa addObject:[NSNumber numberWithInt:h.origin.y]];
        //[nsa addObject:[NSNumber numberWithInt:h.size.width]];
        //[nsa addObject:[NSNumber numberWithInt:h.size.height]];
    }
    if(logLevel >= 3) {
        NSLog(@"====================");
        NSLog(@" ");
    }
    /*
    for(int c = 0; c < [lvl1.level1Pellets count]; c++) {
        CGRect rect = [[lvl1.level1Pellets objectAtIndex:c] rectValue];
        int x = CGRectGetMidX(rect);
        int y = CGRectGetMidY(rect);
        
        int offset = 4 * ((width * y) + round(x));
        int red   = data[offset + 1];
        int green = data[offset + 2];
        int blue  = data[offset + 3];
        
        //Pellet - [0][167][255]
        if (red == 0 && green == 167 && blue == 255) {
            [nsa addObject:[NSNumber numberWithInt:1]];
        } else {
            [nsa addObject:[NSNumber numberWithInt:0]];
        }
    }
    */
    
    if([nsa count] < expectedInputCount || logLevel >= 3) {
        NSLog(@"MsPacman :: getInputValues :: input value count: %lu", (unsigned long)[nsa count]);
    }
    
    return nsa;
}

-(void) saveScreenshot: (CGImageRef) screenshot filename: (NSString*) filename number: (NSString*) num {
    NSString *path = @"/Users/murphycrosby/Misc/Results-1/";
    NSString *type = @".png";
    
    NSString *dest = [NSString stringWithFormat:@"%@%@%@%@", path, filename, num, type];
    CFURLRef url = (__bridge CFURLRef)[NSURL fileURLWithPath:dest];
    
    CGImageDestinationRef destination = CGImageDestinationCreateWithURL(url, kUTTypePNG, 1, NULL);
    if (!destination && logLevel >= 2) {
        NSLog(@"MsPacman :: saveScreenshot :: Failed to create CGImageDestination for %@", path);
    } else {
        CGImageDestinationAddImage(destination, screenshot, nil);
        if (!CGImageDestinationFinalize(destination) && logLevel >= 2) {
            NSLog(@"MsPacman :: saveScreenshot :: Failed to write image to %@", path);
        }
    }
    CFRelease(destination);
}

-(void) saveScreenshotToArray: (unsigned char*) data width:(size_t) width height:(size_t) height filename:(NSString*) filename displayPixels:(BOOL) displayPixels {
    NSString* dataArray = @"";
    
    for(int row = 0; row < height; row++) {
        for(int x = 0; x < width; x++) {
            int offset = 4 * ((width * row) + round(x));
            //int alpha = data[offset];
            int red   = data[offset + 1];
            int green = data[offset + 2];
            int blue  = data[offset + 3];
            
            if(displayPixels) {
                NSLog(@"XY: [%i,%i], RGB: [%d][%d][%d]",x,row,red,green,blue);
            }
            
            NSString* str;
            if(row == 0 && x == 0) {
                str = [NSString stringWithFormat:@"%d,%d,%d", red, green, blue];
            } else {
                str = [NSString stringWithFormat:@",%d,%d,%d", red, green, blue];
            }
            dataArray = [dataArray stringByAppendingString:str];
        }
    }
    
    NSString* path = @"/Users/murphycrosby/Misc/Results-1/";
    path = [path stringByAppendingString:filename];
    
    [[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil];
    [dataArray writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

-(unsigned char*) getArrayFromImage: (CGImageRef) imageRef {
    size_t width = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    size_t bitsPerComponent = CGImageGetBitsPerComponent(imageRef);
    size_t bitmapBytesPerRow = (width * 4);
    size_t bitmapByteCount = (bitmapBytesPerRow * height);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);
    void* bitmapData = malloc( bitmapByteCount );
    
    CGContextRef context = CGBitmapContextCreate (bitmapData,
                                                  width,
                                                  height,
                                                  bitsPerComponent,
                                                  bitmapBytesPerRow,
                                                  colorSpace,
                                                  kCGImageAlphaPremultipliedFirst);
    
    CGRect rect = CGRectMake(0, 0, width, height);
    CGContextDrawImage(context, rect, imageRef);
    
    unsigned char* data = CGBitmapContextGetData (context);
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    return data;
}

-(CGImageRef) resizeImage:(CGImageRef) imageRef newWidth:(size_t) newWidth newHeight:(size_t) newHeigth {
    CGColorSpaceRef colorspace = CGImageGetColorSpace(imageRef);
    
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 newWidth,
                                                 newHeigth,
                                                 CGImageGetBitsPerComponent(imageRef),
                                                 CGImageGetBytesPerRow(imageRef)/CGImageGetWidth(imageRef)*newWidth,
                                                 colorspace,
                                                 CGImageGetAlphaInfo(imageRef));
    
    if(context == NULL)
        return nil;
    
    CGContextDrawImage(context, CGContextGetClipBoundingBox(context), imageRef);
    CGImageRef newImgRef = CGBitmapContextCreateImage(context);
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorspace);
    
    return newImgRef;
}

-(NSMutableArray*) groupColors:(BOOL*) data colorArray: (NSMutableArray*) colorArray rect:(CGRect*) rect
                  x:(int) x y: (int) y
                red:(int) red green:(int) green blue:(int) blue
           redMatch:(int) redMatch greenMatch:(int) greenMatch blueMatch:(int) blueMatch
             logLvl:(int) logLvl {

    BOOL log = FALSE;
    if(logLvl >= 4) {
        log = TRUE;
    }
    NSMutableArray* combinedColorArray = nil;
    
    if(red == redMatch && green == greenMatch && blue == blueMatch && *data == FALSE) {
        *data = TRUE;
        if (CGRectIsEmpty(*rect)) {
            *rect = CGRectMake(x, y, 1, 1);
        }
        if((rect->origin.x + rect->size.width) == x) {
            rect->size.width++;
        }
        if((rect->origin.y + rect->size.height) == y) {
            rect->size.height++;
        }
        if(log) {
            NSLog(@"groupColors :: In if");
        }
    } else if (red == redMatch && green == greenMatch && blue == blueMatch && *data == TRUE) {
        if (rect->size.width < (x - rect->origin.x)) {
            rect->size.width = x - rect->origin.x;
        }
        if (rect->size.height < (y - rect->origin.y)) {
            rect->size.height = y - rect->origin.y;
        }

        if(log) {
            NSLog(@"Increasing: %f,%f,%f,%f w:%f h:%f",
                  rect->origin.x, rect->origin.y,
                  rect->origin.x + rect->size.width,
                  rect->origin.y + rect->size.height,
                  rect->size.width, rect->size.height);
        }
    } else if (*data == TRUE) {
        *data = FALSE;
        BOOL contiguous = FALSE;

        if(log) {
            NSLog(@" ");
            NSLog(@"[%d,%d]", x,y);
            NSLog(@"    Rect: %f,%f,%f,%f w:%f h:%f",
                  rect->origin.x, rect->origin.y,
                  rect->origin.x + rect->size.width,
                  rect->origin.y + rect->size.height,
                  rect->size.width, rect->size.height);
        }

        for (int p = 0; p < [colorArray count]; p++) {
            CGRect t = [[colorArray objectAtIndex:p] rectValue];
      
            if(log) {
                NSLog(@"%d - Rect: %f,%f,%f,%f w:%f h:%f", p,
                      t.origin.x, t.origin.y,
                      t.origin.x + t.size.width,
                      t.origin.y + t.size.height,
                      t.size.width, t.size.height);
            }
            
            CGRect un = CGRectUnion(t, *rect);
            if((un.size.width <= t.size.width + rect->size.width && un.size.height < t.size.height + rect->size.height)
               || (un.size.width < t.size.width + rect->size.width && un.size.height <= t.size.height + rect->size.height)) {
                //Contiguous on the x or y axis
                contiguous = TRUE;
                
                t = CGRectUnion(t, *rect);
         
                if(log) {
                    NSLog(@"Contiguous");
                    NSLog(@"New Rect: %f,%f,%f,%f w:%f h:%f",
                          t.origin.x, t.origin.y,
                          t.origin.x + t.size.width,
                          t.origin.y + t.size.height,
                          t.size.width, t.size.height);
                }
         
                [colorArray replaceObjectAtIndex:p withObject:[NSValue valueWithRect:t]];
                break;
            }
        }
        if (contiguous == FALSE) {
            if(log) {
                NSLog(@"Adding");
            }
            [colorArray addObject:[NSValue valueWithRect:*rect]];
        } else {
            //Can we combine other rects?
            if(log) {
                NSLog(@" ");
                NSLog(@"In Combine Check: %lu",(unsigned long)[colorArray count]);
            }
            combinedColorArray = [[NSMutableArray alloc] init];
            for (int p = 0; p < [colorArray count]; p++) {
                CGRect check = [[colorArray objectAtIndex:p] rectValue];
                if(log) {
                    NSLog(@"Check: %f,%f,%f,%f w:%f h:%f",
                          check.origin.x, check.origin.y,
                          check.origin.x + check.size.width,
                          check.origin.y + check.size.height,
                          check.size.width, check.size.height);
                }
                
                if(p == 0) {
                    if(log) {
                        NSLog(@"Combining Add");
                    }
                    [combinedColorArray addObject:[NSValue valueWithRect:check]];
                } else {
                    int iters = (int)[combinedColorArray count];
                    BOOL addRect = TRUE;
                    for (int p2 = 0; p2 < iters; p2++) {
                        CGRect t = [[combinedColorArray objectAtIndex:p2] rectValue];
                        if(log) {
                            NSLog(@"Rect check with %d: %f,%f,%f,%f w:%f h:%f", p2,
                                  t.origin.x, t.origin.y,
                                  t.origin.x + t.size.width,
                                  t.origin.y + t.size.height,
                                  t.size.width, t.size.height);
                        }
                        
                        CGRect un = CGRectUnion(t, check);
                        if(log) {
                            NSLog(@"Rect Union: %d,%d,%d,%d w:%d h:%d",
                                  (int)un.origin.x, (int)un.origin.y,
                                  (int)un.origin.x + (int)un.size.width,
                                  (int)un.origin.y + (int)un.size.height,
                                  (int)un.size.width, (int)un.size.height);
                        }
                        if((un.size.width <= t.size.width + check.size.width && un.size.height < t.size.height + check.size.height)
                           || (un.size.width < t.size.width + check.size.width && un.size.height <= t.size.height + check.size.height)) {
                            //Yup it's contiguous, union and replace
                            if(log) {
                                NSLog(@"Combining check and rect");
                            }
                            addRect = FALSE;
                            [combinedColorArray replaceObjectAtIndex:p2 withObject:[NSValue valueWithRect:un]];
                        }
                    }
                    if(addRect) {
                        //Nope, not contiguous, add it back in
                        if(log) {
                            NSLog(@"Adding Check");
                        }
                        [combinedColorArray addObject:[NSValue valueWithRect:check]];
                    }
                }
                if(log) {
                    NSLog(@" ");
                }
            }
            if(log) {
                NSLog(@"New Color Array: %lu", (unsigned long)[combinedColorArray count]);
                NSLog(@"Color Array: %lu", (unsigned long)[colorArray count]);
                NSLog(@" ");
            }
        }
        *rect = CGRectNull;
    }
    
    if (combinedColorArray) {
        return combinedColorArray;
    } else {
        return colorArray;
    }
}

@end


/*
 CGColorSpaceRef colorSpace = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);
 CGContextRef context = CGBitmapContextCreate (NULL,
 width,
 height,
 CGImageGetBitsPerComponent(playzone),
 (width * 4),
 colorSpace,
 kCGImageAlphaPremultipliedFirst);
 
 CGContextSetRGBFillColor(context, 0.0, 200.0, 0.0, 1.0);
 CGContextSetRGBStrokeColor(context, 0.0, 73.0, 255.0, 1.0);
 CGContextFillRect(context, rect);
 
 CGContextTranslateCTM(context, 0, height);
 CGContextScaleCTM(context, 1.0, -1.0);
 CGImageRef newImgRef = CGBitmapContextCreateImage(context);
 [self saveScreenshot:newImgRef filename:@"newImg" number:69];
 CGContextRelease(context);
 CGColorSpaceRelease(colorSpace);
*/
