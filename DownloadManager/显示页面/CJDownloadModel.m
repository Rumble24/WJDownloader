//
//  CJDownloadModel.m
//  DownloadManager
//
//  Created by 王景伟 on 2019/5/20.
//  Copyright © 2019 王景伟. All rights reserved.
//

#import "CJDownloadModel.h"
#import "HJDownLoadTool.h"

@implementation CJDownloadModel

- (void)setDownloadStr:(NSString *)downloadStr {
    _downloadStr = downloadStr;
    NSString *fileType = [HJDownLoadTool getFileTypeWithUrlStr:downloadStr];
    NSString *fileName = [HJDownLoadTool cachedFileNameForKey:downloadStr];
    _downloadedStr = [NSString stringWithFormat:@"%@.%@",fileName,fileType];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.downloadStr forKey:@"downloadStr"];
    [aCoder encodeObject:self.downloadedStr forKey:@"downloadedStr"];
    [aCoder encodeObject:self.imageName forKey:@"imageName"];
    [aCoder encodeInteger:self.downloadState forKey:@"downloadState"];

}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self)
    {
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.downloadStr = [aDecoder decodeObjectForKey:@"downloadStr"];
        self.downloadedStr = [aDecoder decodeObjectForKey:@"downloadedStr"];
        self.imageName = [aDecoder decodeObjectForKey:@"imageName"];
        self.downloadState = [aDecoder decodeIntegerForKey:@"downloadState"];

    }
    return self;
}
@end
