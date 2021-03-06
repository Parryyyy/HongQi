//
//  C229LoadingViewController.m
//  HongQiC229
//
//  Created by 李卓轩 on 2020/2/20.
//  Copyright © 2020 Parry. All rights reserved.
//

#import "C229LoadingViewController.h"
#import "AppFaster.h"
#import "HQ229MainViewController.h"
#import "NetWorkManager.h"
#import "DownLoadViewViewController.h"
@interface C229LoadingViewController ()

@end

@implementation C229LoadingViewController
{
    NSMutableDictionary *zipSucDic;
    NSMutableArray *fileNameArr;
    NSString *newVersion;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    zipSucDic = [NSMutableDictionary dictionary];
    fileNameArr = [NSMutableArray array];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(disMiss) name:@"dismiss" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumpMain) name:@"unziped" object:nil];
    
    //横屏
    if ( [[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)] ) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = UIInterfaceOrientationLandscapeLeft;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
    // Do any additional setup after loading the view.
    UIImageView *back = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [back setImage:[UIImage imageNamed:@"c229loading"]];
    [self.view addSubview:back];
    
    NSUserDefaults *user =  [NSUserDefaults standardUserDefaults];
    if (![user objectForKey:@"c229NowVersion"]) {
        [NetWorkManager requestGETSuperAPIWithURLStr:@"hongqih9_admin/index.php?m=home&c=index&a=get_first_version" WithAuthorization:@"" paramDic:nil finish:^(id  _Nonnull responseObject) {
            DownLoadViewViewController *vc = [[DownLoadViewViewController alloc] init];
            vc.myDic = responseObject;
//            HQ229MainViewController *vc = [[HQ229MainViewController alloc] init];
            [self presentViewController:vc animated:NO completion:nil];
        } enError:^(NSError * _Nonnull error) {
            
        } andShowLoading:YES];
    }else{
        NSString *version = [user objectForKey:@"c229NowVersion"];
        
        NSString *uri = [NSString stringWithFormat:@"hongqih9_admin/index.php?m=home&c=index&a=get_new_info&version_no=%@",version];
        [NetWorkManager requestGETSuperAPIWithURLStr:uri WithAuthorization:@"" paramDic:nil finish:^(id  _Nonnull responseObject) {
           [self jumpMain];
            
            if ([version isEqualToString:[NSString stringWithFormat:@"%@",responseObject[@"version"]]]) {
                return ;
            }
            self->newVersion = [NSString stringWithFormat:@"%@",responseObject[@"version"]];
            [self->zipSucDic setValue:@"0" forKey:@"category"];
            [zipSucDic setValue:@"0" forKey:@"news"];
            NSArray *urlArr = responseObject[@"zip_address"];
            for (int x = 0; x<urlArr.count; x++) {
                NSString *longFile = urlArr[x];
                NSString *fileName = [[longFile componentsSeparatedByString:@"/"] lastObject];
                [fileNameArr addObject:fileName];
                [zipSucDic setValue:@"0" forKey:fileName];
                NSString *zipUrl = [urlArr[x] stringByReplacingOccurrencesOfString:@"http" withString:@"https"];
                
                
                NSURL *downloadURL1 = [NSURL URLWithString:zipUrl];
                NSURLRequest *request1 = [NSURLRequest requestWithURL:downloadURL1];
                NSURLSessionDownloadTask *downloadTask1 = [[AFHTTPSessionManager manager] downloadTaskWithRequest:request1 progress:^(NSProgress * _Nonnull downloadProgress) {
                    NSLog(@"download1 progress : %.2f%%", 1.0f * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount * 100);
                    
                } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
                    NSString *fileName = response.suggestedFilename;
                    //返回文件的最终存储路径
                    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                    NSString *documentsDirectory = [paths objectAtIndex:0];
                    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
                    
                    return [NSURL fileURLWithPath:filePath];
                    
                } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
                    if (error) {
                        NSLog(@"download1 file failed : %@", [error description]);
                    
                    }else {
                        [self zipLoad:[NSString stringWithFormat:@"%@",filePath]];
                    }
                    
                }];
                [downloadTask1 resume];
            }
            
            //category
            NSString *catUrl = [NSString stringWithFormat:@"%@",responseObject[@"category"]];
            catUrl = [catUrl stringByReplacingOccurrencesOfString:@"http" withString:@"https"];
            NSURL *downloadURL2 = [NSURL URLWithString:catUrl];
            NSURLRequest *request2 = [NSURLRequest requestWithURL:downloadURL2];
            NSURLSessionDownloadTask *downloadTask2 = [[AFHTTPSessionManager manager] downloadTaskWithRequest:request2 progress:^(NSProgress * _Nonnull downloadProgress) {
                NSLog(@"download2 progress : %.2f%%", 1.0f * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount * 100);
                
            } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
                NSString *fileName = @"229_category.json";
                //返回文件的最终存储路径
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentsDirectory = [paths objectAtIndex:0];
                NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
                return [NSURL fileURLWithPath:filePath];
                
            } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
                if (error) {
                    NSLog(@"download2 file failed : %@", [error description]);
                
                }else {
                    NSLog(@"download2 file success");
                    [self->zipSucDic setValue:@"1" forKey:@"category"];
                    [self isDownloaded];
                }
                
            }];
            
            [downloadTask2 resume];
            //news
            NSString *newUrl = [NSString stringWithFormat:@"%@",responseObject[@"news"]];
            newUrl = [newUrl stringByReplacingOccurrencesOfString:@"http" withString:@"https"];
            NSURL *downloadURL3 = [NSURL URLWithString:newUrl];
            NSURLRequest *request3 = [NSURLRequest requestWithURL:downloadURL3];
            NSURLSessionDownloadTask *downloadTask3 = [[AFHTTPSessionManager manager] downloadTaskWithRequest:request3 progress:^(NSProgress * _Nonnull downloadProgress) {
                NSLog(@"download1 progress : %.2f%%", 1.0f * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount * 100);
                
            } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
                NSString *fileName = @"229_news.json";
                //返回文件的最终存储路径
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentsDirectory = [paths objectAtIndex:0];
                NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
                return [NSURL fileURLWithPath:filePath];
                
            } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
                if (error) {
                    NSLog(@"download1 file failed : %@", [error description]);
                
                }else {
                    NSLog(@"download1 file success");
                    [zipSucDic setValue:@"1" forKey:@"news"];
                    [self isDownloaded];
                }
                
            }];
            [downloadTask3 resume];
                } enError:^(NSError * _Nonnull error) {
                    
                } andShowLoading:YES];
    }
    
}

