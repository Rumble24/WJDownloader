//
//  HJDownLoadTool.m
//  DownloadManager
//
//  Created by 王景伟 on 2019/5/22.
//  Copyright © 2019 王景伟. All rights reserved.
//

#import "HJDownLoadTool.h"
#import <CommonCrypto/CommonDigest.h>

@implementation HJDownLoadTool

+ (NSString *)getFileTypeWithUrlStr:(NSString *)str {
    NSArray *arr = [str componentsSeparatedByString:@"."];
    if ([self isBlankString:arr.lastObject]) {
        return @"";
    }
    return arr.lastObject;
}

+ (BOOL)isBlankString:(NSString *)string {
    if ([string isKindOfClass:[NSString class]]) {
        if ([string isEqualToString:@"(null)"]) {
            return YES;
        }
    }else{
        return YES;
    }
    
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

+ (NSString *)cachedFileNameForKey:(NSString *)key {
    const char *str = [key UTF8String];
    if (str == NULL) {
        str = "";
    }
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString *filename = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                          r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
    
    return filename;
}
@end
