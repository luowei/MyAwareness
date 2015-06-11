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


@interface ListViewController ()

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

    self.awarenessList = [NSMutableArray arrayWithArray:[[DBManager sharedDBManager] listContent]];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    if(IS_OS_8_OR_LATER){
        self.tableView.layoutMargins = UIEdgeInsetsZero;
    }

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                                                          target:self
                                                                                          action:@selector(startEditTabItems)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                           target:self
                                                                                           action:@selector(addTabItems)];
    
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

- (void)addTabItems {
    AwarenessViewController *viewController = [AwarenessViewController new];
    viewController.title = ADD_AWARENESS;
    
    //添加感悟回调block
    viewController.updateAwarenessItemBlock = ^(NSString *awareness){
        if(awareness==nil || [[awareness stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0){
            return;
        }
        [_awarenessList insertObject:awareness atIndex:0];
        [[DBManager sharedDBManager] insertContent:awareness];
    };
    
    [viewController setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:viewController animated:YES];
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
//    cell.myImage = _status[(NSUInteger) indexPath.row];

    Summary *summary = (Summary *)_awarenessList[(NSUInteger) indexPath.row];
    cell.tag = [summary.sid integerValue];
    cell.textLabel.text = summary.content;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    cell.detailTextLabel.text = [formatter stringFromDate:summary.createTime];

    return cell;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    [self modifyOftenuseWordsList:indexPath cell:cell];
    AwarenessViewController *viewController = [AwarenessViewController new];
    viewController.awareness = cell.textLabel.text;
    viewController.title = EDIT_AWARENESS;
    viewController.updateAwarenessItemBlock = ^(NSString *awareness){
        if(awareness ==nil || [[awareness stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0){
            return;
        }
        _awarenessList[(NSUInteger) indexPath.row] = awareness;

        [[DBManager sharedDBManager] updateContent:awareness byId:cell.tag];
    };

    [viewController setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
