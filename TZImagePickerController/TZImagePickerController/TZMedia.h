//
//  TZMedia.h
//  TZImagePickerController
//
//  Created by Mark on 2024/1/29.
//  Copyright © 2024 谭真. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TZMedia : NSObject

@property (nonatomic, assign) NSInteger idx; // 索引值
@property (nonatomic, copy)   NSString *imagePath; // 图片转换后的地址
@property (nonatomic, copy)   NSString *videoPath; // 视频转存后的地址
@property (nonatomic, copy)   NSString *imageBaseStr; // 模糊图片字符串
@property (nonatomic, assign) NSInteger duration; // 视频时长

- (instancetype)initWithIndex:(NSInteger)index imagePath:(NSString *)imagePath videoPath:(NSString *)videoPath baseStr:(NSString *)baseStr duration:(NSInteger)duration;

@end

NS_ASSUME_NONNULL_END
