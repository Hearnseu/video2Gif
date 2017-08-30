//
//  GifConvertor.m
//  videoTgif
//
//  Created by coco on 2017/8/30.
//  Copyright © 2017年 coco. All rights reserved.
//

#import "GifConvertor.h"
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>

#define GIF_FPS 16.0

@interface GifConvertor()
{

    dispatch_queue_t _workQueue;
}

@end

@implementation GifConvertor


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}


- (void)setup{

    _workQueue = dispatch_queue_create("com.gif.maker", DISPATCH_QUEUE_SERIAL);
    
}

- (void)convertFromMp4Url:(NSString *)path toStorePath:(NSString *)storePath result:(convertedBlock)block{
    
    
    dispatch_async(_workQueue, ^{
        
        
        AVAsset *asset = [AVAsset assetWithURL:[NSURL fileURLWithPath:path]];
        NSArray *movieTracks = [asset tracksWithMediaType:AVMediaTypeVideo];
        AVAssetTrack *movieTrack = [movieTracks firstObject];
        if (!movieTrack) {
            block(NO);
            return ;
        }

        
        NSDictionary *fileProperties = @{
                                         (__bridge id)kCGImagePropertyGIFDictionary: @{
                                                 (__bridge id)kCGImagePropertyGIFLoopCount: @0, // 0 means loop forever
                                                 }
                                         };
        
        NSDictionary *frameProperties = @{
                                          (__bridge id)kCGImagePropertyGIFDictionary: @{
                                                  (__bridge id)kCGImagePropertyGIFDelayTime: @(1.0 / GIF_FPS), // a float (not double!) in seconds, rounded to centiseconds in the GIF data
                                                  }
                                          };
        
        NSURL *fileURL = [NSURL fileURLWithPath:storePath];
        [[NSFileManager defaultManager] removeItemAtPath:storePath error:nil];
        
        CMTime vid_length = asset.duration;
        float seconds = CMTimeGetSeconds(vid_length);
        int required_frames_count = seconds * GIF_FPS;
        int64_t step = vid_length.value / required_frames_count;
        int value = 0;
        
        CGImageDestinationRef destination = CGImageDestinationCreateWithURL((__bridge CFURLRef)fileURL, kUTTypeGIF, required_frames_count, NULL);
        CGImageDestinationSetProperties(destination, (__bridge CFDictionaryRef)fileProperties);
        
        
        AVAssetImageGenerator *image_generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
        image_generator.requestedTimeToleranceAfter = kCMTimeZero;
        image_generator.requestedTimeToleranceBefore = kCMTimeZero;
        image_generator.appliesPreferredTrackTransform = YES;
        
        for (int i = 0; i < required_frames_count; i++) {
            
            @autoreleasepool {

                CMTime time = CMTimeMake(value, vid_length.timescale);
                NSError *err = nil;
                CGImageRef image_ref = [image_generator copyCGImageAtTime:time actualTime:NULL error:&err];
                if(err){
                    
                    NSLog(@"%d %@",i,err.localizedDescription);
                }else{

                    if (image_ref) {
                         CGImageDestinationAddImage(destination, image_ref, (__bridge CFDictionaryRef)frameProperties);
                        CGImageRelease(image_ref);
                    }
                }
                
                value += step;
            }

        }
        
        if (!CGImageDestinationFinalize(destination)) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                block(NO);
            });
            NSLog(@"Failed to finalize image destination");
        }else{
        
            CFRelease(destination);
            dispatch_async(dispatch_get_main_queue(), ^{
               block(YES);
            });
        }
        
    });

}


@end
