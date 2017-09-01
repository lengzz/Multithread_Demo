//
//  GCD_VC.m
//  Multithread_Demo
//
//  Created by Lzz on 2017/7/21.
//  Copyright © 2017年 Lzz. All rights reserved.
//

#import "GCD_VC.h"

@interface GCD_VC ()

@property (nonatomic, strong) dispatch_queue_t customQueue;
@property (nonatomic, strong) dispatch_group_t customGroup;

@end

@implementation GCD_VC

- (void)dealloc
{
    NSLog(@"GCD_VC dealloc !!!");
}

- (dispatch_queue_t)customQueue
{
    if (!_customQueue) {
        _customQueue = dispatch_queue_create("customQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _customQueue;
}

- (dispatch_group_t)customGroup
{
    if (!_customGroup) {
        _customGroup = dispatch_group_create();
    }
    return _customGroup;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
