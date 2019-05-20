//
//  CJDownloadModel.h
//  DownloadManager
//
//  Created by 王景伟 on 2019/5/20.
//  Copyright © 2019 王景伟. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, CJDownloadState) {
    CJDownloadNone,
    CJDownloadWaiting,
    CJDownloading,
    CJDownloadPause,
    CJDownloaded,
};

@interface CJDownloadModel : NSObject

@property (nonatomic, strong) NSString *title;

///> 下载的地址
@property (nonatomic, strong) NSString *downloadStr;

///> 下载完成的地址
@property (nonatomic, strong) NSURL *downloadedUrl;

@property (nonatomic, strong) NSString *imageName;

@property (nonatomic, assign) CJDownloadState downloadState;

@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;

@end

NS_ASSUME_NONNULL_END
