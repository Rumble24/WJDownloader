//
//  ShowTableViewCell.h
//  DownloadManager
//
//  Created by 王景伟 on 2019/5/21.
//  Copyright © 2019 王景伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CJDownloadModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ShowTableViewCell : UITableViewCell

@property (nonatomic, strong) CJDownloadModel *model;

@end

NS_ASSUME_NONNULL_END
