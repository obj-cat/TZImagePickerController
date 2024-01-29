//
//  TZMediaManager.m
//  TZImagePickerController
//
//  Created by Mark on 2024/1/29.
//  Copyright © 2024 谭真. All rights reserved.
//

#import "TZMediaManager.h"
#import "TZImageManager.h"

@implementation TZMediaManager

+ (instancetype)shared {
    static TZMediaManager *_shared;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = [[TZMediaManager alloc] init];
    });
    
    return _shared;
}

+ (void)saveMedias:(NSInteger)idx asset:(PHAsset *)asset halfPath:(NSString *)halfPath completed:(TZMediaManagerCompletedBlock)completed {
    PHAssetResource *assetRescource = [[PHAssetResource assetResourcesForAsset:asset] firstObject];
    NSString *rawFileName = assetRescource.originalFilename;
    NSArray *files = [rawFileName componentsSeparatedByString:@"."];
    NSString *fileName = [NSString stringWithFormat:@"%@.%@", [files.firstObject tzmd5String], files.lastObject];
    NSString *filePath = [TZMediaManager obtainFilePath:halfPath fileName:fileName];
    NSString *coverName = @"png";
    NSString *coverPath = @"";
    NSInteger duration = 0;
    __block TZMedia *item;
    
    BOOL isVideo = asset.mediaType == PHAssetMediaTypeVideo;
    if (isVideo) {
        coverName = [NSString stringWithFormat:@"%@.%@", [files.firstObject tzmd5String], @"png"];
        coverPath = [TZMediaManager obtainFilePath:halfPath fileName:coverName];
        duration = ceilf([asset duration]);
    }
    
    if ([TZMediaManager isFileExistsAtPath:filePath] == YES) {
        if (isVideo) {
            if ([TZMediaManager isFileExistsAtPath:coverPath] == true) {
                item = [[TZMedia alloc] initWithIndex:idx imagePath:coverPath videoPath:filePath baseStr:coverPath duration:duration];
                completed(item, @"沙盒里读取视频和图片", YES);
            } else {
                UIImage *coverImage = [[TZImageManager manager] getImageWithVideoURL:[NSURL fileURLWithPath:filePath]];
                //保存操作
                BOOL result = [UIImagePNGRepresentation(coverImage)writeToFile:coverPath atomically:YES];
                if (result == YES) {
                    item = [[TZMedia alloc] initWithIndex:idx imagePath:coverPath videoPath:filePath baseStr:[TZMediaManager obtainBase64String:coverPath] duration:duration];
                    completed(item, @"视频封面图片保存成功", YES);
                    NSLog(@"保存成功 >>>>> %@ >>>>> %@", coverName, coverPath);
                } else {
                    completed(item, @"视频封面图片保存失败", NO);
                }
            }
        } else {
            item = [[TZMedia alloc] initWithIndex:idx imagePath:filePath videoPath:@"" baseStr:[TZMediaManager obtainBase64String:filePath] duration:0];
            completed(item, @"获取沙盒中已转化的图片", YES);
        }
    } else {
        PHAssetResourceManager *manager = [PHAssetResourceManager defaultManager];
        [manager writeDataForAssetResource:assetRescource toFile:[NSURL fileURLWithPath:filePath] options:nil completionHandler:^(NSError * _Nullable error) {
            if (error == nil) {
                NSLog(@"保存沙盒成功 >>>>> %@",filePath);
                if (isVideo) {
                    UIImage *coverImage = [[TZImageManager manager] getImageWithVideoURL:[NSURL fileURLWithPath:filePath]];
                    //保存操作
                    BOOL result =[UIImagePNGRepresentation(coverImage)writeToFile:coverPath atomically:YES];
                    if (result == YES) {
                        item = [[TZMedia alloc] initWithIndex:idx imagePath:coverPath videoPath:filePath baseStr:[TZMediaManager obtainBase64String:coverPath] duration:duration];
                         completed(item, @"视频和封面图片保存成功", YES);
                         NSLog(@"保存成功 >>>>> %@ >>>>> %@", coverName, coverPath);
                        } else {
                            completed(item, @"视频封面图片保存失败", NO);
                            NSLog(@"保存失败");
                        }
                } else {
                    TZMedia *item = [[TZMedia alloc] initWithIndex:idx imagePath:filePath videoPath:@"" baseStr:[TZMediaManager obtainBase64String:filePath] duration:0];
                    completed(item, @"图片保存成功", YES);
                }
            } else {
                completed(item, @"媒体文件保存沙盒失败", NO);
                NSLog(@"保存沙盒失败,重新尝试 >>>>> %@",filePath);
            }
        }];
    }
    
}

+ (NSString *)obtainBase64String:(NSString *)imagePath {
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    return [image obtainBase64String:0.005];
}


// 获取视频的地址和时长
- (void)getVideoURLAndDurationForAsset:(PHAsset *)asset {
    PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
    options.version = PHVideoRequestOptionsVersionOriginal;
    options.networkAccessAllowed = YES;

    [[PHImageManager defaultManager] requestAVAssetForVideo:asset options:options resultHandler:^(AVAsset *avAsset, AVAudioMix *audioMix, NSDictionary *info) {
        if ([avAsset isKindOfClass:[AVURLAsset class]]) {
            AVURLAsset *urlAsset = (AVURLAsset *)avAsset;
            NSURL *videoURL = urlAsset.URL;
            CMTime duration = urlAsset.duration;
            NSLog(@"Video URL: %@", videoURL);
            NSLog(@"Duration: %f seconds", CMTimeGetSeconds(duration));
        }
    }];
}

// 获取视频的封面图
- (void)getVideoThumbnailForAsset:(PHAsset *)asset completion:(void (^)(UIImage *thumbnail))completion {
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.synchronous = NO;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    options.networkAccessAllowed = YES;

    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(100, 100) contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage *image, NSDictionary *info) {
        completion(image);
    }];
}

+ (NSString *)obtainSanboxPath {
    // 获取文档目录路径
//    NSCachesDirectory
    return NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
}

+ (BOOL)isFileExistsAtPath:(NSString *)path {
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

+ (NSString *)obtainFilePath:(NSString *)str {
    NSString *cache = [TZMediaManager obtainSanboxPath];
    NSString *path = [NSString stringWithFormat:@"%@/%@", cache, str];
    NSError *error;
    if ([[NSFileManager defaultManager] fileExistsAtPath:path] == false) {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
    }
    
    return path;
}

+ (NSString *)obtainFilePath:(NSString *)halfPath fileName:(NSString *)fileName {
    NSString *filePath = [TZMediaManager obtainFilePath:halfPath];
    return [NSString stringWithFormat:@"%@%@", filePath, fileName];
}


@end
