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

@synthesize logLevel;

- (id)init: (int) logLvl {
    self = [super init];
    if (!self) {
        return self;
    }
    
    lvl1 = [[Level1 alloc] init: logLvl];
    mspacman = CGRectNull;
    inky = CGRectNull;
    blinky = CGRectNull;
    pinky = CGRectNull;
    sue = CGRectNull;
    
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
    /*
    CGRect rect = CGRectMake(185, 160, 220, 25);
    CGImageRef imageRef = CGImageCreateWithImageInRect(screenshot, rect);
    [self saveScreenshot:imageRef number:5];
    CGImageRelease(imageRef);
    */
    
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
    
        /*
        NSLog(@"pix1: [%d,%d,%d]",data[(4*((width*4)+15))+1],data[(4*((width*4)+15))+2],data[(4*((width*4)+15))+3]);
        NSLog(@"pix2: [%d,%d,%d]",data[(4*((width*8)+7))+1],data[(4*((width*8)+7))+2],data[(4*((width*8)+7))+3]);
        NSLog(@"pix3: [%d,%d,%d]",data[(4*((width*8)+22))+1],data[(4*((width*8)+22))+2],data[(4*((width*8)+22))+3]);
        NSLog(@"pix4: [%d,%d,%d]",data[(4*((width*12)+7))+1],data[(4*((width*12)+7))+2],data[(4*((width*12)+7))+3]);
        NSLog(@"pix5: [%d,%d,%d]",data[(4*((width*12)+15))+1],data[(4*((width*12)+15))+2],data[(4*((width*12)+15))+3]);
        NSLog(@"pix6: [%d,%d,%d]",data[(4*((width*12)+22))+1],data[(4*((width*12)+22))+2],data[(4*((width*12)+22))+3]);
        NSLog(@"pix7: [%d,%d,%d]",data[(4*((width*15)+7))+1],data[(4*((width*15)+7))+2],data[(4*((width*15)+7))+3]);
        NSLog(@"pix8: [%d,%d,%d]",data[(4*((width*15)+22))+1],data[(4*((width*15)+22))+2],data[(4*((width*15)+22))+3]);
        NSLog(@"pix9: [%d,%d,%d]",data[(4*((width*19)+15))+1],data[(4*((width*19)+15))+2],data[(4*((width*19)+15))+3]);
        */
        
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
    NSMutableArray* nsa = [[NSMutableArray alloc] init];
    
    CGRect rect = CGRectMake(185, 185, 865, 695);
    CGImageRef playzone = CGImageCreateWithImageInRect(screenshot, rect);
    
    [self saveScreenshot:playzone filename:@"playzone" number:69];
    
    //MSPacman - [255,255,0]
    //Blue ghost - [73][248][255]
    //Dark Pink Ghost - [224][42][172]
    //Light Pink Ghost - [255][145][233]
    //Yellow Ghost - [255][170][0]
    //Pellet - [0][167][255]
    //Scared Ghost - [7][0][187]
    
    CGRect scaredGhost1 = CGRectMake(1000, 1000, 0, 0);
    CGRect scaredGhost2 = CGRectMake(1000, 1000, 0, 0);
    CGRect scaredGhost3 = CGRectMake(1000, 1000, 0, 0);
    CGRect scaredGhost4 = CGRectMake(1000, 1000, 0, 0);
    
    size_t width = CGImageGetWidth(playzone);
    size_t height = CGImageGetHeight(playzone);
    
    unsigned char* data = [self getArrayFromImage:playzone];
    
    NSMutableArray* mspacman_array = [[NSMutableArray alloc] init];
    NSMutableArray* blinky_array = [[NSMutableArray alloc] init];
    
    for(int row = 0; row < [lvl1.level1Rects count]; row++) {
        NSArray* rects = [lvl1.level1Rects objectForKey:[NSString stringWithFormat:@"%d",row]];
        
        for (int r = 0; r < [rects count]; r++) {
            CGRect rect = [[rects objectAtIndex:r] rectValue];
            
            //CGRect* scared_ghost = NULL;
            //CGRect inky_temp = CGRectMake(1000, 1000, 0, 0);
            //CGRect pinky_temp = CGRectMake(1000, 1000, 0, 0);
            //CGRect scaredghost_temp = CGRectMake(1000, 1000, 0, 0);
            
            /*
            if(scaredGhost1.origin.x == 1000 && scaredGhost1.origin.y == 1000) {
                scared_ghost = &scaredGhost1;
            } else if(scaredGhost2.origin.x == 1000 && scaredGhost2.origin.y == 1000) {
                scared_ghost = &scaredGhost2;
            } else if(scaredGhost3.origin.x == 1000 && scaredGhost3.origin.y == 1000) {
                scared_ghost = &scaredGhost3;
            } else if(scaredGhost4.origin.x == 1000 && scaredGhost4.origin.y == 1000) {
                scared_ghost = &scaredGhost4;
            } else {
                scared_ghost = NULL;
            }
            */
            
            for(int y = rect.origin.y; y < (rect.origin.y + rect.size.height); y++) {
                CGRect mspacman_temp = CGRectNull;
                CGRect blinky_temp = CGRectNull;
                
                BOOL mspacman_data = FALSE;
                BOOL blinky_data = FALSE;
                BOOL inky_data = FALSE;
                BOOL pinky_data = FALSE;
                BOOL sue_data = FALSE;
                BOOL scaredghost_data = FALSE;
                
                for(int x = rect.origin.x; x < (rect.origin.x + rect.size.width); x++) {
                    int offset = 4 * ((width * y) + round(x));
                    int red   = data[offset + 1];
                    int green = data[offset + 2];
                    int blue  = data[offset + 3];
                    
                    if(red == 255 && green == 255 && blue == 0 && mspacman_data == FALSE) {
                        //MSPacman - [255,255,0]
                        mspacman_data = TRUE;
                        if (CGRectIsEmpty(mspacman_temp)) {
                            mspacman_temp = CGRectMake(x, y, 1, 1);
                        } else if((mspacman_temp.origin.x + mspacman_temp.size.width) == x) {
                            mspacman_temp.size.width++;
                        } else if((mspacman_temp.origin.y + mspacman_temp.size.height) == y) {
                            mspacman_temp.size.height++;
                        }
                    } else if (red == 255 && green == 255 && blue == 0 && mspacman_data == TRUE) {
                        if (mspacman_temp.size.width < (x - mspacman_temp.origin.x)) {
                            mspacman_temp.size.width = x - mspacman_temp.origin.x;
                        }
                        if (mspacman_temp.size.height < (y - mspacman_temp.origin.y)) {
                            mspacman_temp.size.height = y - mspacman_temp.origin.y;
                        }
                    } else if (mspacman_data == TRUE) {
                        mspacman_data = FALSE;
                        BOOL contiguous = FALSE;
                        
                        for (int p = 0; p < [mspacman_array count]; p++) {
                            CGRect t = [[mspacman_array objectAtIndex:p] rectValue];
                            
                            if (t.origin.x + t.size.width == mspacman_temp.origin.x
                                || t.origin.y + t.size.height == mspacman_temp.origin.y) {
                                //Contiguous on the x or y axis
                                contiguous = TRUE;
                                t = CGRectUnion(t, mspacman_temp);
                                
                                BOOL intersect = FALSE;
                                for (int p2 = 0; p2 < [mspacman_array count]; p2++) {
                                    if (p == p2) {
                                        continue;
                                    }
                                    CGRect check = [[mspacman_array objectAtIndex:p] rectValue];
                                    if (CGRectIntersectsRect(check, t)) {
                                        intersect = TRUE;
                                        check = CGRectUnion(check, t);
                                        [mspacman_array replaceObjectAtIndex:p2 withObject:[NSValue valueWithRect:check]];
                                        [mspacman_array removeObjectAtIndex:p];
                                        break;
                                    }
                                }
                                if(intersect == FALSE) {
                                    [mspacman_array replaceObjectAtIndex:p withObject:[NSValue valueWithRect:t]];
                                }
                                
                                break;
                            }
                        }
                        if (contiguous == FALSE) {
                            [mspacman_array addObject:[NSValue valueWithRect:mspacman_temp]];
                        }
                        mspacman_temp = CGRectNull;
                    }
                    
                    //Blinky
                    if(red == 224 && green == 42 && blue == 172) {
                        //Dark Pink Ghost - [224][42][172]
                        blinky_data = TRUE;
                        if (CGRectIsEmpty(blinky_temp)) {
                            blinky_temp = CGRectMake(x, y, 1, 1);
                        } else if((blinky_temp.origin.x + blinky_temp.size.width) == x) {
                            blinky_temp.size.width++;
                        } else if((blinky_temp.origin.y + blinky_temp.size.height) == y) {
                            blinky_temp.size.height++;
                        }
                    } else if (red == 224 && green == 42 && blue == 172 && blinky_data == TRUE) {
                        if (blinky_temp.size.width < (x - blinky_temp.origin.x)) {
                            blinky_temp.size.width = x - blinky_temp.origin.x;
                        }
                        if (blinky_temp.size.height < (y - blinky_temp.origin.y)) {
                            blinky_temp.size.height = y - blinky_temp.origin.y;
                        }
                    } else if (blinky_data == TRUE) {
                        blinky_data = FALSE;
                        BOOL contiguous = FALSE;
                        
                        NSLog(@" ");
                        NSLog(@"    Rect: %f,%f,%f,%f w:%f h:%f",
                              blinky_temp.origin.x, blinky_temp.origin.y,
                              blinky_temp.origin.x + blinky_temp.size.width,
                              blinky_temp.origin.y + blinky_temp.size.height,
                              blinky_temp.size.width, blinky_temp.size.height);
                        
                        for (int p = 0; p < [blinky_array count]; p++) {
                            CGRect t = [[blinky_array objectAtIndex:p] rectValue];
                            
                            NSLog(@"%d - Rect: %f,%f,%f,%f w:%f h:%f", p,
                                  t.origin.x, t.origin.y,
                                  t.origin.x + t.size.width,
                                  t.origin.y + t.size.height,
                                  t.size.width, t.size.height);
                            
                            if (t.origin.x + t.size.width == blinky_temp.origin.x
                                || t.origin.y + t.size.height == blinky_temp.origin.y
                                || CGRectIntersectsRect(t, blinky_temp)) {
                                //Contiguous on the x or y axis
                                NSLog(@"Contiguous");
                                
                                contiguous = TRUE;
                                t = CGRectUnion(t, blinky_temp);
                                NSLog(@"New Rect: %f,%f,%f,%f w:%f h:%f",
                                      t.origin.x, t.origin.y,
                                      t.origin.x + t.size.width,
                                      t.origin.y + t.size.height,
                                      t.size.width, t.size.height);
                                [blinky_array replaceObjectAtIndex:p withObject:[NSValue valueWithRect:t]];
                                break;
                            }
                        }
                        if (contiguous == FALSE) {
                            NSLog(@"Adding");
                            [blinky_array addObject:[NSValue valueWithRect:blinky_temp]];
                        } else {
                            for (int p = 0; p < [blinky_array count]; p++) {
                                CGRect check = [[blinky_array objectAtIndex:p] rectValue];
                                
                                for (int p2 = 0; p2 < [blinky_array count]; p2++) {
                                    if(p == p2) {
                                        continue;
                                    }
                                    CGRect t = [[blinky_array objectAtIndex:p2] rectValue];
                                    if (CGRectIntersectsRect(check, t)) {
                                        CGRect n = CGRectUnion(check, t);
                                        [blinky_array replaceObjectAtIndex:p withObject:[NSValue valueWithRect:n]];
                                        [blinky_array removeObject:[NSValue valueWithRect:t]];
                                        break;
                                    }
                                }
                            }
                        }
                        blinky_temp = CGRectNull;
                    }
                    
                    if(red == 73 && green == 248 && blue == 255) {
                        //Inky - [73][248][255]
                        inky_data = TRUE;
                    }
                    
                    if(red == 255 && green == 145 && blue == 233) {
                        //Light Pink Ghost - [255][145][233]
                        pinky_data = TRUE;
                    }
                    if(red == 255 && green == 170 && blue == 0) {
                        //Orange Ghost - [255][170][0]
                        sue_data = TRUE;
                    }
                    if((red == 7 && green == 0 && blue == 187)
                       || (red == 206 && green == 206 && blue == 206)){
                        //Scared Ghost - [7][0][187]
                        scaredghost_data = TRUE;
                    }
                    
                    //if(row == 6 || row == 7) {
                    //    NSLog(@"Row: %d, (%d,%d) [%d][%d][%d]", row,x,y,red,green,blue);
                    //}
                    
                    /*
                     if(red == 255 && green == 255 && blue == 0) {
                         //MSPacman - [255,255,0]
                         mspacman_data = TRUE;
                         if(x < mspacman.origin.x) {
                            mspacman.origin.x = x;
                         }
                         if(y < mspacman.origin.y) {
                            mspacman.origin.y = y;
                         }
                         if(mspacman.size.width < (x - mspacman.origin.x)) {
                            mspacman.size.width = x - mspacman.origin.x;
                         }
                         if(mspacman.size.height < (y - mspacman.origin.y)) {
                            mspacman.size.height = y - mspacman.origin.y;
                         }
                     }
                     
                    if(red == 73 && green == 248 && blue == 255) {
                        //Blue ghost - [73][248][255]
                        inky_data = TRUE;
                        if(x < inky.origin.x) {
                            inky.origin.x = x;
                        }
                        if(y < inky.origin.y) {
                            inky.origin.y = y;
                        }
                        if(inky.size.width < (x - inky.origin.x)) {
                            inky.size.width = x - inky.origin.x;
                        }
                        if(inky.size.height < (y - inky.origin.y)) {
                            inky.size.height = y - inky.origin.y;
                        }
                    }
                    
                    if(red == 224 && green == 42 && blue == 172) {
                        //Dark Pink Ghost - [224][42][172]
                        blinky_data = TRUE;
                        if(x < blinky_temp.origin.x) {
                            blinky_temp.origin.x = x;
                        }
                        if(y < blinky_temp.origin.y) {
                            blinky_temp.origin.y = y;
                        }
                        if(blinky_temp.size.width < (x - blinky_temp.origin.x)) {
                            blinky_temp.size.width = x - blinky_temp.origin.x;
                        }
                        if(blinky_temp.size.height < (y - blinky_temp.origin.y)) {
                            blinky_temp.size.height = y - blinky_temp.origin.y;
                        }
                    }
                    
                    if(red == 255 && green == 145 && blue == 233) {
                        //Light Pink Ghost - [255][145][233]
                        pinky_data = TRUE;
                        if(x < pinky_temp.origin.x) {
                            pinky_temp.origin.x = x;
                        }
                        if(y < pinky_temp.origin.y) {
                            pinky_temp.origin.y = y;
                        }
                        if(pinky_temp.size.width < (x - pinky_temp.origin.x)) {
                            pinky_temp.size.width = x - pinky_temp.origin.x;
                        }
                        if(pinky_temp.size.height < (y - pinky_temp.origin.y)) {
                            pinky_temp.size.height = y - pinky_temp.origin.y;
                        }
                    }
                    
                    if(red == 255 && green == 170 && blue == 0) {
                        //Orange Ghost - [255][170][0]
                        sue_data = TRUE;
                        if(x < sue.origin.x) {
                            sue.origin.x = x;
                        }
                        if(y < sue.origin.y) {
                            sue.origin.y = y;
                        }
                        if(sue.size.width < (x - sue.origin.x)) {
                            sue.size.width = x - sue.origin.x;
                        }
                        if(sue.size.height < (y - sue.origin.y)) {
                            sue.size.height = y - sue.origin.y;
                        }
                    }
                    
                    if((red == 7 && green == 0 && blue == 187)
                       || (red == 206 && green == 206 && blue == 206)){
                        //Scared Ghost - [7][0][187]
                        scaredghost_data = TRUE;
                        
                        if(scared_ghost != NULL) {
                            if(x < scaredghost_temp.origin.x) {
                                scaredghost_temp.origin.x = x;
                            }
                            if(y < scaredghost_temp.origin.y) {
                                scaredghost_temp.origin.y = y;
                            }
                            if(scaredghost_temp.size.width < (x - scaredghost_temp.origin.x)) {
                                scaredghost_temp.size.width = x - scaredghost_temp.origin.x;
                            }
                            if(scaredghost_temp.size.height < (y - scaredghost_temp.origin.y)) {
                                scaredghost_temp.size.height = y - scaredghost_temp.origin.y;
                            }
                        }
                    }
                    */
                }
            }
            
            //if(scaredghost_data == TRUE || blinky_data == TRUE) {
            //    NSLog(@"ROW: %d scaredghost_data: %i", row, scaredghost_data);
            //    NSLog(@"ROW: %d      blinky_data: %i", row, blinky_data);
            //}
            
            /*
            //Have to do this because MsPacman has the same pink color as Blinky in her bow
            if((mspacman_data == FALSE && blinky_data == TRUE)
               && (scaredghost_data == FALSE && blinky_data == TRUE)) {
                if(blinky_temp.origin.x < blinky.origin.x) {
                    blinky.origin.x = blinky_temp.origin.x;
                }
                if(blinky_temp.origin.y < blinky.origin.y) {
                    blinky.origin.y = blinky_temp.origin.y;
                }
                if(blinky.size.width < blinky_temp.size.width) {
                    blinky.size.width = blinky_temp.size.width;
                }
                if(blinky.size.height < blinky_temp.size.height) {
                    blinky.size.height = blinky_temp.size.height;
                }
            }
            
            if(scaredghost_data == FALSE && pinky_data == TRUE) {
                //NSLog(@"Row: %d - %f,%f,%f,%f",row, rect.origin.x,rect.origin.y,rect.size.width,rect.size.height);
                if(pinky_temp.origin.x < pinky.origin.x) {
                    pinky.origin.x = pinky_temp.origin.x;
                }
                if(pinky_temp.origin.y < pinky.origin.y) {
                    pinky.origin.y = pinky_temp.origin.y;
                }
                if(pinky.size.width < pinky_temp.size.width) {
                    pinky.size.width = pinky_temp.size.width;
                }
                if(pinky.size.height < pinky_temp.size.height) {
                    pinky.size.height = pinky_temp.size.height;
                }
            }
            */
        }
    }
    
    NSLog(@" ");
    for(int ms = 0; ms < [mspacman_array count]; ms++) {
        CGRect rect = [[mspacman_array objectAtIndex:ms] rectValue];
        NSLog(@"%d. MsPacman: %f,%f,%f,%f w:%f h:%f", ms,
              rect.origin.x, rect.origin.y,
              rect.origin.x+rect.size.width,
              rect.origin.y+rect.size.height,
              rect.size.width,rect.size.height);
    }
    for(int ms = 0; ms < [blinky_array count]; ms++) {
        CGRect rect = [[blinky_array objectAtIndex:ms] rectValue];
        NSLog(@"%d. Blinky: %f,%f,%f,%f w:%f h:%f", ms,
              rect.origin.x, rect.origin.y,
              rect.origin.x+rect.size.width,
              rect.origin.y+rect.size.height,
              rect.size.width,rect.size.height);
    }
    /*
    NSLog(@"MsPacman: %f,%f,%f,%f w:%f h:%f",
          mspacman.origin.x, mspacman.origin.y,
          mspacman.origin.x+mspacman.size.width,
          mspacman.origin.y+mspacman.size.height,
          mspacman.size.width,mspacman.size.height);
    NSLog(@"Inky: %f,%f,%f,%f w:%f h:%f",
          inky.origin.x, inky.origin.y,
          inky.origin.x+inky.size.width,
          inky.origin.y+inky.size.height,
          inky.size.width, inky.size.height);
    NSLog(@"Blinky: %f,%f,%f,%f w:%f h:%f",
          blinky.origin.x, blinky.origin.y,
          blinky.origin.x+blinky.size.width,
          blinky.origin.y+blinky.size.height,
          blinky.size.width,blinky.size.height);
    NSLog(@"Sue: %f,%f,%f,%f w:%f h:%f",
          sue.origin.x, sue.origin.y,
          sue.origin.x+sue.size.width,
          sue.origin.y+sue.size.height,
          sue.size.width,sue.size.height);
    NSLog(@"Pinky: %f,%f,%f,%f w:%f h:%f",
          pinky.origin.x,pinky.origin.y,
          pinky.origin.x+pinky.size.width,
          pinky.origin.y+pinky.size.height,
          pinky.size.width, pinky.size.height);
    NSLog(@"scared Ghost 1: %f,%f,%f,%f w:%f h:%f",
          scaredGhost1.origin.x,scaredGhost1.origin.y,
          scaredGhost1.origin.x+scaredGhost1.size.width,
          scaredGhost1.origin.y+scaredGhost1.size.height,
          scaredGhost1.size.width, scaredGhost1.size.height);
    NSLog(@"scared Ghost 2: %f,%f,%f,%f w:%f h:%f",
          scaredGhost2.origin.x,scaredGhost2.origin.y,
          scaredGhost2.origin.x+scaredGhost2.size.width,
          scaredGhost2.origin.y+scaredGhost2.size.height,
          scaredGhost2.size.width, scaredGhost2.size.height);
    NSLog(@"scared Ghost 3: %f,%f,%f,%f w:%f h:%f",
          scaredGhost3.origin.x,scaredGhost3.origin.y,
          scaredGhost3.origin.x+scaredGhost3.size.width,
          scaredGhost3.origin.y+scaredGhost3.size.height,
          scaredGhost3.size.width, scaredGhost3.size.height);
    NSLog(@"scared Ghost 4: %f,%f,%f,%f w:%f h:%f",
          scaredGhost4.origin.x,scaredGhost4.origin.y,
          scaredGhost4.origin.x+scaredGhost4.size.width,
          scaredGhost4.origin.y+scaredGhost4.size.height,
          scaredGhost4.size.width, scaredGhost4.size.height);
    */
    
    //NSLog(@"MsPacman center: [%f,%f]",round(mspacman.origin.x + (mspacman.size.width / 2)), round(mspacman.origin.y + (mspacman.size.height / 2)));
    /*
    for(int row = 0; row < height; row++) {
        if (row >= 30 && row <= 39) {
            lvl1_row = 1;
        }
        
        if(lvl1_row > 0) {
            for(int x = 0; x < width; x++) {
                int offset = 4 * ((width * row) + round(x));
                int red   = data[offset + 1];
                int green = data[offset + 2];
                int blue  = data[offset + 3];
                
                //NSLog(@"row: %d - [%d][%d][%d]", row, red, green, blue);
                if(red != 0 || green != 0 || blue != 0) {
                    //NSLog(@"row: %d x: %d - 1", row, x);
                    if(on == FALSE) {
                        //NSLog(@"row: %d x: %d - 2", row, x);
                        start = x;
                        on = TRUE;
                    }
                } else {
                    //NSLog(@"row: %d x: %d - 3", row, x);
                    if(on == TRUE) {
                        stop = x - 1;
                        NSLog(@"Stuff: [%d,%d] = %d, ", start, stop, stop - start);
                        on = FALSE;
                        start = 0;
                        stop = 0;
                    }
                }
            }
        }
    }
    */
    if (data) { free(data); }
    CGImageRelease(playzone);
    
    return nsa;
}

-(void) saveScreenshot: (CGImageRef) screenshot filename: (NSString*) filename number: (int) num {
    NSString *path = @"/Users/murphycrosby/Misc/Images/";
    //NSString *filename = @"mspacman-";
    NSString *type = @".png";
    
    NSString *dest = [NSString stringWithFormat:@"%@%@%i%@", path, filename, num, type];
    CFURLRef url = (__bridge CFURLRef)[NSURL fileURLWithPath:dest];
    
    CGImageDestinationRef destination = CGImageDestinationCreateWithURL(url, kUTTypePNG, 1, NULL);
    if (!destination) {
        NSLog(@"MsPacman :: saveScreenshot :: Failed to create CGImageDestination for %@", path);
    } else {
        CGImageDestinationAddImage(destination, screenshot, nil);
        if (!CGImageDestinationFinalize(destination)) {
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
    
    NSString* path = @"/Users/murphycrosby/Misc/Images/";
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
