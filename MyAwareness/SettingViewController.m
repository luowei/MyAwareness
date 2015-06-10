//
// Created by luowei on 15/6/10.
// Copyright (c) 2015 luosai. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingTableViewCell.h"
#import "PersonalSignViewController.h"
#import "ScanQRViewController.h"
#import "AboutViewController.h"


@interface SettingViewController ()
@property(nonatomic, strong) NSArray *settings;
@end

@implementation SettingViewController {

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.settings = @[@"个性签名",@"扫描二维码",@"关于"];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

}

#pragma mark TableViewDatasource Implements

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.settings.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identtityKey = @"setting_tableview_cell";
    SettingTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identtityKey];
    if (cell == nil) {
        cell = [[SettingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identtityKey];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
//    cell.myImage = _status[(NSUInteger) indexPath.row];
    cell.textLabel.text = _settings[(NSUInteger) indexPath.row];
    return cell;
}


#pragma mark TableViewDelegate Implements

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIViewController *viewController = nil;
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    switch (indexPath.row){
        case 0:{
            viewController = [PersonalSignViewController new];
            viewController.title = cell.textLabel.text;
            viewController.view.backgroundColor = [UIColor whiteColor];
            break;
        }
        case 1:{
            viewController = [ScanQRViewController new];
            viewController.title = cell.textLabel.text;
            viewController.view.backgroundColor = [UIColor whiteColor];
            break;
        }
        case 2:{
            viewController = [AboutViewController new];
            viewController.title = cell.textLabel.text;
            viewController.view.backgroundColor = [UIColor whiteColor];
            break;
        }
        default:
            break;
    }

    [viewController setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:viewController animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end