- (void)jumpMain{
    HQ229MainViewController *vc = [[HQ229MainViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}
- (void)disMiss{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)zipLoad:(NSString *)filePath{
    
    NSString *allPath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0];
    NSString *folderPath = [allPath stringByAppendingPathComponent:@"c229App/images/ppp"];
//    folderPath = [folderPath stringByAppendingPathComponent:@"images/xxx"];
    //
    NSString *fromFile = [filePath substringFromIndex:7];
    //
    
     __weak typeof(self) weakSelf = self;
    [SSZipArchive unzipFileAtPath:fromFile toDestination:folderPath overwrite:YES password:nil progressHandler:^(NSString * _Nonnull entry, unz_file_info zipInfo, long entryNumber, long total) {

    } completionHandler:^(NSString * _Nonnull path, BOOL succeeded, NSError * _Nullable error) {
        if (!error) {
            NSString *fileName = [[path componentsSeparatedByString:@"/"] lastObject];
            [zipSucDic setValue:@"1" forKey:fileName];
            [self isDownloaded];
        }
    }];

}
- (BOOL)isDownloaded{
    BOOL x = YES;
    for (NSString *name in fileNameArr) {
        NSString *status = [zipSucDic objectForKey:name];
        if ([status isEqualToString:@"0"]) {
            x = NO;
        }
    }
    if ([[zipSucDic objectForKey:@"news"] isEqualToString:@"0"]) {
        x = NO;
    }
    if ([[zipSucDic objectForKey:@"category"] isEqualToString:@"0"]) {
        x = NO;
    }
    if (x) {
        [[NSUserDefaults standardUserDefaults] setObject:newVersion forKey:@"c229NowVersion"];
    }
    return x;
}

@end
