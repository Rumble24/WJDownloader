//
//  ViewController.m
//  DownloadManager
//
//  Created by 王景伟 on 2019/5/8.
//  Copyright © 2019 王景伟. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "HJDownLoadManager.h"


//推荐
#define WJEssenceRecommendURL @"http://s.budejie.com/topic/list/jingxuan/1/bs0315-iphone-4.2/0-20.json"

//视频
#define WJEssenceVideoURL @"http://s.budejie.com/topic/list/jingxuan/41/bs0315-iphone-4.2/0-20.json"

//图片
#define WJEssencePictureURL @"http://s.budejie.com/topic/list/jingxuan/10/bs0315-iphone-4.2/0-20.json"

//段子
#define WJEssenceTextURL @"http://s.budejie.com/topic/tag-topic/64/hot/bs0315-iphone-4.2/0-20.json"

//网红
#define WJEssenceStartURL @"http://s.budejie.com/topic/tag-topic/3096/hot/bs0315-iphone-4.2/0-20.json"

//排行
#define WJEssenceListsURL @"http://s.budejie.com/topic/list/remen/1/bs0315-iphone-4.2/0-20.json"

//社会
#define WJEssenceSocietyURL @"http://s.budejie.com/topic/tag-topic/473/hot/bs0315-iphone-4.2/0-20.json"

//美女
#define WJEssenceGirlURL @"http://s.budejie.com/topic/tag-topic/117/hot/bs0315-iphone-4.2/0-20.json"

//冷知识
#define WJEssenceColdURL @"http://s.budejie.com/topic/tag-topic/3176/hot/bs0315-iphone-4.2/0-20.json"

