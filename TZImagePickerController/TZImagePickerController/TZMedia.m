//
//  TZMedia.m
//  TZImagePickerController
//
//  Created by Mark on 2024/1/29.
//  Copyright © 2024 谭真. All rights reserved.
//

#import "TZMedia.h"

@implementation TZMedia

- (instancetype)initWithIndex:(NSInteger)index imagePath:(NSString *)imagePath videoPath:(NSString *)videoPath baseStr:(NSString *)baseStr duration:(NSInteger)duration {
    self = [super init];
    if (self) {
        _idx = index;
        _imagePath = imagePath;
        _videoPath = videoPath;
        _imageBaseStr = baseStr;
        _duration = duration;
    }
    
    return self;
}

@end
