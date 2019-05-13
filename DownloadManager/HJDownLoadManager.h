//
//  HJDownLoadManager.h
//  DownloadManager
//
//  Created by 王景伟 on 2019/5/9.
//  Copyright © 2019 王景伟. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HJDownLoadManager : NSObject

+ (instancetype)sharedManager;

- (void)downLoadWithUrl:(NSString *)url;

@end

NS_ASSUME_NONNULL_END
