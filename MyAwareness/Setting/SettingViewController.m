//
// Created by luowei on 15/6/10.
// Copyright (c) 2015 luosai. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingTableViewCell.h"
#import "PersonalSignViewController.h"
#import "ScanQRViewController.h"
#import "AboutViewController.h"
#import "Defines.h"


@interface SettingViewController ()
@property(nonatomic, strong) NSArray *settings;
@end

@implementation SettingViewController {

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.settings = @[@"个性签名", @"扫描二维码", @"关于"];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.tableView reloadData];
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
        cell = [[SettingTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identtityKey];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
//    cell.myImage = _status[(NSUInteger) indexPath.row];
    
    switch (indexPath.row){
        case 0:{
            cell.textLabel.text = _settings[(NSUInteger) indexPath.row];
            NSString *sign = [[NSUserDefaults standardUserDefaults] objectForKey:PERSONALSIGN_KEY];
            cell.detailTextLabel.text = sign;
            break;
        }
        case 1:{
            cell.textLabel.text = _settings[(NSUInteger) indexPath.row];
            break;
        }
        default: {
            cell.textLabel.text = _settings[(NSUInteger) indexPath.row];
            break;
        }
    }
    
    return cell;
}


#pragma mark TableViewDelegate Implements

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    switch (indexPath.row) {
        case 0: {
            PersonalSignViewController *viewController = [PersonalSignViewController new];
            viewController.title = cell.textLabel.text;
            viewController.view.backgroundColor = [UIColor whiteColor];
            viewController.personalSign = cell.detailTextLabel.text;

            //更新签名回调block
            viewController.updateSignBlock = ^(NSString *sign) {
                [[NSUserDefaults standardUserDefaults] setObject:sign forKey:PERSONALSIGN_KEY];
                cell.detailTextLabel.text = sign;
            };

            [viewController setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:viewController animated:YES];
            break;
        }
        case 1: {
            ScanQRViewController *viewController = [ScanQRViewController new];
            viewController.title = cell.textLabel.text;
            viewController.view.backgroundColor = [UIColor whiteColor];

            [viewController setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:viewController animated:YES];
            break;
        }
        case 2: {
            AboutViewController *viewController = [AboutViewController new];
            viewController.title = cell.textLabel.text;
            viewController.view.backgroundColor = [UIColor whiteColor];

            [viewController setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:viewController animated:YES];
            break;
        }
        default:
            break;
    }

    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end