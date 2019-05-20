//
//  HJDownLoadManager.h
//  DownloadManager
//
//  Created by 王景伟 on 2019/5/9.
//  Copyright © 2019 王景伟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CJDownloadModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HJDownLoadManager : NSObject

@property (nonatomic, copy) void (^backgroundSessionCompletionHandler)(void);

///> 下载中的数组
@property (strong, nonatomic) NSMutableArray *downloadArr;

///> 已经下载的数组
@property (strong, nonatomic) NSMutableArray *downloadedArr;

+ (instancetype)sharedManager;

- (void)downLoadWithModel:(CJDownloadModel *)model;

@end

NS_ASSUME_NONNULL_END
