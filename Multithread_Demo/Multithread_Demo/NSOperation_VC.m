//
//  NSOperation_VC.m
//  Multithread_Demo
//
//  Created by Lzz on 2017/7/21.
//  Copyright © 2017年 Lzz. All rights reserved.
//

#import "NSOperation_VC.h"

@interface NSOperation_VC ()
{
    UITextView *_logV;
}

@end

@implementation NSOperation_VC

- (void)dealloc
{
    NSLog(@"NSOperation_VC dealloc !!!");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    UITextView *logV = [[UITextView alloc] initWithFrame:CGRectMake(15, self.view.frame.size.height - 80, self.view.frame.size.width - 30, 60)];
    logV.textColor = [UIColor redColor];
    _logV = logV;
    [self.view addSubview:logV];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(20, 27, 80, 30);
    backBtn.backgroundColor = [UIColor blueColor];
    [backBtn setTitle:@"back" forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    //NSInvocationOperation
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(20, 80, 180, 30);
    btn.backgroundColor = [UIColor blueColor];
    [btn setTitle:@"单独使用Invocation" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(invocationClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    //NSBlockOperation
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(20, 120, 180, 30);
    btn.backgroundColor = [UIColor blueColor];
    [btn setTitle:@"单独使用Block" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(blockClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(20, 160, 180, 30);
    btn.backgroundColor = [UIColor blueColor];
    [btn setTitle:@"使用OperationQueue" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(queueClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)invocationClick
{
    NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(run) object:nil];
    [op start];
}

- (void)blockClick
{
    /**
     *  单独使用任务只会在主线程运行，addExecutionBlock 则会新开辟线程
     */
    NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
        @synchronized(self)
        {
            _logV.text = @"";
            _logV.text = [NSString stringWithFormat:@"1  Current Theard %@",[NSThread currentThread]];
        }
        
    }];
    
    [op addExecutionBlock:^{
        @synchronized (self) {
            NSString *string = [NSString stringWithFormat:@"%@ 2  addExecutionBlock  Current Theard %@",_logV.text,[NSThread currentThread]];
            dispatch_async(dispatch_get_main_queue(), ^{
                _logV.text = string;
            });
        }
        
    }];
    [op start];
}

- (void)queueClick
{
    //主队列
//    NSOperationQueue *mainQ = [NSOperationQueue mainQueue];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    //最大并发数：1 标示串行，-1 默认不限制
    queue.maxConcurrentOperationCount = -1;
    
    NSInvocationOperation *op1 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(run:) object:@1];
    NSInvocationOperation *op2 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(run:) object:@2];
    NSBlockOperation *op3 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"%@   %@",@3,[NSThread currentThread]);
    }];
    
    //添加任务依赖：op3 需要等待op2,op1运行完才开始运行
    [op3 addDependency:op1];
    [op3 addDependency:op2];
    
    [queue addOperation:op3];
    [queue addOperation:op2];
    [queue addOperation:op1];

}

- (void)run:(id)obj
{
    NSLog(@"%@   %@",obj,[NSThread currentThread]);
}

- (void)run
{
    _logV.text = @"";
    _logV.text = [NSString stringWithFormat:@"Current Theard %@",[NSThread currentThread]];
}

- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
