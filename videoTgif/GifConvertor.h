//
//  GifConvertor.h
//  videoTgif
//
//  Created by coco on 2017/8/30.
//  Copyright © 2017年 coco. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^convertedBlock)(BOOL success);

@interface GifConvertor : NSObject

- (void)convertFromMp4Url:(NSString *)path toStorePath:(NSString *)storePath result:(convertedBlock)block;


@end
