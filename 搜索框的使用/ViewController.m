//
//  ViewController.m
//  搜索框的使用
//
//  Created by shipanfeng001 on 15/11/1.
//  Copyright (c) 2015年 91cheliu. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking.h>
#import "CityListModel.h"

@interface ViewController ()<UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) UISearchBar *searchBar;
@property (nonatomic, strong) NSMutableArray *searchResultsArray;
@property (nonatomic, strong) NSMutableArray *leftDataArray;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 64, 300, 40)];
    searchBar.delegate = self;
    self.searchBar = searchBar;
    [self.view addSubview:searchBar];
    
    
    
    [self downloadCityList];
    //self.searchResultsArray = @[@"A", @"B", @"C", @"D"];
}


-(void)downloadCityList
{
    NSString *urlString = @"http://101.200.132.141:83/api/driver/GetCityList";
    _leftDataArray = [[NSMutableArray alloc]init];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //请求格式
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //返回格式
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary *parDic = @{@"CityID":@"",
                             @"CityLevel":@""
                             };
    [manager POST:urlString parameters:parDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSArray *cityArr = dict[@"Data"];
        
        if (![cityArr isKindOfClass:[NSNull class]]) {
            for (NSDictionary *dic in cityArr) {
                CityListModel *cityModel = [[CityListModel alloc]initWithDic:dic];
                
                
                [_leftDataArray addObject:cityModel];
            }
            
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@error",error);
    }];
    
}

 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _searchResultsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];

    cell.textLabel.text = [_searchResultsArray[indexPath.row] CityName];

    return cell;
}

//点击搜索框
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self searchBar:searchBar textDidChange:searchBar.text];
    [_searchBar resignFirstResponder];
}

//开始编辑
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    
}

//文本改变
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchText.length == 0) {
        _searchResultsArray = [NSMutableArray arrayWithArray:_leftDataArray];
    }else{
        _searchResultsArray = [[NSMutableArray alloc] init];
        
        for (CityListModel *model in _leftDataArray) {
            //转化成小写
            NSString *pinyin = [model.PinYin lowercaseString];
            NSString *searText = [searchText lowercaseString];
            
            if ([model.CityName hasPrefix:searText]||[pinyin hasPrefix:searText]||[model.QuanPin hasPrefix:searText]) {
                
                NSMutableArray *tempArray = [[NSMutableArray alloc] init];
                [tempArray addObject:model];
                
                [_searchResultsArray addObjectsFromArray: tempArray];
            }
        }
        NSLog(@"=%ld", _searchResultsArray.count);
        
    }
//    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 104, 300, 600) style:UITableViewStylePlain];
//    _tableView.backgroundColor = [UIColor grayColor];
//    _tableView.sectionHeaderHeight = 0;
//    _tableView.delegate = self;
//    _tableView.dataSource = self;
//    _tableView.hidden = YES;
//    [self.view addSubview:_tableView];
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 104, 300, 600) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    _tableView = tableView;
    
    [self.view addSubview:tableView];

    [_tableView reloadData];
}

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [_searchBar setShowsCancelButton:YES animated:YES];
    
    [self.navigationController setNavigationBarHidden:NO];
    
    return YES;
}


//取消
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    searchBar.text = nil;
    
    [self searchBar:searchBar textDidChange:nil];
    [_searchBar resignFirstResponder];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