//游戏
#define WJEssenceGameURL @"http://s.budejie.com/topic/tag-topic/164/hot/bs0315-iphone-4.2/0-20.json"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,NSURLSessionDelegate,NSURLSessionDownloadDelegate>
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, strong) AFHTTPSessionManager *manager;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    ///> 实现了 从navc下面开始计算坐标
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.navigationItem.title = @"显示页面 点击加入下载队列";

    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64 - 49) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 100;
    [_tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"ShowTableViewCell"];
    [self.view addSubview:_tableView];
    
    _dataArr = [NSMutableArray array];
    [_dataArr addObject:@{@"name":@"下载地址1",@"address":@"https://asp.cntv.myalicdn.com/asp/hls/450/0303000a/3/default/c68e967a22564821a430d21a75fcd34d/450.m3u8"}];
    [_dataArr addObject:@{@"name":@"下载地址2",@"address":@"https://asp.cntv.myalicdn.com/asp/hls/450/0303000a/3/default/8218d6ea28d34c00a25b112e40973241/450.m3u8"}];
    [_dataArr addObject:@{@"name":@"下载地址3",@"address":@"https://asp.cntv.myalicdn.com/asp/hls/450/0303000a/3/default/6a2785dbbc9d4e3d8760caf1f6878346/450.m3u8"}];
    [_dataArr addObject:@{@"name":@"下载地址4",@"address":@"https://asp.cntv.myalicdn.com/asp/hls/450/0303000a/3/default/96a29bdaed2f4ef0862658805d21e1cf/450.m3u8"}];
    [_dataArr addObject:@{@"name":@"下载地址5",@"address":@"https://asp.cntv.myalicdn.com/asp/hls/450/0303000a/3/default/ccac9b3427354c4e8a875e65a46c0ebd/450.m3u8"}];
    [_dataArr addObject:@{@"name":@"下载地址6",@"address":@"https://asp.cntv.myalicdn.com/asp/hls/450/0303000a/3/default/e8556ed43d1e4fdcbb76e9032d555559/450.m3u8"}];
    [_dataArr addObject:@{@"name":@"下载地址7",@"address":@"https://asp.cntv.myalicdn.com/asp/hls/450/0303000a/3/default/855d8a42c2fe47e68edf39c34cb6923b/450.m3u8"}];
    [_dataArr addObject:@{@"name":@"下载地址8",@"address":@"https://asp.cntv.myalicdn.com/asp/hls/450/0303000a/3/default/6e861b0835c646f98ba46d6336fb8c7d/450.m3u8"}];
    [_dataArr addObject:@{@"name":@"下载地址9",@"address":@"https://asp.cntv.myalicdn.com/asp/hls/450/0303000a/3/default/69ddd35ba27945799e08ab05494623ba/450.m3u8"}];
    [_dataArr addObject:@{@"name":@"下载地址10",@"address":@"https://asp.cntv.myalicdn.com/asp/hls/450/0303000a/3/default/0c1f038dc8eb4091a6462ff92453f8f1/450.m3u8"}];
    [_dataArr addObject:@{@"name":@"下载地址11",@"address":@"https://asp.cntv.myalicdn.com/asp/hls/450/0303000a/3/default/df30239d48c14f189c834fa9b51bc929/450.m3u8"}];
    [_dataArr addObject:@{@"name":@"下载地址12",@"address":@"https://asp.cntv.myalicdn.com/asp/hls/450/0303000a/3/default/bf63a85d13f044dca9c3049d919d6074/450.m3u8"}];
    [_dataArr addObject:@{@"name":@"下载地址13",@"address":@"https://asp.cntv.myalicdn.com/asp/hls/450/0303000a/3/default/034d87b9e3834d939eec5b0b0b4680a7/450.m3u8"}];
    [_dataArr addObject:@{@"name":@"下载地址13",@"address":@"https://asp.cntv.myalicdn.com/asp/hls/450/0303000a/3/default/6f92405b38344f6cbb309202efc06f25/450.m3u8"}];

    [_dataArr addObject:@{@"name":@"国家宝藏1",@"address":@"https://asp.cntv.myalicdn.com/asp/hls/450/0303000a/3/default/a550d40044154aa396f0b83e0a5ead42/450.m3u8"}];
    [_dataArr addObject:@{@"name":@"国家宝藏2",@"address":@"https://asp.cntv.myalicdn.com/asp/hls/450/0303000a/3/default/593300fc0924457eaee26a1b504ab7c5/450.m3u8"}];
    [_dataArr addObject:@{@"name":@"国家宝藏3",@"address":@"https://asp.cntv.myalicdn.com/asp/hls/450/0303000a/3/default/7610a5ec3a934a09832daa19de299abd/450.m3u8"}];
    [_dataArr addObject:@{@"name":@"国家宝藏4",@"address":@"https://asp.cntv.myalicdn.com/asp/hls/450/0303000a/3/default/86a1b5b583f345b79ee96fd738fcf8ed/450.m3u8"}];
    [_dataArr addObject:@{@"name":@"国家宝藏5",@"address":@"https://asp.cntv.myalicdn.com/asp/hls/450/0303000a/3/default/4ef9b16218a94990ad267ea0b0d9b53c/450.m3u8"}];
    [_dataArr addObject:@{@"name":@"国家宝藏6",@"address":@"https://asp.cntv.myalicdn.com/asp/hls/450/0303000a/3/default/7688bd4dec98421db9f3502fe046706c/450.m3u8"}];
    [_dataArr addObject:@{@"name":@"国家宝藏7",@"address":@"https://asp.cntv.myalicdn.com/asp/hls/450/0303000a/3/default/cf2d166ace774c438de09c99e2435d00/450.m3u8"}];
    [_dataArr addObject:@{@"name":@"国家宝藏8",@"address":@"https://asp.cntv.myalicdn.com/asp/hls/450/0303000a/3/default/50e4ec305ffb423bbe66f78d7dbc90d2/450.m3u8"}];
    [_dataArr addObject:@{@"name":@"国家宝藏9",@"address":@"https://asp.cntv.myalicdn.com/asp/hls/450/0303000a/3/default/d4cad7e4f0c14af19ae6b35ee6c85ab5/450.m3u8"}];
    
    NSString *requestUrl = @"https://www.apple.com/105/media/cn/iphone-x/2017/01df5b43-28e4-4848-bf20-490c34a926a7/films/feature/iphone-x-feature-cn-20170912_1280x720h.mp4";
    [[HJDownLoadManager sharedManager] downLoadWithUrl:requestUrl];
    
    
    NSString *localPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    
    // 要检查的文件目录
    NSString *filePath = [localPath  stringByAppendingPathComponent:@"Tiger_Trade_latest.dmg"];
    NSURL *fileUrl = [NSURL fileURLWithPath:filePath isDirectory:NO];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestUrl]];
    NSURLSessionDownloadTask   *downloadTask = [[AFHTTPSessionManager manager]downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"旧  %F",(1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount));
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return fileUrl;
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
    }];
    
    [downloadTask resume];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShowTableViewCell" forIndexPath:indexPath];
    NSDictionary *dic = _dataArr[indexPath.row];
    cell.textLabel.text = dic[@"name"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
@end
