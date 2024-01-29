//
//  TZExtension.h
//  TZImagePickerController
//
//  Created by Mark on 2024/1/29.
//  Copyright © 2024 谭真. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TZExtension : NSObject

@end

@interface NSData (TZAdd)

- (nullable NSString *)tzmd5String;

@end

@interface NSString (TZAdd)

- (nullable NSString *)tzmd5String;

@end

@interface UIImage (TZAdd)

- (nullable UIImage *)scaleImage:(CGFloat)scale;

- (NSString * _Nullable)obtainBase64String:(CGFloat)scale;

@end




NS_ASSUME_NONNULL_END
