//
//  ViewController.m
//  AWTextViewDemo
//
//  Created by Alex on 17/10/25.
//  Copyright © 2017年 Alex Wong. All rights reserved.
//

#import "ViewController.h"
#import "AWTextView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textView.placeholderFadeTime = 1;
    self.textView.placeholder = @"I'am placeholder (tap blank to dismiss the keyboard)";
    self.textView.placeholderTextColor = [UIColor redColor];
    self.textView.placeholderFont = [UIFont systemFontOfSize:14];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    NSLog(@"%@==text:%@\ncolor:%@\nfont:%@\n",self.textView, self.textView.placeholder,self.textView.placeholderTextColor,self.textView.placeholderFont);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
