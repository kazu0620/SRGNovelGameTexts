//
//  SRGNovelGameTexts.m
//  SRGNovelGameTexts
//
//  Created by Kazuhiro Sakamoto on 2015/01/20.
//  Copyright (c) 2015年 Soragoto. All rights reserved.
//

#import "SRGNovelGameTexts.h"

@implementation SRGNovelGameTexts {
    NSString *displayText;
    NSTimer *displayTextScheduler;
    
    NSInteger textCountInCurrentLine;
    NSInteger lineCount;
    NSMutableArray *lineBreakPoint;
    
    NSMutableArray *stringLabels;
}

#pragma mark - Initialize
- (id) init {
    self = [super init];
    if (self) {
        _textColor = [UIColor blackColor];
        _letterSpacing = 1;
        _lineSpacing   = 8;
        _stringDisplaySpeed = 0.1;
        _stringFadeInSpeed  = 0.1;
        
        stringLabels = @[].mutableCopy;
        _isTextDisplayingCompleted = NO;
    }
    return self;
}

#pragma mark - Public methods
- (void) setDisplayText:(NSString *)text {
    NSAssert(text != nil, @"text is EMPTY");
    _isTextDisplayingCompleted = NO;
    
    lineBreakPoint = @[].mutableCopy;
    displayText = [self parseLineBreakMark:text];
    
    [self createStringLabels];
}

- (void) startDisplayingText {
    displayTextScheduler = [NSTimer
        scheduledTimerWithTimeInterval:_stringDisplaySpeed
        target:self
        selector:@selector(displayStringNextOne)
        userInfo:nil
        repeats:YES
    ];
}

- (void) displayAllText {
    for( UILabel *string in stringLabels ){
        string.hidden = NO;
    }
    [self onAllStringDisplayed];
}

- (void) cleanup {
    for( UIView *view in self.subviews ){
        [view removeFromSuperview];
    }
    [displayTextScheduler invalidate];
    
    displayTextScheduler = nil;
    displayText = nil;
    stringLabels = @[].mutableCopy;
    lineCount = 0;
    textCountInCurrentLine = 0;
}

#pragma mark - Create Lable Parts
- (void) createStringLabels {
    while ( ![self isStringLabelCreatingCompleted] ) {
        [self createNextStringLabel];
    }
    [self adjustViewFrame];
}

- (void) createNextStringLabel {
    UILabel *string = [self labelWithString:
                       [self nextString]
                       ];
    [string setHidden:YES];
    [string sizeToFit];
    [self setPositionWithLabel:string];
    
    [self addSubview:string];
    [stringLabels addObject:string];
    textCountInCurrentLine++;
}

- (UILabel *) labelWithString:(NSString *)string {
    UILabel *label  = [[UILabel alloc] init];
    label.text      =  string;
    label.textColor = _textColor;
    label.backgroundColor = [UIColor clearColor];
    [label setFont:_font];
    return label;
}

- (BOOL) isStringLabelCreatingCompleted {
    return ( stringLabels.count == displayText.length );
}

#pragma mark - Adjust label position
- (void) setPositionWithLabel:(UILabel *)label{
    UILabel *preAdded = stringLabels.lastObject;
    
    if( !preAdded ){
        [self setXPosWithUIVIew:label x:0];
        [self setYPosWithUIVIew:label y:0];
        lineCount = 1;
        return;
    }
    
    float nextStringXPos = preAdded.frame.origin.x + preAdded.frame.size.width + _letterSpacing;
    BOOL isNeedLineBreak = nextStringXPos > self.frame.size.width;
    
    if( isNeedLineBreak ){
        [self setYPosWithUIVIew:label y:
            (label.frame.size.height + _lineSpacing) *  lineCount
         ];
        [self setXPosWithUIVIew:label x:0];
        lineCount++;
        textCountInCurrentLine = 0;
        return;
    }
    
    [self setXPosWithUIVIew:label x:
        preAdded.frame.origin.x + preAdded.frame.size.width + _letterSpacing
    ];
    [self setYPosWithUIVIew:label y:preAdded.frame.origin.y];
}

- (void) adjustViewFrame {
    float maxX = 0;
    float maxY = 0;
    
    for( UILabel *label in stringLabels ){
        CGPoint frameOrigin = label.frame.origin;
        CGSize  frameSize   = label.frame.size;
        float labelsMaxX = frameOrigin.x + frameSize.width;
        float labelsMaxY = frameOrigin.y + frameSize.height;
        if( labelsMaxX > maxX ){
            maxX = labelsMaxX;
        }
        if( labelsMaxY > maxY ){
            maxY = labelsMaxY;
        }
    }
    
    self.frame = CGRectMake(
        self.frame.origin.x,
        self.frame.origin.y,
        maxX,
        maxY
    );
}

#pragma mark - Display label parts
- (void) displayStringNextOne {
    for( UILabel *string in stringLabels ){
        if( string.hidden ){
            string.alpha  = 0;
            string.hidden = NO;
            [UIView animateWithDuration:_stringFadeInSpeed
                             animations:^{
                                 string.alpha = 1;
                             }];
            return;
        }
    }
    [displayTextScheduler invalidate];
    [self onAllStringDisplayed];
}

- (NSString *) nextString {
    if( [self isStringLabelCreatingCompleted] ){
        return nil;
    }
    return [displayText substringWithRange:
            NSMakeRange(stringLabels.count, 1)
            ];
}

- (void) onAllStringDisplayed {
    _isTextDisplayingCompleted = YES;
    if( _onAllTextDisplayed ){
        _onAllTextDisplayed();
    }
}

#pragma mark - Util
- (NSString *) parseLineBreakMark:(NSString *) text {
    NSMutableString *mutableText = text.mutableCopy;
    NSRange range = [mutableText rangeOfString:@"\n"];
    if( range.location != NSNotFound ){
        [lineBreakPoint addObject:@(range.location)];
        [mutableText deleteCharactersInRange:range];
        mutableText = [self parseLineBreakMark:
                       mutableText
                       ].mutableCopy;
    }
    return mutableText;
}

- (void) setXPosWithUIVIew:(UIView *)view x:(float)x{
    view.frame = CGRectMake(
        x,
        view.frame.origin.y,
        view.frame.size.width,
        view.frame.size.height
    );
}

- (void) setYPosWithUIVIew:(UIView *)view y:(float)y{
    view.frame = CGRectMake(
        view.frame.origin.x,
        y,
        view.frame.size.width,
        view.frame.size.height
    );
}

@end
