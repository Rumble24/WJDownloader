//
//  HJDownLoadManager.m
//  DownloadManager
//
//  Created by 王景伟 on 2019/5/9.
//  Copyright © 2019 王景伟. All rights reserved.
//
///> 1.断网续传功能   2.杀死重传功能  3.批量下载功能   4.
///> taskIdentifier  和下载的进度是一一对应的
///> 为毛这么多代理

#import "HJDownLoadManager.h"

@interface HJDownLoadManager ()<NSURLSessionDelegate,NSURLSessionDownloadDelegate>

@property (nonatomic, strong) NSURLSession *session;

@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;

@property (nonatomic, strong) NSOperationQueue *delegateQueue;

@property (nonatomic, strong) NSMutableArray *downloadingArr;

@property (nonatomic, strong) NSData *resumeData;

@property (nonatomic, strong) NSProgress *downloadProgress;

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
    
    ///> https://www.jianshu.com/p/a8f1f7353e7f
    ///> iOS对于同一个IP服务器的并发最大为4，OS X为6。即使设置很多的session也只是用一个
    config.HTTPMaximumConnectionsPerHost = 1;
    
    ///> 允许蜂窝下载
    config.allowsCellularAccess = YES;
    
    ///> 意思是代理回调在 子线程中完成
    self.delegateQueue = [[NSOperationQueue alloc]init];
    self.delegateQueue.maxConcurrentOperationCount = 1;
    self.session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:self.delegateQueue];
    
    
    _downloadProgress = [[NSProgress alloc] initWithParent:nil userInfo:nil];
    
    [_downloadProgress addObserver:self
               forKeyPath:NSStringFromSelector(@selector(fractionCompleted))
                  options:NSKeyValueObservingOptionNew
                  context:NULL];
    
    _downloadProgress.totalUnitCount = NSURLSessionTransferSizeUnknown;
    _downloadProgress.cancellable = YES;
    _downloadProgress.cancellationHandler = ^{
        [self.downloadTask cancel];
    };
    _downloadProgress.pausable = YES;
    _downloadProgress.pausingHandler = ^{
        [self.downloadTask suspend];
    };
#if AF_CAN_USE_AT_AVAILABLE
    if (@available(iOS 9, macOS 10.11, *))
#else
        if ([_downloadProgress respondsToSelector:@selector(setResumingHandler:)])
#endif
        {
            _downloadProgress.resumingHandler = ^{
                [self.downloadTask resume];
            };
        }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([object isEqual:self.downloadProgress]) {
        NSLog(@"------ ---- ");
    }

}


///> 需要判断任务的各种状态 是暂停状态 那么永远暂停   再次开启app也是暂停
- (void)downLoadWithUrl:(NSString *)url {
    self.downloadTask = [self.session downloadTaskWithURL:[NSURL URLWithString:url]];
    ///> 开始任务
    [self.downloadTask resume];
}


#pragma mark - NSURLSessionDelegate 会话失效 失败或者c完成回调方法 如果您调用invalidateAndCancel方法会话将立即调用此委托方法
- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(nullable NSError *)error {
    NSLog(@"下载失败 ");
    
    if (error) {
        if ([error.userInfo objectForKey:NSURLSessionDownloadTaskResumeData]){
            self.resumeData = [error.userInfo objectForKey:NSURLSessionDownloadTaskResumeData];
            self.downloadTask = [self.session downloadTaskWithResumeData:self.resumeData];
            [self.downloadTask resume];
        }
    }
}

///> 如果服务器要求验证客户端身份或向客户端提供其证书用于验证时，则会调用
- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler {
    
}

///> 这个方法在我们写后台下载的Demo中我们是会遇到的
- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session {
    if (self.backgroundSessionCompletionHandler) {
        self.backgroundSessionCompletionHandler();
    }
}

//- (void)URLSession:(__unused NSURLSession *)session
//          dataTask:(__unused NSURLSessionDataTask *)dataTask
//    didReceiveData:(NSData *)data
//{
//    self.downloadProgress.totalUnitCount = dataTask.countOfBytesExpectedToReceive;
//    self.downloadProgress.completedUnitCount = dataTask.countOfBytesReceived;
//    
//    [self.mutableData appendData:data];
//}


#pragma mark - NSURLSessionDownloadDelegate
///> 下载完成
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    NSLog(@"下载完成 %@",location.absoluteString);
}

///> 下载进度
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    float percent = (float)totalBytesWritten/totalBytesExpectedToWrite;
    NSLog(@"下载进度 %tu  %f",downloadTask.taskIdentifier,percent);
    
    self.downloadProgress.totalUnitCount = totalBytesExpectedToWrite;
    self.downloadProgress.completedUnitCount = totalBytesWritten;
}

///> 下载任务已经恢复下载。
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes {
    NSLog(@"下载任务已经恢复下载。 %f",fileOffset * 1.0);
}


@end

