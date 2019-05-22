//
//  HJDownLoadTool.h
//  DownloadManager
//
//  Created by 王景伟 on 2019/5/22.
//  Copyright © 2019 王景伟. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HJDownLoadTool : NSObject

+ (NSString *)getFileTypeWithUrlStr:(NSString *)str;

+ (NSString *)cachedFileNameForKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
