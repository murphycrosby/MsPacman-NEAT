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
    /*
    size_t width                    = CGImageGetWidth(screenshot);
    size_t height                   = CGImageGetHeight(screenshot);
    size_t bitsPerComponent         = CGImageGetBitsPerComponent(screenshot);
    size_t bitsPerPixel             = CGImageGetBitsPerPixel(screenshot);
    size_t bytesPerRow              = CGImageGetBytesPerRow(screenshot);
    
    NSLog(@"Screenshot: W:%zu, H:%zu, BPC:%zu, BPPixel:%zu, BPRow:%zu", width, height, bitsPerComponent, bitsPerPixel, bytesPerRow);
    */
    
    //Whole score
    /*
    CGRect rect = CGRectMake(185, 160, 220, 25);
    CGImageRef imageRef = CGImageCreateWithImageInRect(screenshot, rect);
    [self saveScreenshot:imageRef number:5];
    CGImageRelease(imageRef);
    */
    
    NSString* filestr = @"";
    
    int count = 0;
    int x = 185+220-30;
    //while(x >= 185) {
    CGRect rect1 = CGRectMake(x, 160, 30, 25);
    CGImageRef imageRef = CGImageCreateWithImageInRect(screenshot, rect1);
    
    //------------
    size_t width = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    size_t bitsPerComponent = CGImageGetBitsPerComponent(imageRef);
    size_t bitsPerPixel = CGImageGetBitsPerPixel(imageRef);
    size_t bytesPerRow = CGImageGetBytesPerRow(imageRef);
    
    size_t bitmapBytesPerRow   = (width * 4);
    size_t bitmapByteCount     = (bitmapBytesPerRow * height);
    
    NSLog(@"Screenshot: W:%zu, H:%zu, BPC:%zu, BPPixel:%zu, BPRow:%zu", width, height, bitsPerComponent, bitsPerPixel, bytesPerRow);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);
    
    void* bitmapData = malloc( bitmapByteCount );
    
    CGContextRef context = CGBitmapContextCreate (bitmapData,
                                     width,
                                     height,
                                     bitsPerComponent,
                                     bitmapBytesPerRow,
                                     colorSpace,
                                     kCGImageAlphaPremultipliedFirst);
    
    CGColorSpaceRelease(colorSpace);
    
    rect1 = CGRectMake(0, 0, width, height);
    CGContextDrawImage(context, rect1, imageRef);
    
    unsigned char* data = CGBitmapContextGetData (context);
    
    for(int row = 0; row < height; row++) {
        for(int x = 0; x < width; x++) {
            
            int offset = 4 * ((width * row) + round(x));
            //int alpha = data[offset];
            int red   = data[offset + 1];
            int green = data[offset + 2];
            int blue  = data[offset + 3];
            
            NSLog(@"XY: [%i,%i], RGB: [%d][%d][%d]",x,row,red,green,blue);
            
            NSString* str = @"";
            if(row == 0 && x == 0) {
                str = [NSString stringWithFormat:@"%d,%d,%d", red, green, blue];
            } else {
                str = [NSString stringWithFormat:@",%d,%d,%d", red, green, blue];
            }
            filestr = [filestr stringByAppendingString:str];
        }
    }
    if (data) { free(data); }
    CGContextRelease(context);
    //-------------

        
        [self saveScreenshot:imageRef number:count];
        CGImageRelease(imageRef);
        
        count++;
        x = x - 30 - 1;
    //}
    
    [[NSFileManager defaultManager] createFileAtPath:@"/Users/murphycrosby/Documents/Misc/Images/img.txt" contents:nil attributes:nil];
    [filestr writeToFile:@"/Users/murphycrosby/Documents/Misc/Images/img.txt" atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    return YES;
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

-(long) getScore: (CGImageRef) screenshot {
    
    return 42;
}

-(NSMutableArray*) getInputValues: (CGImageRef) screenshot {
    
    NSMutableArray* nsa = [[NSMutableArray alloc] init];
    
    return nsa;
}

@end
