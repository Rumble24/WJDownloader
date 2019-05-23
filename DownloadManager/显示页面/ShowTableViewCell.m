//
//  ShowTableViewCell.m
//  DownloadManager
//
//  Created by 王景伟 on 2019/5/21.
//  Copyright © 2019 王景伟. All rights reserved.
//

#import "ShowTableViewCell.h"
#import "HJDownLoadManager.h"

#define kH [[UIScreen mainScreen] bounds].size.height
#define kW [[UIScreen mainScreen] bounds].size.width

@interface ShowTableViewCell ()

@property (nonatomic, strong) UILabel *titleLable;

@property (nonatomic, strong) UILabel *downLable;

@end

@implementation ShowTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    _titleLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 100)];
    _titleLable.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_titleLable];
    
    _downLable = [[UILabel alloc]initWithFrame:CGRectMake(kW - 200, 0, 200, 100)];
    _downLable.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_downLable];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.contentView.layer.cornerRadius = 10;

    return self;
}


- (void)setModel:(CJDownloadModel *)model {
    _model = model;
    _titleLable.text = model.title;
    
    model.downloadState = [[HJDownLoadManager sharedManager] getDownloadStateWithModel:model];
    
    switch (model.downloadState) {
        case CJDownloadNone:
            _downLable.text = @"点击下载";
            break;
        case CJDownloadWaiting:
            _downLable.text = @"等待下载";
            break;
        case CJDownloading:
            _downLable.text = @"下载中...";
            break;
        case CJDownloadPause:
            _downLable.text = @"暂停下载";
            break;
        case CJDownloaded:
            _downLable.text = @"已下载";
            break;
        default:
            _downLable.text = @"点击下载";
            break;
    }
}

@end
