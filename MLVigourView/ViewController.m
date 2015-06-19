//
//  ViewController.m
//  MLVigourView
//
//  Created by 马龙 on 15/6/19.
//  Copyright (c) 2015年 xiaojukeji. All rights reserved.
//

#import "ViewController.h"
#import "MLVigourView.h"

@interface ViewController ()<MLVigourViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    MLVigourView * mlvv = [[MLVigourView alloc]initWithCenter:CGPointMake(100, 100) containerView:self.view];
    mlvv.vigourViewDelegate = self;
    mlvv.text = @"12";
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)mlVigourView:(MLVigourView *)vigourView paninOnPoint:(CGPoint)paningPoint
{
    NSLog(@"paningPoint = %@",[NSValue valueWithCGPoint:paningPoint].description);
}

- (void)mlVigourView:(MLVigourView *)vigourView tappedOnPoint:(CGPoint)tappedPoint
{
    NSLog(@"paningPoint = %@",[NSValue valueWithCGPoint:tappedPoint].description);

}

@end
