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
@property (nonatomic, strong) NSURLSessionConfiguration *sessionConfiguration;
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;
@property (nonatomic, strong) NSOperationQueue *operationQueue;
@property (nonatomic, strong) NSMutableArray *downloadingArr;
@property (nonatomic, strong) NSData *resumeData;
@property (nonatomic, strong) NSProgress *downloadProgress;
@property (nonatomic, strong) CJDownloadModel *model;
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
    
    _downloadArr = [NSMutableArray array];
    
    ///> 设置为可以后台下载
    self.sessionConfiguration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"com.hjDownLoadManager"];
    ///> https://www.jianshu.com/p/a8f1f7353e7f
    ///> iOS对于同一个IP服务器的并发最大为4，OS X为6。即使设置很多的session也只是用一个
    self.sessionConfiguration.HTTPMaximumConnectionsPerHost = 1;
    ///> 允许蜂窝下载
    self.sessionConfiguration.allowsCellularAccess = YES;
    
    ///> 意思是代理回调在 子线程中完成
    self.operationQueue = [[NSOperationQueue alloc]init];
    self.operationQueue.maxConcurrentOperationCount = 1;

    return self;
}

- (NSURLSession *)session {
    @synchronized (self) {
        if (!_session) {
            _session = [NSURLSession sessionWithConfiguration:self.sessionConfiguration delegate:self delegateQueue:self.operationQueue];
        }
    }
    return _session;
}


///> 需要判断任务的各种状态 是暂停状态 那么永远暂停   再次开启app也是暂停
- (void)downLoadWithModel:(CJDownloadModel *)model {
    
    if ([self downloadArrContainsModel:model]) {
        NSLog(@"已经存在在下载列表中");
        return;
    }
    
    self.downloadTask = [self.session downloadTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:model.downloadStr]]];
    model.downloadTask = self.downloadTask;

    if (self.downloadArr.count == 0) {
        model.downloadState = CJDownloading;
        [model.downloadTask resume];
        self.model = model;
        NSLog(@"开始下载 %zd",self.downloadTask.taskIdentifier);
    } else {
        NSLog(@"加入下载队列 %zd",model.downloadTask.taskIdentifier);
    }
    
    [self.downloadArr addObject:model];
}


- (BOOL)downloadArrContainsModel:(CJDownloadModel *)model {
    for (CJDownloadModel *aModel in self.downloadArr) {
        if ([model.downloadStr isEqualToString:aModel.downloadStr]) {
            return YES;
        }
    }
    return NO;
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
    NSLog(@"%s",__func__);
}

///> 这个方法在我们写后台下载的Demo中我们是会遇到的
- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session {
    if (self.backgroundSessionCompletionHandler) {
        self.backgroundSessionCompletionHandler();
    }
    NSLog(@"%s",__func__);
}


#pragma mark - NSURLSessionTaskDelegate
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task willBeginDelayedRequest:(NSURLRequest *)request
 completionHandler:(void (^)(NSURLSessionDelayedRequestDisposition disposition, NSURLRequest * _Nullable newRequest))completionHandler {
    NSLog(@"%s",__func__);
}

///>告诉代理，在开始网络加载之前，任务正在等待，直到合适的连接可用。
- (void)URLSession:(NSURLSession *)session taskIsWaitingForConnectivity:(NSURLSessionTask *)task {
    NSLog(@"%s",__func__);
}

///>告诉委托远程服务器请求HTTP重定向。
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
willPerformHTTPRedirection:(NSHTTPURLResponse *)response
        newRequest:(NSURLRequest *)request
 completionHandler:(void (^)(NSURLRequest * _Nullable))completionHandler {
    NSLog(@"%s",__func__);
}

///>  响应来自远程服务器的认证请求，从代理请求凭证。
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler {
    NSLog(@"%s",__func__);
}


- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
 needNewBodyStream:(void (^)(NSInputStream * _Nullable bodyStream))completionHandler {
    NSLog(@"%s",__func__);
}


///>  定期通知代理向服务器发送主体内容的进度。(上传进度)
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
   didSendBodyData:(int64_t)bytesSent
    totalBytesSent:(int64_t)totalBytesSent
totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend {
    NSLog(@"%s",__func__);
}

///> 当task完成的时候调用
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error {
    NSLog(@"%s",__func__);
}


#pragma mark - NSURLSessionDataDelegate
///> 1.收到了相应头
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
    NSLog(@"收到了相应头");
}

///>  开始下载数据
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didBecomeDownloadTask:(NSURLSessionDownloadTask *)downloadTask {
    NSLog(@"开始下载数据");
}

///> 告诉委托数据任务已更改为流任务
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didBecomeStreamTask:(NSURLSessionStreamTask *)streamTask {
    NSLog(@"诉委托数据任务已更改为流任务");
}


///> 开始接收到数据
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data {
    NSLog(@"开始接收到数据");
}

///> 存数据,这里可以使用系统默认的就行，这个是要将response缓存起来
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
 willCacheResponse:(NSCachedURLResponse *)proposedResponse
 completionHandler:(void (^)(NSCachedURLResponse * _Nullable cachedResponse))completionHandler {
    NSLog(@"存数据,这里可以使用系统默认的就行，这个是要将response缓存起来");
}



#pragma mark - NSURLSessionDownloadDelegate
///> 下载完成
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    NSLog(@"下载完成 %zd %@ downloadArr.count:%zd",self.downloadTask.taskIdentifier,location.absoluteString,self.downloadArr.count);
    
    self.model.downloadedUrl = location;
    self.model.downloadState = CJDownloaded;
    [self.downloadedArr addObject:self.model];
    
    [self.downloadArr removeObject:self.model];
    if (self.downloadArr.count > 0) {
        self.model = self.downloadArr[0];
        [self.model.downloadTask resume];
        NSLog(@"开始下载 %zd",self.downloadTask.taskIdentifier);
    }
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

