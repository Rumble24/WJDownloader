//
//  DownloadedController.m
//  DownloadManager
//
//  Created by 王景伟 on 2019/5/15.
//  Copyright © 2019 王景伟. All rights reserved.
//

#import "DownloadedController.h"
#import "HJDownLoadManager.h"
#import "ShowTableViewCell.h"

@interface DownloadedController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@end


@implementation DownloadedController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"下载页面";
    
    ///> 实现了 从navc下面开始计算坐标
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downLoadFinish) name:HJDownLoadManagerTaskDidCompleteNotification object:nil];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64 - 49) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 100;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    ///>  解决刷新的时候跳动的问题
    _tableView.estimatedRowHeight = 0;
    
    [_tableView registerClass:ShowTableViewCell.class forCellReuseIdentifier:@"ShowTableViewCell11"];
    [self.view addSubview:_tableView];
}


- (void)downLoadFinish {
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [HJDownLoadManager sharedManager].downloadedArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShowTableViewCell11" forIndexPath:indexPath];
    CJDownloadModel *model = [HJDownLoadManager sharedManager].downloadedArr[indexPath.row];
    cell.model = model;
    return cell;
}


#pragma mark - 左滑删除
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

// 定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

// 进入编辑模式，按下出现的编辑按钮后,进行删除操作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        CJDownloadModel *model = [HJDownLoadManager sharedManager].downloadedArr[indexPath.row];
        [[HJDownLoadManager sharedManager] delegateDownloadedModel:model];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView reloadData];
    }
}

// 修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CJDownloadModel *model = [HJDownLoadManager sharedManager].downloadedArr[indexPath.row];
    NSLog(@"点击播放  title:%@  %@",model.title,[[HJDownLoadManager sharedManager] filePathWithModel:model]);
}
@end
