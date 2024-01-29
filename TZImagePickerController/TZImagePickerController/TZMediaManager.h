//
//  TZMediaManager.h
//  TZImagePickerController
//
//  Created by Mark on 2024/1/29.
//  Copyright © 2024 谭真. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import "TZExtension.h"
#import "TZImageManager.h"

typedef void(^TZMediaManagerCompletedBlock)(TZMedia * _Nullable media, NSString * _Nullable msg, BOOL finished);

NS_ASSUME_NONNULL_BEGIN

@interface TZMediaManager : NSObject

+ (instancetype)shared;

+ (NSString *)obtainFilePath:(NSString *)halfPath fileName:(NSString *)fileName;

+ (void)saveMedias:(NSInteger)idx asset:(PHAsset *)asset halfPath:(NSString *)halfPath completed:(TZMediaManagerCompletedBlock)completed;

@end

NS_ASSUME_NONNULL_END
