//
//  ViewController.m
//  WMTestPullUpRefresh
//
//  Created by maginawin on 15/6/4.
//  Copyright (c) 2015年 wendong wang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITableView *mTableView;
@property (strong, nonatomic) NSMutableArray* mData;
@property (nonatomic) BOOL hasMoreData;
@property (nonatomic) BOOL isLoading;

@property (strong, nonatomic) UILabel* footer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _mTableView.delegate = self;
    _mTableView.dataSource = self;
    
    _mData = [[NSMutableArray alloc] initWithObjects:@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", nil];
    _hasMoreData = YES;
    _isLoading = NO;
    
    [self setupFooter];
}

#pragma mark - Table view delegate and datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _mData.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"idCell0" forIndexPath:indexPath];
    NSString* titleString = _mData[indexPath.row];
    cell.textLabel.text = titleString;
    cell.detailTextLabel.text = @"🈲";
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.frame.size.height) {
        NSLog(@"上拉刷新");
        
        [self startLoading];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
//    if (scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.frame.size.height) {
//        NSLog(@"上拉刷新");
//        
//        [self startLoading];
//    }
}

- (void)updateFooter {
    if (!_hasMoreData) {
        _footer.text = @"没有更多数据 😱";
    } else if (_hasMoreData && !_isLoading) {
        _footer.text = @"上拉加载更多数据";
    } else if (_hasMoreData && _isLoading) {
        _footer.text = @"正在加载数据";
    }
}

- (void)setupFooter {
    _footer = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_mTableView.bounds), 54)];
    _footer.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _footer.textAlignment = NSTextAlignmentCenter;
    
    _mTableView.tableFooterView = _footer;
    [self updateFooter];
}

- (void)startLoading {
    if (!_isLoading && _hasMoreData) {
        _isLoading = YES;
        [self updateFooter];
        // 模拟加载, 延时 1000 ms
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self loadMoreData];
        });
    }
}

- (void)loadMoreData {
    int count = _mData.count;
    if (count < 100) {
        for (int i = count; i < count + 11; i++) {
            NSString* dataString = [NSString stringWithFormat:@"%d", i];
            [_mData addObject:dataString];
        }
        if (_mData.count >= 100) {
            _hasMoreData = NO;
        }
        [_mTableView reloadData];
        _isLoading = NO;
        [self updateFooter];
    }
}

@end
