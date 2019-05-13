//
//  ViewController.m
//  DownloadManager
//
//  Created by 王景伟 on 2019/5/8.
//  Copyright © 2019 王景伟. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [NSUserDefaults standardUserDefaults];
    
    [UIApplication sharedApplication];
    
    /*
     
     下载地址：https://asp.cntv.myalicdn.com/asp/hls/450/0303000a/3/default/c68e967a22564821a430d21a75fcd34d/450.m3u8
     2019-05-10 11:11:24.496530+0800 cbox[4561:4593364] 下载地址：https://asp.cntv.myalicdn.com/asp/hls/450/0303000a/3/default/8218d6ea28d34c00a25b112e40973241/450.m3u8
     2019-05-10 11:11:26.468877+0800 cbox[4561:4593364] 下载地址：https://asp.cntv.myalicdn.com/asp/hls/450/0303000a/3/default/6a2785dbbc9d4e3d8760caf1f6878346/450.m3u8
     2019-05-10 11:11:27.663086+0800 cbox[4561:4593364] 下载地址：https://asp.cntv.myalicdn.com/asp/hls/450/0303000a/3/default/96a29bdaed2f4ef0862658805d21e1cf/450.m3u8
     2019-05-10 11:11:28.958704+0800 cbox[4561:4593364] 下载地址：https://asp.cntv.myalicdn.com/asp/hls/450/0303000a/3/default/ccac9b3427354c4e8a875e65a46c0ebd/450.m3u8
     2019-05-10 11:11:29.796937+0800 cbox[4561:4593364] 下载地址：https://asp.cntv.myalicdn.com/asp/hls/450/0303000a/3/default/e8556ed43d1e4fdcbb76e9032d555559/450.m3u8
     2019-05-10 11:11:31.821094+0800 cbox[4561:4593364] 下载地址：https://asp.cntv.myalicdn.com/asp/hls/450/0303000a/3/default/855d8a42c2fe47e68edf39c34cb6923b/450.m3u8
     2019-05-10 11:11:32.505387+0800 cbox[4561:4593364] 下载地址：https://asp.cntv.myalicdn.com/asp/hls/450/0303000a/3/default/6e861b0835c646f98ba46d6336fb8c7d/450.m3u8
     2019-05-10 11:11:33.433205+0800 cbox[4561:4593364] 下载地址：https://asp.cntv.myalicdn.com/asp/hls/450/0303000a/3/default/69ddd35ba27945799e08ab05494623ba/450.m3u8
     2019-05-10 11:11:34.931573+0800 cbox[4561:4593364] 下载地址：https://asp.cntv.myalicdn.com/asp/hls/450/0303000a/3/default/0c1f038dc8eb4091a6462ff92453f8f1/450.m3u8
     2019-05-10 11:11:36.185236+0800 cbox[4561:4593364] 下载地址：https://asp.cntv.myalicdn.com/asp/hls/450/0303000a/3/default/df30239d48c14f189c834fa9b51bc929/450.m3u8
     2019-05-10 11:11:37.046090+0800 cbox[4561:4593364] 下载地址：https://asp.cntv.myalicdn.com/asp/hls/450/0303000a/3/default/bf63a85d13f044dca9c3049d919d6074/450.m3u8
     2019-05-10 11:11:38.773424+0800 cbox[4561:4593364] 下载地址：https://asp.cntv.myalicdn.com/asp/hls/450/0303000a/3/default/034d87b9e3834d939eec5b0b0b4680a7/450.m3u8
     2019-05-10 11:11:39.456184+0800 cbox[4561:4593364] 下载地址：https://asp.cntv.myalicdn.com/asp/hls/450/0303000a/3/default/6f92405b38344f6cbb309202efc06f25/450.m3u8
     
     
     
     ///> 国家宝藏  1 2 3 4 5 6 7 8 9
     2019-05-10 11:12:52.396473+0800 cbox[4561:4593364] 下载地址：https://asp.cntv.myalicdn.com/asp/hls/450/0303000a/3/default/a550d40044154aa396f0b83e0a5ead42/450.m3u8
     2019-05-10 11:12:53.546590+0800 cbox[4561:4593364] 下载地址：https://asp.cntv.myalicdn.com/asp/hls/450/0303000a/3/default/593300fc0924457eaee26a1b504ab7c5/450.m3u8
     2019-05-10 11:12:55.359433+0800 cbox[4561:4593364] 下载地址：https://asp.cntv.myalicdn.com/asp/hls/450/0303000a/3/default/7610a5ec3a934a09832daa19de299abd/450.m3u8
     2019-05-10 11:12:57.198659+0800 cbox[4561:4593364] 下载地址：https://asp.cntv.myalicdn.com/asp/hls/450/0303000a/3/default/86a1b5b583f345b79ee96fd738fcf8ed/450.m3u8
     2019-05-10 11:12:58.295681+0800 cbox[4561:4593364] 下载地址：https://asp.cntv.myalicdn.com/asp/hls/450/0303000a/3/default/4ef9b16218a94990ad267ea0b0d9b53c/450.m3u8
     2019-05-10 11:12:59.275513+0800 cbox[4561:4593364] 下载地址：https://asp.cntv.myalicdn.com/asp/hls/450/0303000a/3/default/7688bd4dec98421db9f3502fe046706c/450.m3u8
     2019-05-10 11:13:00.470450+0800 cbox[4561:4593364] 下载地址：https://asp.cntv.myalicdn.com/asp/hls/450/0303000a/3/default/cf2d166ace774c438de09c99e2435d00/450.m3u8
     2019-05-10 11:13:01.310456+0800 cbox[4561:4593364] 下载地址：https://asp.cntv.myalicdn.com/asp/hls/450/0303000a/3/default/50e4ec305ffb423bbe66f78d7dbc90d2/450.m3u8
     2019-05-10 11:13:02.246238+0800 cbox[4561:4593364] 下载地址：https://asp.cntv.myalicdn.com/asp/hls/450/0303000a/3/default/d4cad7e4f0c14af19ae6b35ee6c85ab5/450.m3u8


     */
}


@end
