//
//  ViewController.m
//  Multithread_Demo
//
//  Created by Lzz on 2017/7/21.
//  Copyright © 2017年 Lzz. All rights reserved.
//

#import "ViewController.h"
#import "NSThread_VC.h"
#import "NSOperation_VC.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(20, 80, 100, 30);
    btn.backgroundColor = [UIColor blueColor];
    [btn setTitle:@"NSThread" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickNSThread) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(20, 120, 100, 30);
    btn.backgroundColor = [UIColor blueColor];
    [btn setTitle:@"NSOperation" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickNSOperation) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)clickNSThread
{
    [self presentViewController:[NSThread_VC new] animated:YES completion:nil];
}

- (void)clickNSOperation
{
    [self presentViewController:[NSOperation_VC new] animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
