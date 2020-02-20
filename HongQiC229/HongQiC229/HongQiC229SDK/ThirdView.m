//
//  ThirdView.m
//  HongQiC229
//
//  Created by 李卓轩 on 2019/12/12.
//  Copyright © 2019 Parry. All rights reserved.
//

#import "ThirdView.h"

@implementation ThirdView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor clearColor];
    [self setWebView];
    return self;
    
}
- (void)setWebView{
    UIWebView *web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    NSString *str = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:str]];
    web.delegate = self;
    
    [self addSubview:web];

    [web loadRequest:req];

}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSString *str = [NSString stringWithFormat:@"%@",request.URL.host];
    if ([str containsString:@"JsTest="]) {
        [str substringFromIndex:6];
        NSLog(@"%@",str);
        NSDictionary *all = [self readLocalFileWithName:@"zy_news"];
        NSArray *array = [all objectForKey:@"RECORDS"];
    
        for (NSDictionary *d in array) {
            NSString *caid = [NSString stringWithFormat:@"%@",d[@"caid"]];
            if ([caid isEqualToString:@"1896"]) {
                self.jumpToDetail(d);
            }
        }
    }
    
    return YES;
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

@end
