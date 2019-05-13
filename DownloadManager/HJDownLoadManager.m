//
//  HJDownLoadManager.m
//  DownloadManager
//
//  Created by 王景伟 on 2019/5/9.
//  Copyright © 2019 王景伟. All rights reserved.
//
///> 1.断网续传功能   2.杀死重传功能  3.批量下载功能   4.

#import "HJDownLoadManager.h"

@interface HJDownLoadManager ()<NSURLSessionDelegate>

@property (nonatomic, strong) NSURLSession *session;

@property (nonatomic, strong) NSOperationQueue *delegateQueue;

@end

@implementation HJDownLoadManager

+ (instancetype)sharedManager {
    static HJDownLoadManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[HJDownLoadManager alloc]init];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    
    ///> 设置为可以后台下载
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"com.hjDownLoadManager"];
    ///> 意思是代理回调在 子线程中完成
    self.delegateQueue = [[NSOperationQueue alloc]init];
    self.delegateQueue.maxConcurrentOperationCount = 1;
    self.session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:self.delegateQueue];
    return self;
}


- (void)downLoadWithUrl:(NSString *)url {
    NSURLSessionDownloadTask *task = [self.session downloadTaskWithURL:[NSURL URLWithString:url]];
    ///> 开始任务
    [task resume];
}


#pragma mark - NSURLSessionDelegate 会话失效 失败或者c完成回调方法 如果您调用invalidateAndCancel方法会话将立即调用此委托方法
- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(nullable NSError *)error {
    
}

///> 如果服务器要求验证客户端身份或向客户端提供其证书用于验证时，则会调用
- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler {
    
}

///> 这个方法在我们写后台下载的Demo中我们是会遇到的
- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session {
    
}


#pragma mark - NSURLSessionDownloadDelegate
///> 下载完成
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    
}

///> 下载进度
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    
}

///> 下载任务已经恢复下载。
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes {
    
}

@end

