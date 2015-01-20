//
//  SRGNovelGameTexts.h
//  SRGNovelGameTexts
//
//  Created by Kazuhiro Sakamoto on 2015/01/20.
//  Copyright (c) 2015年 Soragoto. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SRGNovelGameTexts : UIView

typedef void (^DisplayOneByOneTextViewEvent)();

@property UIColor *textColor;
@property UIFont *font;
@property float letterSpacing;
@property float lineSpacing;
@property float stringDisplaySpeed;
@property float stringFadeInSpeed;

@property BOOL isTextDisplayingCompleted;

@property (nonatomic,copy) DisplayOneByOneTextViewEvent onAllTextDisplayed;

- (void) setText:(NSString *)text;
- (void) startDisplayingText;
- (void) displayAllText;
- (void) cleanup;

@end
