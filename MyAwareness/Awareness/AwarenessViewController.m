//
//  AwarenessViewController.m
//  MyAwareness
//
//  Created by luowei on 15/6/11.
//  Copyright (c) 2015 luosai. All rights reserved.
//

#import "AwarenessViewController.h"

@interface AwarenessViewController()<UITextViewDelegate>

@property(nonatomic, strong) UITextView *textView;

@end


@implementation AwarenessViewController

//设置字体
- (void)textViewDidChange:(UITextView *)textView {
    self.textView.attributedText = [[NSAttributedString alloc]
            initWithString:self.textView.text attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16]}];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.textView = [[UITextView alloc] initWithFrame:self.view.frame];
    self.textView.delegate = self;
    self.textView.editable = YES;
    self.textView.scrollEnabled = YES;
//    [self.textView scrollRectToVisible:<#(CGRect)rect#> animated:<#(BOOL)animated#>];

    [self.view addSubview:self.textView];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                                                           target:self
                                                                                           action:@selector(savePersonalSign)];
}



- (void)savePersonalSign {

    //更新table
    self.updateAwarenessItemBlock(self.textView.text);

    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    //激活输入焦点
    [self.textView becomeFirstResponder];
    self.textView.text = self.awareness;
    self.textView.attributedText = [[NSAttributedString alloc]
            initWithString:self.textView.text attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16]}];

    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];

    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void)keyboardWillShow:(NSNotification *)aNotification {
    NSDictionary *info = [aNotification userInfo];
    CGSize kbSize = [info[UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;

    CGFloat topHeight = self.navigationController.navigationBar.frame.size.height + 20;

    UIEdgeInsets contentInsets = UIEdgeInsetsMake(topHeight, 0.0, kbSize.height, 0.0);
    self.textView.contentInset = contentInsets;
    self.textView.scrollIndicatorInsets = contentInsets;

    if (kbSize.height > 0) {
        CGRect aRect = self.textView.frame;
        aRect.size.height -= (kbSize.height + topHeight);

        [self.textView scrollRectToVisible:aRect animated:YES];
    }

}

- (void)keyboardWillBeHidden:(NSNotification *)aNotification {
    CGFloat topHeight = self.navigationController.navigationBar.frame.size.height + 20;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(topHeight, 0.0, 0.0, 0.0);
    self.textView.contentInset = contentInsets;
    self.textView.scrollIndicatorInsets = contentInsets;
}



@end
