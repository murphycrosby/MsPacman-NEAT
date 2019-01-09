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
    
    //Whole score
    /*
    CGRect rect = CGRectMake(185, 160, 220, 25);
    CGImageRef imageRef = CGImageCreateWithImageInRect(screenshot, rect);
    [self saveScreenshot:imageRef number:5];
    CGImageRelease(imageRef);
    */
    
    NSString* score = @"";
    
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
            score = [score stringByAppendingString:[NSString stringWithFormat:@"%i",0]];
        } else if (pix1 && pix2 && !pix3 && !pix4 && pix5 && !pix6 && !pix7 && !pix8 && pix9) {
            score = [score stringByAppendingString:[NSString stringWithFormat:@"%i",1]];
        } else if (pix1 && !pix2 && pix3 && pix4 && pix5 && pix6 && pix7 && !pix8 && pix9) {
            score = [score stringByAppendingString:[NSString stringWithFormat:@"%i",2]];
        } else if (pix1 && !pix2 && pix3 && pix4 && pix5 && pix6 && !pix7 && pix8 && pix9) {
            score = [score stringByAppendingString:[NSString stringWithFormat:@"%i",3]];
        } else if (!pix1 && pix2 && pix3 && pix4 && pix5 && pix6 && !pix7 && pix8 && !pix9) {
            score = [score stringByAppendingString:[NSString stringWithFormat:@"%i",4]];
        } else if (pix1 && pix2 && !pix3 && pix4 && pix5 && pix6 && !pix7 && pix8 && pix9) {
            score = [score stringByAppendingString:[NSString stringWithFormat:@"%i",5]];
        } else if (pix1 && pix2 && !pix3 && pix4 && pix5 && pix6 && pix7 && pix8 && pix9) {
            score = [score stringByAppendingString:[NSString stringWithFormat:@"%i",6]];
        } else if (pix1 && !pix2 && pix3 && !pix4 && !pix5 && pix6 && !pix7 && pix8 && !pix9) {
            score = [score stringByAppendingString:[NSString stringWithFormat:@"%i",7]];
        } else if (pix1 && pix2 && pix3 && pix4 && pix5 && pix6 && pix7 && pix8 && pix9) {
            score = [score stringByAppendingString:[NSString stringWithFormat:@"%i",8]];
        } else if (pix1 && pix2 && pix3 && pix4 && pix5 && pix6 && !pix7 && pix8 && !pix9) {
            score = [score stringByAppendingString:[NSString stringWithFormat:@"%i",9]];
        }
        
        if (data) { free(data); }
        CGContextRelease(context);
        CGImageRelease(imageRef);
        
        x = x - 30 - 1;
    }
    
    CGColorSpaceRelease(colorSpace);
    
    NSMutableString *reversedString = [NSMutableString string];
    NSInteger charIndex = [score length];
    while (score && charIndex > 0) {
        charIndex--;
        NSRange subStrRange = NSMakeRange(charIndex, 1);
        [reversedString appendString:[score substringWithRange:subStrRange]];
    }
    
    return [reversedString longLongValue];
}

-(void) saveScreenshot: (CGImageRef) screenshot number: (int) num {
    NSString *path = @"/Users/murphycrosby/Documents/Misc/Images/";
    NSString *filename = @"mspacman-";
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

-(void) saveScreenshotToArray: (unsigned char*) data width:(size_t) width height:(size_t) height filename:(NSString*) filename {
    NSString* dataArray = @"";
    
    for(int row = 0; row < height; row++) {
        for(int x = 0; x < width; x++) {
            int offset = 4 * ((width * row) + round(x));
            //int alpha = data[offset];
            int red   = data[offset + 1];
            int green = data[offset + 2];
            int blue  = data[offset + 3];
            
            //NSLog(@"XY: [%i,%i], RGB: [%d][%d][%d]",x,row,red,green,blue);
            NSString* str;
            if(row == 0 && x == 0) {
                str = [NSString stringWithFormat:@"%d,%d,%d", red, green, blue];
            } else {
                str = [NSString stringWithFormat:@",%d,%d,%d", red, green, blue];
            }
            dataArray = [dataArray stringByAppendingString:str];
        }
    }
    
    NSString* path = @"/Users/murphycrosby/Documents/Misc/Images/";
    path = [path stringByAppendingString:filename];
    
    [[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil];
    [dataArray writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

-(NSMutableArray*) getInputValues: (CGImageRef) screenshot {
    
    NSMutableArray* nsa = [[NSMutableArray alloc] init];
    
    return nsa;
}

@end
