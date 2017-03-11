//
//  ViewController.m
//  SimpleDrawingBoard
//
//  Created by 李保磊 on 16/5/9.
//  Copyright © 2016年 mervyn_lbl@163.com. All rights reserved.
//

#import "ViewController.h"
#import "PaintView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self drawPaint];
}

- (void)drawPaint{
    PaintView *paintView = [[PaintView alloc] initWithFrame:self.view.bounds];
    paintView.controller = self;
    paintView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:paintView];
}


@end
