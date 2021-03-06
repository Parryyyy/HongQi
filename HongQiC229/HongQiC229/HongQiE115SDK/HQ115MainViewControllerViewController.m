//
//  HQ115MainViewControllerViewController.m
//  HongQiC229
//
//  Created by 李卓轩 on 2020/1/16.
//  Copyright © 2020 Parry. All rights reserved.
//

#import "HQ115MainViewControllerViewController.h"

#import "AppFaster.h"
#import "TopTabViewE115.h"
#define TopHeight 60
#import "FirstViewE115.h"
#import "SecondView115.h"
#import "ThirdViewE115.h"
#import "ForthViewE115.h"
#import "FifthViewE115.h"
#import "DownLoadViewViewController.h"
#import "DetailViewControllerE115.h"
@interface HQ115MainViewControllerViewController ()

@end

@implementation HQ115MainViewControllerViewController

{
    UIScrollView *myScrollView;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //横屏
    if ( [[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)] ) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = UIInterfaceOrientationLandscapeRight;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
    //background
    UIImageView *backGround = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [backGround setImage:[UIImage imageNamed:@"homeBackground_115"]];
    [self.view addSubview:backGround];
    //topView
    TopTabViewE115 *top = [[TopTabViewE115 alloc] initWithFrame:CGRectMake(100, 0, kScreenWidth-120, TopHeight)];
    [top reset];
    top.seleced = ^(NSInteger index) {
        myScrollView.contentOffset = CGPointMake(index *kScreenWidth, 0);
    };
    //closeBtn
    UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 10, 80, 50)];
    [closeBtn setImage:[UIImage imageNamed:@"CL_WDG_Status_Home_N_115"] forState:UIControlStateNormal];
//    [closeBtn setImage:[UIImage imageNamed:@"CL_WDG_Status_Home_P"] forState:UIControlStateHighlighted];
    [closeBtn addTarget:self action:@selector(goDonwLoad) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeBtn];
    
    [self.view addSubview:top];
    [self setScrollView];
    [self doDB];
    [self getJson];
    

}

- (void)setScrollView{
    myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, TopHeight, kScreenWidth, kScreenHeight-TopHeight)];
    [self.view addSubview:myScrollView];
    myScrollView.contentSize = CGSizeMake(5*kScreenWidth, kScreenHeight-TopHeight);
    myScrollView.scrollEnabled = NO;
    myScrollView.showsVerticalScrollIndicator = NO;
    myScrollView.showsHorizontalScrollIndicator = NO;
    
    FirstViewE115 *first = [[FirstViewE115 alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-TopHeight)];
    [myScrollView addSubview:first];
    first.jumpToDetail = ^(NSDictionary * dataDic) {
        DetailViewControllerE115 *detail = [[DetailViewControllerE115 alloc] init];
        self.definesPresentationContext = YES;
        detail.modalPresentationStyle =UIModalPresentationOverFullScreen;
        detail.dataDic = dataDic;
        [self presentViewController:detail animated:YES completion:nil];
    };

    SecondView115 *second = [[SecondView115 alloc] initWithFrame:CGRectMake(kScreenWidth*3, 0, kScreenWidth, kScreenHeight-TopHeight)];
    [myScrollView addSubview:second];
    
    ThirdViewE115 *third = [[ThirdViewE115 alloc] initWithFrame:CGRectMake(kScreenWidth*2, 0, kScreenWidth, kScreenHeight-TopHeight)];
    
    third.jumpToDetail = ^(NSDictionary * dataDic) {
        DetailViewControllerE115 *detail = [[DetailViewControllerE115 alloc] init];
        self.definesPresentationContext = YES;
        detail.modalPresentationStyle =UIModalPresentationOverFullScreen;
        detail.dataDic = dataDic;
        [self presentViewController:detail animated:YES completion:nil];
    };
    [myScrollView addSubview:third];
    
    SecondView115 *forth = [[SecondView115 alloc] initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight-TopHeight)];
//    forth.push = ^(NSDictionary * dataDic) {
//        DetailViewControllerE115 *detail = [[DetailViewControllerE115 alloc] init];
//        self.definesPresentationContext = YES;
//        detail.modalPresentationStyle =UIModalPresentationOverFullScreen;
//        detail.dataDic = dataDic;
//        [self presentViewController:detail animated:YES completion:nil];
//    };
    [myScrollView addSubview:forth];
    
    FifthViewE115 *fifth = [[FifthViewE115 alloc] initWithFrame:CGRectMake(kScreenWidth*4, 0, kScreenWidth, kScreenHeight-TopHeight)];
    
    [myScrollView addSubview:fifth];
}
- (void)getJson{
    NSDictionary *dicOne = [self readLocalFileWithName:@"115_category"];
    NSArray *dataArr = dicOne[@"RECORDS"];
    NSString *sqlStr = [self returnSqlKeys:dataArr[0]];
    
    for (NSDictionary *dic in dataArr) {
        
        NSMutableString *wenhao = [NSMutableString string];
        for (NSString *key in [dic allKeys]) {
            wenhao = [wenhao stringByAppendingFormat:@"?,"];
        }
        NSString *wenhaoLL = [wenhao substringToIndex:wenhao.length-1];
        
        NSString *sqlInsert = [NSString stringWithFormat:@"insert into 'category'(%@) values(%@)",[self sqlKeys:[dic allKeys]],wenhaoLL];
        
    }
    
}
- (void)doDB{
    NSString *docuPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *dbPath = [docuPath stringByAppendingPathComponent:@"category.db"];
    NSLog(@"!!!dbPath = %@",dbPath);
     //2.创建对应路径下数据库
    
}
- (NSDictionary *)readLocalFileWithName:(NSString *)name {
    // 获取文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"json"];
    // 将文件数据化
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    // 对数据进行JSON格式化并返回字典形式
    NSError *error;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (!error) {
        return dic;
    }else{
        return nil;
    }
}
- (NSString *)returnSqlKeys:(NSDictionary *)dic{
    
    NSMutableString *str = [NSMutableString string];
    for (NSString *key in [dic allKeys]) {
        NSString *new = [NSString stringWithFormat:@"'%@' TEXT NOT NULL,",key];
        str = [str stringByAppendingFormat:@"%@", new];
    }
    NSString *last = [NSString stringWithFormat:@"%@",str];
    
    return [last substringToIndex:last.length-1];
}
- (NSString *)sqlKeys:(NSArray *)keys{
    NSMutableString *keyStr = [NSMutableString string];
    for (NSString *str in keys) {
        keyStr = [keyStr stringByAppendingFormat:@"%@,",str];
    }
    return [keyStr substringToIndex:keyStr.length-1];
}
- (NSArray *)sqlValues:(NSDictionary *)dataDic andKeyArr:(NSArray *)keyArr{
    NSMutableArray *valueArr = [NSMutableArray array];
    for (NSString *key in keyArr) {
        NSString *value = [NSString stringWithFormat:@"%@",dataDic[key]];
        [valueArr addObject:value];
    }
    return valueArr;
}
- (void)goDonwLoad{
    DownLoadViewViewController *vc = [[DownLoadViewViewController alloc] init];
    self.definesPresentationContext = YES;
    vc.modalPresentationStyle =UIModalPresentationOverFullScreen;
    [self presentViewController:vc animated:NO completion:nil];
}

@end
