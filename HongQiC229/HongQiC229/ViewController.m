//
//  ViewController.m
//  HongQiC229
//
//  Created by 李卓轩 on 2019/12/12.
//  Copyright © 2019 Parry. All rights reserved.
//

#import "ViewController.h"
#import "HQ229MainViewController.h"
#import "HQ115MainViewControllerViewController.h"
#import "NetWorkManager.h"
#import "C229LoadingViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (IBAction)go:(id)sender {
//    HQ229MainViewController *vc = [[HQ229MainViewController alloc] init];
//    [self presentViewController:vc animated:YES completion:nil];
    C229LoadingViewController *vc = [[C229LoadingViewController alloc] init];
    [self presentViewController:vc animated:NO completion:nil];
//    [NetWorkManager requestGETSuperAPIWithURLStr:@"hs5_admin/index.php?m=home&c=index&a=get_new_info" WithAuthorization:@"" paramDic:nil finish:^(id  _Nonnull responseObject) {
//
//    } enError:^(NSError * _Nonnull error) {
//
//    } andShowLoading:NO];
}
- (IBAction)go115:(id)sender {
    HQ115MainViewControllerViewController *vc = [[HQ115MainViewControllerViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}


@end
