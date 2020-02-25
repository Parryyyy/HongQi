//
//  SecondView115.m
//  HongQiC229
//
//  Created by 李卓轩 on 2020/1/17.
//  Copyright © 2020 Parry. All rights reserved.
//

#import "SecondView115.h"
#import "AppFaster.h"
#import "ForthCollectionViewCell.h"
#import "Second115TableViewCell.h"
@implementation SecondView115

{
    UIImageView *selImage;
    NSArray *leftArr;
    UICollectionView *myCollection;
    int jianting;
    NSMutableDictionary *allDic;
    UITableView *leftTableView;
    NSMutableArray *cateGGArr;
}
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor clearColor];
    [self loadData];
    
    [self setCollectionView];
    [self setTableView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNoty) name:@"unziped" object:nil];
    jianting = 1;
    
    return self;
}
- (void)getNoty{
    [myCollection reloadData];
}
- (void)loadData{
    NSDictionary *categoryDic = [self readLocalFileWithName:@"115_category"];
    NSArray *catArr = categoryDic[@"RECORDS"];
    NSMutableArray *scArr = [NSMutableArray array];
    cateGGArr = [NSMutableArray array];
    for (NSDictionary *ds in catArr) {
        if ([[NSString stringWithFormat:@"%@",ds[@"parentid"]] isEqualToString:@"1855"]) {
            [scArr addObject:[NSString stringWithFormat:@"%@",ds[@"caid"]]];
            [cateGGArr addObject:ds];
        }
    }
    
    leftArr = cateGGArr;
    NSDictionary *newsDic = [self readLocalFileWithName:@"115_news"];
    NSArray *newArr = newsDic[@"RECORDS"];
   
    allDic =[NSMutableDictionary dictionary];
    for (NSString *catID in scArr) {
        NSMutableArray *catArr = [NSMutableArray array];
        [allDic setObject:catArr forKey:catID];
    }
    for (NSDictionary *dic in newArr) {
        for (NSString *catID in scArr) {
            NSString *catId = catID;
            NSString *newId = [NSString stringWithFormat:@"%@",dic[@"caid"]];
            if ([catId isEqualToString:newId]) {
                NSMutableArray *newArr = [allDic objectForKey:newId];
                [newArr addObject:dic];
                [allDic setObject:newArr forKey:newId];
            }
        }
    }

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
- (void)setCollectionView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = 5.0;
    layout.minimumInteritemSpacing = 5.0;
    layout.sectionInset = UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0);
    
    myCollection = [[UICollectionView alloc] initWithFrame:CGRectMake(50+80, 33, kScreenWidth-50-80-10, self.frame.size.height-33-33) collectionViewLayout:layout];
    myCollection.backgroundColor = [UIColor clearColor];
    myCollection.delegate = self;
    myCollection.dataSource = self;
    [self addSubview:myCollection];
    
    [myCollection registerNib:[UINib nibWithNibName:@"ForthCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ForthCollectionViewCell"];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    for (int i = 0; i<leftArr.count; i++) {
        if (section == i) {
            
            NSString *key = [NSString stringWithFormat:@"%@",leftArr[i][@"caid"]];
            NSMutableArray *arr = [allDic objectForKey:key];
//            NSLog(@"----%ld----section:%d",arr.count,section);
            return arr.count;
        }
    }
    return 0;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return leftArr.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((collectionView.frame.size.width-40)/4, 95);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ForthCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ForthCollectionViewCell" forIndexPath:indexPath];
    NSDictionary *dic;
    NSString *key = [NSString stringWithFormat:@"%@",leftArr[indexPath.section][@"caid"]];
    NSMutableArray *newArr = [allDic objectForKey:key];
    
    dic = newArr[indexPath.row];
    [cell loadWithDataDic:dic andTag:indexPath];
    
    return cell;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section;{
    return 10;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat ySet = scrollView.contentOffset.y;

    if (jianting == 0) {
        return;
    }
    UIButton *b0;UIButton *b1;UIButton *b2;UIButton *b3;UIButton *b4;
    for (UIButton *b in self.subviews) {
        if ([b isKindOfClass:[UIButton class]]) {
            switch (b.tag) {
                case 1000:
                    b0 = b;
                    break;
                 case 1001:
                    b1 = b;
                    break;
                case 1002:
                    b2 = b;
                    break;
                case 1003:
                    b3 = b;
                    break;
                case 1004:
                    b4 = b;
                    break;
                default:
                    break;
            }
            b.selected = NO;
        }
    }
    
    
    UIButton *lastBtn;
    if (ySet<=151) {
        NSLog(@"0");
        lastBtn = b0;
    }
    if (151<ySet&&ySet<=350) {
        NSLog(@"1");
        lastBtn = b1;
    }
    if(350<ySet&&ySet<=449){
        NSLog(@"2");
        lastBtn = b2;
    }
    if (449<ySet&&ySet<=635) {
        NSLog(@"3");
        lastBtn = b3;
    }
    if (ySet>635) {
        NSLog(@"4");
        lastBtn = b4;
    }
    NSString *imgName = [NSString stringWithFormat:@"left%ld",lastBtn.tag-1000];
    [selImage setImage:[UIImage imageNamed:imgName]];
    lastBtn.selected = YES;
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    jianting = 1;
    
}

- (void)setTableView{
    leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 30, 128, 300) style:UITableViewStylePlain];
    leftTableView.backgroundColor = [UIColor clearColor];
    leftTableView.delegate = self;
    leftTableView.dataSource = self;
    leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [leftTableView registerNib:[UINib nibWithNibName:@"Second115TableViewCell" bundle:nil] forCellReuseIdentifier:@"Second115TableViewCell"];
    [self addSubview:leftTableView];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return leftArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Second115TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Second115TableViewCell"];
    [cell loadWithDic:leftArr[indexPath.row]];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 48;
}
@end

