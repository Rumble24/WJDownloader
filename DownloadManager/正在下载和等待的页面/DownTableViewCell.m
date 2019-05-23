//
//  ShowTableViewCell.m
//  DownloadManager
//
//  Created by 王景伟 on 2019/5/15.
//  Copyright © 2019 王景伟. All rights reserved.
//  开始  下载。等待 只有5个同时下载。点击其他会没有任何的反应。 点击其中一个暂停那么会开启另外一个下载

#import "DownTableViewCell.h"
#import "HJDownLoadManager.h"

#define kH [[UIScreen mainScreen] bounds].size.height
#define kW [[UIScreen mainScreen] bounds].size.width

@interface DownTableViewCell ()
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *button;
@end

@implementation DownTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    _progressView = [[UIProgressView alloc]init];
    _progressView.frame = CGRectMake(10, 20, kW - 20, 30);
    [self.contentView addSubview:_progressView];
    
    _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 50, kW / 3.0, 50)];
    _label.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_label];
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(kW / 3.0, 50, kW / 3.0, 50)];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_titleLabel];
    
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    _button.frame = CGRectMake(kW / 3.0 * 2, 50, kW / 3.0, 50);
    _button.backgroundColor = [UIColor lightGrayColor];
    [_button setImage:[UIImage imageNamed:@"downPlay"] forState:UIControlStateNormal];
    [_button setImage:[UIImage imageNamed:@"downPause"] forState:UIControlStateSelected];
    [_button addTarget:self action:@selector(buttonClick:) forControlEvents:1<<6];
    [self.contentView addSubview:_button];

    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.layer.cornerRadius = 10;

    return self;
}

- (void)setModel:(CJDownloadModel *)model {
    _model = model;
    _titleLabel.text = model.title;
    
    _progressView.hidden = YES;
    
    switch (model.downloadState) {
        case CJDownloadWaiting:
            _label.text = @"等待下载";
            break;
        case CJDownloading: {
            _label.text = @"正在下载";
            _progressView.hidden = NO;
            __weak typeof(self) weakSelf = self;
            [[HJDownLoadManager sharedManager] setDownloadProgressBlock:^(float progress) {
                weakSelf.progressView.progress = progress;
                weakSelf.label.text = [NSString stringWithFormat:@"%.2f%%",progress * 100];
            }];
        } break;
        case CJDownloadPause:
            _label.text = @"暂停下载";
            break;
        default:
            _label.text = @"错误状态";
            break;
    }
}


- (void)buttonClick:(UIButton *)but {
    but.selected = !but.isSelected;
}

@end
