//
// Created by luowei on 15/6/10.
// Copyright (c) 2015 luosai. All rights reserved.
//

#import "ScanQRViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface ScanQRViewController () <AVCaptureMetadataOutputObjectsDelegate,UIAlertViewDelegate> {
    NSString *stringValue;
}

@property(nonatomic, strong) AVCaptureDevice *device;
@property(nonatomic, strong) AVCaptureSession *session;

@property(nonatomic, strong) AVCaptureVideoPreviewLayer *layer;
@end

@implementation ScanQRViewController {

}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];

    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    self.session = [AVCaptureSession new];


    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"重新扫码" style:UIBarButtonItemStyleDone target:self action:@selector(reScan)];

    //todo:添加工具栏,图片及闪光开关

}

- (void)reScan {
    if(!_session.isRunning){
        [_session startRunning];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self setupCameral];
//    [self.session startRunning];
}

- (void)setupCameral {
    self.session.sessionPreset = AVCaptureSessionPresetHigh;
    NSError *error;
    AVCaptureDeviceInput *input = [[AVCaptureDeviceInput alloc] initWithDevice:_device error:&error];
    if (error) {
        NSLog(@"==== error.description:%@", error.description);
        return;
    }

    if ([_session canAddInput:input]) {
        [_session addInput:input];
    }

    _layer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_session];
    _layer.cornerRadius = 5.0;
    _layer.masksToBounds = YES;
    _layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _layer.bounds = CGRectMake(0, 0, 280, 280);
    _layer.position = self.view.center;

    [self.view.layer insertSublayer:_layer atIndex:0];

    AVCaptureMetadataOutput *output = [AVCaptureMetadataOutput new];
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    if ([_session canAddOutput:output]) {
        [_session addOutput:output];
        output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
    }
    [_session startRunning];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects
       fromConnection:(AVCaptureConnection *)connection {

    if (metadataObjects.count > 0) {
        AVMetadataMachineReadableCodeObject *metadataObject = metadataObjects[0] == nil ? nil : (AVMetadataMachineReadableCodeObject *) metadataObjects[0];
        stringValue = metadataObject == nil ? nil : metadataObject.stringValue;
    }
    [_session stopRunning];
    NSLog(@"code is %@",stringValue);

    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setValue:stringValue forPasteboardType:(__bridge NSString *) kUTTypeUTF8PlainText];
//    [pasteboard setValue:stringValue forPasteboardType:@"public.plain-text"];
//    [pasteboard setValue:stringValue forPasteboardType:@"public.text"];

    NSString *urlRegex = @"((http|ftp|https)://)(([a-zA-Z0-9\\._-]+\\.[a-zA-Z]{2,6})|([0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}))(:[0-9]{1,4})*(/[a-zA-Z0-9\\&%_\\./-~-]*)?";
    NSPredicate *urlStrPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",urlRegex];

    //如果是Url
    if([urlStrPredicate evaluateWithObject:stringValue]){
        [[[UIAlertView alloc] initWithTitle:@"二维码" message:[NSString stringWithFormat:@"Url:%@ 已保存到剪粘板,是否在Safari中打开?", stringValue]
                                   delegate:self cancelButtonTitle:@"不了" otherButtonTitles:@"打开",nil] show];
    }else{
        [[[UIAlertView alloc] initWithTitle:@"二维码" message:[NSString stringWithFormat:@"内容:%@ 已保存到剪粘板", stringValue]
                                   delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil] show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==1){
        NSURL *url = [NSURL URLWithString:[stringValue stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [[UIApplication sharedApplication] openURL:url];
    }
}

@end