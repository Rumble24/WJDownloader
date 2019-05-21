//
//  TwoViewController.m
//  DownloadManager
//
//  Created by 王景伟 on 2019/5/15.
//  Copyright © 2019 王景伟. All rights reserved.
//

#import "TwoViewController.h"
#import "DownTableViewCell.h"
#import "HJDownLoadManager.h"

@interface TwoViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@end


@implementation TwoViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"下载页面";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downLoadFinish) name:HJDownLoadManagerTaskDidCompleteNotification object:nil];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64 - 49) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 100;
    [_tableView registerClass:DownTableViewCell.class forCellReuseIdentifier:@"ShowTableViewCell"];
    [self.view addSubview:_tableView];
}


- (void)downLoadFinish {
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [HJDownLoadManager sharedManager].downloadArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DownTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShowTableViewCell" forIndexPath:indexPath];
    CJDownloadModel *model = [HJDownLoadManager sharedManager].downloadArr[indexPath.row];
    cell.model = model;
    return cell;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    CJDownloadModel *model = [HJDownLoadManager sharedManager].downloadArr[indexPath.row];
//    model.downloadState = CJDownloadWaiting;
//    [[HJDownLoadManager sharedManager] downLoadWithModel:model];
//    [self.tableView reloadData];
//}

@end
