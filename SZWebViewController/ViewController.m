//
//  ViewController.m
//  SZWebViewController
//
//  Created by 陈圣治 on 16/7/15.
//  Copyright © 2016年 陈圣治. All rights reserved.
//

#import "ViewController.h"
#import "SZWebViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (IBAction)presentButtonTapedHandler:(id)sender {
    SZWebViewController *vc = [[SZWebViewController alloc] init];
    vc.urlPath = @"www.baidu.com";
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}


- (IBAction)pushButtonTapedHandler:(id)sender {
    SZWebViewController *vc = [[SZWebViewController alloc] init];
    vc.urlPath = @"www.baidu.com";
    [self.navigationController pushViewController:vc animated:YES];
}

@end
