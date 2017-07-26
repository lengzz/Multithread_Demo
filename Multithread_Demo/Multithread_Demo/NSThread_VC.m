//
//  NSThread_VC.m
//  Multithread_Demo
//
//  Created by Lzz on 2017/7/21.
//  Copyright © 2017年 Lzz. All rights reserved.
//

#import "NSThread_VC.h"

@interface NSThread_VC ()
{
    NSRunLoop *_curRunLoop;
}
@property (nonatomic, strong) NSThread *curThread;
@property (nonatomic, strong) NSMachPort *emptyPort;
@end

@implementation NSThread_VC

- (void)dealloc
{
    NSLog(@"NSThread_VC dealloc  %@",self.curThread);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(20, 27, 80, 30);
    backBtn.backgroundColor = [UIColor blueColor];
    [backBtn setTitle:@"back" forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(20, 80, 80, 30);
    btn.backgroundColor = [UIColor blueColor];
    [btn setTitle:@"Run" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(setRunloop) object:nil];
    thread.name = @"custom thread";
    self.curThread = thread;
    [thread start];
}

- (void)back
{
    if (self.curThread) {
        [self performSelector:@selector(exitThread) onThread:self.curThread withObject:nil waitUntilDone:NO];
    }
    
//    CFRunLoopStop(self.curThread.getCFRunLoop);
//    if(!self.curThread)
        [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 
#pragma mark - 开启线程Runloop
- (void) setRunloop
{
    @autoreleasepool {
        NSLog(@"current thread = %@", [NSThread currentThread]);
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        
        CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(CFAllocatorGetDefault(), kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
            
            NSLog(@"CFRunLoopActivity -->%zd",activity);
            
        });
        
        CFRunLoopAddObserver(runLoop.getCFRunLoop, observer, kCFRunLoopDefaultMode);
        CFRelease(observer);
        
        if (!self.emptyPort) {
            self.emptyPort = [NSMachPort port];
        }
        [runLoop addPort:self.emptyPort forMode:NSDefaultRunLoopMode];
        _curRunLoop = runLoop;
        CFRunLoopRun();
    }
}

#pragma mark -
#pragma mark - 手动添加任务到线程
- (void)click
{
    if (self.curThread) {
        [self performSelector:@selector(dosomething:) onThread:self.curThread withObject:[NSDate date] waitUntilDone:NO];
    }
}

- (void) dosomething:(NSDate *)date
{
    NSLog(@"121   %@-----%@",date,[NSThread currentThread]);
    
    for (NSInteger i = 0; i < 10000; i ++) {
        
    }
}

- (void)exitThread
{
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    CFRunLoopStop(runLoop.getCFRunLoop);
    self.curThread = nil;
}

- (void)exit
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
