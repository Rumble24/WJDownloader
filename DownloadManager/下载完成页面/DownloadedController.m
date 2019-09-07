//
//  DownloadedController.m
//  DownloadManager
//
//  Created by 王景伟 on 2019/5/15.
//  Copyright © 2019 王景伟. All rights reserved.
//

#import "DownloadedController.h"
#import "HJDownLoadManager.h"

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downLoadFinish) name:HJDownLoadManagerTaskDidCompleteNotification object:nil];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64 - 49) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 100;
    [_tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"ShowTableViewCell11"];
    [self.view addSubview:_tableView];
}


- (void)downLoadFinish {
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSLog(@"%@",[HJDownLoadManager sharedManager].downloadedArr);
    return [HJDownLoadManager sharedManager].downloadedArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShowTableViewCell11" forIndexPath:indexPath];
    CJDownloadModel *model = [HJDownLoadManager sharedManager].downloadedArr[indexPath.row];
    cell.textLabel.text = model.title;
    
    NSLog(@"%@",model.title);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
@end
