//
//  ViewController.m
//  MyAwareness
//
//  Created by luowei on 15/6/10.
//  Copyright (c) 2015年 luosai. All rights reserved.
//

#import "ListViewController.h"
#import "Defines.h"
#import "FMDB.h"
#import "Summary.h"
#import "DBManager.h"
#import "AwarenessViewController.h"
#import "WeixinSessionActivity.h"
#import "WeixinTimelineActivity.h"


@interface ListViewController ()<WXApiDelegate>

@property(nonatomic, strong) NSMutableArray *awarenessList;

@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    if (![[NSUserDefaults standardUserDefaults] boolForKey:TABLECREATED_KEY]) {
        BOOL res = [[DBManager sharedDBManager] createTable];
        [[NSUserDefaults standardUserDefaults] setBool:res forKey:TABLECREATED_KEY];
    }

    self.awarenessList = @[].mutableCopy;
    [self.awarenessList arrayByAddingObjectsFromArray:[[DBManager sharedDBManager] listContent]];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    if (IS_OS_8_OR_LATER) {
        self.tableView.layoutMargins = UIEdgeInsetsZero;
    }

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                                                          target:self
                                                                                          action:@selector(startEditTabItems)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                           target:self
                                                                                           action:@selector(addTabItems)];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

//    self.awarenessList = [NSMutableArray arrayWithArray:[[DBManager sharedDBManager] listContent]];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)startEditTabItems {
    [self.tableView setEditing:!self.tableView.editing animated:YES];

    //编辑
    if (self.tableView.editing) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                     target:self
                                     action:@selector(startEditTabItems)];
        //保存
    } else {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                     target:self
                                     action:@selector(startEditTabItems)];
    }

}


//添加一条记录
- (void)addTabItems {
    AwarenessViewController *viewController = [AwarenessViewController new];
    viewController.title = ADD_AWARENESS;

    //添加感悟回调block
    viewController.updateAwarenessItemBlock = ^(NSString *awareness) {
        if (awareness == nil || [[awareness stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
            return;
        }

        [[DBManager sharedDBManager] insertContent:awareness];
        Summary *summary = [[DBManager sharedDBManager] findByContent:awareness][0];
        [_awarenessList insertObject:summary atIndex:0];
    };

    [viewController setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:viewController animated:YES];
}


#pragma mark TableViewDatasource Implements

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.awarenessList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"CellId";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeInfoLight];
    shareBtn.tag = indexPath.row;
    [shareBtn addTarget:self action:@selector(shareAwareness:) forControlEvents:UIControlEventTouchUpInside];
    cell.accessoryView = shareBtn;

    Summary *summary = (Summary *) _awarenessList[(NSUInteger) indexPath.row];
    cell.tag = [summary._id integerValue];
    cell.textLabel.text = summary.content;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    cell.detailTextLabel.text = [formatter stringFromDate:summary.createTime];

    return cell;
}

//分享感悟
- (void)shareAwareness:(UIButton *)shareBtn {

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:shareBtn.tag inSection:0];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];

    NSArray *activities = @[[[WeixinSessionActivity alloc] init], [[WeixinTimelineActivity alloc] init]];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:@[
            cell.textLabel.text,
//            [UIImage imageNamed:@"Oauth"],
            [NSURL URLWithString:@"http://www.wodedata.com"]
    ] applicationActivities:activities];

    //初始化completionHandler，当post结束之后（无论是done还是cancel)被调用
    activityVC.completionHandler = ^(NSString *activityType, BOOL completed) {
        NSLog(@"activityType :%@", activityType);
        if (completed) {
            NSLog(@"completed");
        }
        else {
            NSLog(@"cancel");
        }

        //放回上一级界面
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    };

    activityVC.excludedActivityTypes = @[UIActivityTypeAssignToContact, UIActivityTypeCopyToPasteboard, UIActivityTypePrint];
    [self presentViewController:activityVC animated:YES completion:nil];
}


#pragma mark TableViewDelegate Implements

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 15)];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

//编辑一条记录
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    [self modifyOftenuseWordsList:indexPath cell:cell];
    AwarenessViewController *viewController = [AwarenessViewController new];
    viewController.awareness = cell.textLabel.text;
    viewController.title = EDIT_AWARENESS;
    viewController.updateAwarenessItemBlock = ^(NSString *awareness) {
        if (awareness == nil || [[awareness stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
            return;
        }
        [[DBManager sharedDBManager] updateContent:awareness byId:@(cell.tag)];
        _awarenessList[(NSUInteger) indexPath.row] = [[DBManager sharedDBManager] findById:@(cell.tag)];
    };

    [viewController setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
