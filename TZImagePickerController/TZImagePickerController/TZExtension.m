//
//  TZExtension.m
//  TZImagePickerController
//
//  Created by Mark on 2024/1/29.
//  Copyright © 2024 谭真. All rights reserved.
//

#import "TZExtension.h"
#include <CommonCrypto/CommonCrypto.h>
//#include <zlib.h>

@implementation TZExtension


@end

@implementation NSData (TZAdd)

- (NSString *)tzmd5String {
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(self.bytes, (CC_LONG)self.length, result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

@end

@implementation NSString (TZAdd)

- (nullable NSString *)tzmd5String {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] tzmd5String];
}


@end


@implementation UIImage (TZAdd)

- (nullable UIImage *)scaleImage:(CGFloat)scale {
    CGSize size = CGSizeMake(self.size.width * scale, self.size.height * scale);
    UIGraphicsBeginImageContext(size);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaleImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaleImage;
}

- (NSString * _Nullable)obtainBase64String:(CGFloat)scale {
    UIImage *image = [self scaleImage:0.005];
    NSData *data = UIImageJPEGRepresentation(image, 0.005);
    return [data base64EncodedStringWithOptions:0];
}

@end



