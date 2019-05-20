//
//  ShowTableViewCell.m
//  DownloadManager
//
//  Created by 王景伟 on 2019/5/15.
//  Copyright © 2019 王景伟. All rights reserved.
//  开始  下载。等待 只有5个同时下载。点击其他会没有任何的反应。 点击其中一个暂停那么会开启另外一个下载

#import "DownTableViewCell.h"

@implementation DownTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    return self;
}




- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
