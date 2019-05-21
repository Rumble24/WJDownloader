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

NSString * const HJDownLoadManagerTaskDidCompleteNotification = @"com.cjdownoadmanager.networking.task.complete";

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

- (void)continueDownload {
    if (self.resumeData) {
        self.downloadTask = [self.session downloadTaskWithResumeData:self.resumeData];
        [self.downloadTask resume];
        self.resumeData = nil;
        NSLog(@" continueDownload ");
    }
}

///> 需要判断任务的各种状态 是暂停状态 那么永远暂停   再次开启app也是暂停
- (void)downLoadWithModel:(CJDownloadModel *)model {
    
    if ([self downloadArrContainsModel:model]) {
        NSLog(@"已经存在在下载列表中");
        return;
    }
    
    model.downloadTask = [self.session downloadTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:model.downloadStr]]];
    
    if (self.downloadArr.count == 0) {
        self.model = model;
        self.downloadTask = model.downloadTask;
        model.downloadState = CJDownloading;
        [model.downloadTask suspend];
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
//- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(nullable NSError *)error {
//    NSLog(@"下载失败 ------------------------------");
//
//    if (error) {
//        if ([error.userInfo objectForKey:NSURLSessionDownloadTaskResumeData]){
//            self.resumeData = [error.userInfo objectForKey:NSURLSessionDownloadTaskResumeData];
//            self.downloadTask = [self.session downloadTaskWithResumeData:self.resumeData];
//            NSLog(@"下载失败 -error-----error-----error----error-----error----error----error-");
//            [self.downloadTask resume];
//        }
//    }
//}
/*
 只要请求的地址是HTTPS的, 就会调用这个代理方法
 我们需要在该方法中告诉系统, 是否信任服务器返回的证书  并且提供证书
 
 HTTPS：当客户端第一次发送请求的时候，服务器会返回一个包含公钥的受保护空间（也成为证书），
 当我们发送请求的时候，公钥会将请求加密再发送给服务器，服务器接到请求之后，用自带的私钥进行解密，如果正确再返回数据。这就是 HTTPS 的安全性所在
 
 HTTPS:   主要是把 公钥 放到本地
 */
- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler {

    
    /*
     服务器的认证方法  authenticationMethod
     
     NSURLProtectionSpaceHTTP                     ///> HTTP协议
     NSURLProtectionSpaceHTTPS                    ///> HTTPS协议
     NSURLProtectionSpaceFTP                      ///> FTP协议
     
     NSURLProtectionSpaceHTTPProxy                ///> http代理的代理类型
     NSURLProtectionSpaceHTTPSProxy               ///> HTTPS代理的代理类型
     NSURLProtectionSpaceFTPProxy                 ///> FTP代理的代理类型
     NSURLProtectionSpaceSOCKSProxy               ///> SOCKS代理的代理类型
     
     NSURLAuthenticationMethodDefault             ///> 协议的默认身份验证方法
     NSURLAuthenticationMethodHTTPBasic           ///> HTTP基本身份验证。相当于http的NSURLAuthenticationMethodDefault
     需要一个用户名和密码。使用  [NSURLCredential credentialWithUser:@"" password:@"" persistence:@""]
     
     NSURLAuthenticationMethodHTTPDigest          ///> HTTP摘要身份验证。使用
     credentialWithUser:password:persistence:方法创建NSURLCredential对象
     
     
     NSURLAuthenticationMethodHTMLForm            ///> HTML表单认证。适用于任何协议   基于用户名/密码的认证
     NSURLAuthenticationMethodNTLM                ///> NTLM身份验证。              基于用户名/密码的认证
     NSURLAuthenticationMethodNegotiate           ///> 协商认证                    基于用户名/密码的认证
     
     
     上面的认证好像都需要用户名和密码
     
     
     NSURLAuthenticationMethodClientCertificate   ///> SSL客户端证书。适用于任何协议。
     需要system identity和需要与server进行身份验证的所有证书。使用credentialWithIdentity:certificates:persistence:创建NSURLCredential对象
     
     
     NSURLAuthenticationMethodServerTrust         ///> 需要SecTrustRef验证。适用于任何协议
     需要authentication challenge的protection space提供一个trust。使用credentialForTrust:来创建NSURLCredential对象。
     */
    
    

    /*
     NSURLSessionAuthChallengeDisposition
     
     对于 NSURLConnection 和 NSURLDownload，在[challenge sender] 上调用continueWithoutCredentialsForAuthenticationChallenge:方法。不提供证书的话，可能会导致连接失败，调用connectionDidFailWithError:方法 ，或者会返回一个不需要验证身份的替代的URL

    NSURLSessionAuthChallengeUseCredential = 0,                   ///> 提供证书
    NSURLSessionAuthChallengePerformDefaultHandling = 1,          ///> 处理请求，就好像代理没有提供一个代理方法来处理认证请求
    NSURLSessionAuthChallengeCancelAuthenticationChallenge = 2,   ///> 整个请求将被取消;忽略凭据参数
    NSURLSessionAuthChallengeRejectProtectionSpace = 3,           ///> 拒接认证请求
    
     */
    
    
    // 1.从服务器返回的受保护空间中拿到证书的类型  获取服务器的认证方法 服务器的认证方法
    NSString *method = challenge.protectionSpace.authenticationMethod;
    
    // 2.判断服务器返回的证书是否是服务器信任的
    if([method isEqualToString:NSURLAuthenticationMethodServerTrust]){
        // 3.根据服务器返回的受保护空间创建一个证书
        NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        
        // 4.安装证书
        completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
        return;
    }
    
    NSLog(@"服务器要求验证客户端身份 ");
}

///> 这个方法在我们写后台下载的Demo中我们是会遇到的
- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session {
    if (self.backgroundSessionCompletionHandler) {
        self.backgroundSessionCompletionHandler();
    }
    NSLog(@"%s",__func__);
}


///> 当task完成的时候调用
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(nullable NSError *)error {
    if (error) {
        // check if resume data are available
        if ([error.userInfo objectForKey:NSURLSessionDownloadTaskResumeData]) {
            NSData *resumeData = [error.userInfo objectForKey:NSURLSessionDownloadTaskResumeData];
            //通过之前保存的resumeData，获取断点的NSURLSessionTask，调用resume恢复下载
            self.resumeData = resumeData;
        }
    } 
}



#pragma mark - NSURLSessionDownloadDelegate
///> 下载完成
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    
    NSLog(@"下载完成 %zd %@ downloadArr.count:%zd",self.downloadTask.taskIdentifier,location.absoluteString,self.downloadArr.count);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (downloadTask.taskIdentifier != self.downloadTask.taskIdentifier) return;
        
        self.model.downloadedUrl = location;
        self.model.downloadState = CJDownloaded;
        [self.downloadedArr addObject:self.model];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:HJDownLoadManagerTaskDidCompleteNotification object:self.model];
        
        [self.downloadArr removeObject:self.model];
        if (self.downloadArr.count > 0) {
            self.model = self.downloadArr[0];
            self.downloadTask = self.model.downloadTask;
            [self.model.downloadTask resume];
            NSLog(@"开始下载 %zd",self.downloadTask.taskIdentifier);
        }
    });
}

///> 下载进度
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    float percent = (float)totalBytesWritten/totalBytesExpectedToWrite;
    
    NSLog(@"下载进度 %tu  %f",downloadTask.taskIdentifier,percent);

    dispatch_async(dispatch_get_main_queue(), ^{
        if (downloadTask.taskIdentifier == self.downloadTask.taskIdentifier) {
            
            if (self.downloadProgressBlock) {
                self.downloadProgressBlock(percent);
            }
            
        }
    });
}

///> 下载任务已经恢复下载。
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes {
    NSLog(@"下载任务已经恢复下载。 %f",fileOffset * 1.0);
}


@end

/*
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
*/
