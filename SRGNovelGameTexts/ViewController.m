//
//  ViewController.m
//  SRGNovelGameTexts
//
//  Created by Kazuhiro Sakamoto on 2015/01/20.
//  Copyright (c) 2015年 Soragoto. All rights reserved.
//

#import "ViewController.h"
#import "SRGNovelGameTexts.h"

@interface ViewController ()

@end

@implementation ViewController {
    SRGNovelGameTexts *novelGameText;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showTexts];
}

- (void) showTexts {
    float textViewWidth  = 200;
    float textViewHeight = 200;
    
    novelGameText = [SRGNovelGameTexts new];
    novelGameText.frame = CGRectMake(
        ( self.view.frame.size.width - textViewWidth ) / 2,
        ( self.view.frame.size.height - textViewHeight ) / 2,
         textViewWidth,textViewHeight
    );
    
    novelGameText.backgroundColor = [UIColor whiteColor];
    novelGameText.textColor = [UIColor blackColor];
    novelGameText.font = [UIFont fontWithName:@"ArialMT" size:23];
    
    [self.view addSubview:novelGameText];
    
    __weak typeof(self) wSelf = self;
    novelGameText.onAllTextDisplayed = ^{
        [wSelf onAllTextDisplayed];
    };
    
    [novelGameText setText:@"いろはにほへとちりぬるをわかよたれそつねならむうゐのおくやまけふこえてあさきゆめみしゑひもせすん"];
    [novelGameText startDisplayingText];
}

- (void) onAllTextDisplayed {
    [novelGameText cleanup];
    [self showTexts];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end