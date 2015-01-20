//
//  SRGNovelGameTexts.m
//  SRGNovelGameTexts
//
//  Created by Kazuhiro Sakamoto on 2015/01/20.
//  Copyright (c) 2015年 Soragoto. All rights reserved.
//

#import "SRGNovelGameTexts.h"

@implementation SRGNovelGameTexts {
    NSString *_text;
    NSTimer *_displayTextScheduler;
    
    NSInteger _textCountInCurrentLine;
    NSInteger _lineCount;
    NSMutableArray *_lineBreakPoint;
    
    NSMutableArray *_stringLabels;
}

- (id) init {
    self = [super init];
    if (self) {
        _textColor = [UIColor blackColor];
        _letterSpacing = 1;
        _lineSpacing   = 8;
        _stringDisplaySpeed = 0.1;
        _stringFadeInSpeed  = 0.1;
        
        _stringLabels = @[].mutableCopy;
        _isTextDisplayingCompleted = NO;
    }
    return self;
}

- (void) setText:(NSString *)text {
    NSAssert(text != nil, @"text is NOT empty");
    _isTextDisplayingCompleted = NO;
    
    _lineBreakPoint = @[].mutableCopy;
    _text = [self _parseLineBreakMark:text];
    
    [self _createStringLabels];
}

- (void) startDisplayingText {
    _displayTextScheduler = [NSTimer
        scheduledTimerWithTimeInterval:_stringDisplaySpeed
        target:self
        selector:@selector(_displayStringNextOne)
        userInfo:nil
        repeats:YES
    ];
}

- (void) displayAllText {
    for( UILabel *string in _stringLabels ){
        string.hidden = NO;
    }
    [self _onAllStringDisplayed];
}

- (void) cleanup {
    for( UIView *view in self.subviews ){
        [view removeFromSuperview];
    }
    [_displayTextScheduler invalidate];
    
    _displayTextScheduler = nil;
    _text = nil;
    _stringLabels = @[].mutableCopy;
    _lineCount = 0;
    _textCountInCurrentLine = 0;
}

- (void) _displayStringNextOne {
    for( UILabel *string in _stringLabels ){
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
    [_displayTextScheduler invalidate];
    [self _onAllStringDisplayed];
}

- (void) _createStringLabels {
    while ( ![self _isStringLabelCreatingCompleted] ) {
        [self _createNextStringLabel];
    }
    [self _adjustViewFrame];
}

- (void) _createNextStringLabel {
    UILabel *string = [self _labelWithString:
                       [self _nextString]
                       ];
    [string setHidden:YES];
    [string sizeToFit];
    [self _setPositionWithLabel:string];
    
    [self addSubview:string];
    [_stringLabels addObject:string];
    _textCountInCurrentLine++;
}

- (NSString *) _nextString {
    if( [self _isStringLabelCreatingCompleted] ){
        return nil;
    }
    return [_text substringWithRange:
            NSMakeRange(_stringLabels.count, 1)
            ];
}

- (void) _setPositionWithLabel:(UILabel *)label{
    UILabel *preAdded = _stringLabels.lastObject;
    
    if( !preAdded ){
        [self _setXPosWithUIVIew:label x:0];
        [self _setYPosWithUIVIew:label y:0];
        _lineCount = 1;
        return;
    }
    
    float nextStringXPos = preAdded.frame.origin.x + preAdded.frame.size.width + _letterSpacing;
    BOOL isNeedLineBreak = nextStringXPos > self.frame.size.width;
    
    if( isNeedLineBreak ){
        [self _setYPosWithUIVIew:label y:
            (label.frame.size.height + _lineSpacing) *  _lineCount
         ];
        [self _setXPosWithUIVIew:label x:0];
        _lineCount++;
        _textCountInCurrentLine = 0;
        return;
    }
    
    [self _setXPosWithUIVIew:label x:
        preAdded.frame.origin.x + preAdded.frame.size.width + _letterSpacing
    ];
    [self _setYPosWithUIVIew:label y:preAdded.frame.origin.y];
}                                      

- (BOOL) _isStringLabelCreatingCompleted {
    return ( _stringLabels.count == _text.length );
}

- (UILabel *) _labelWithString:(NSString *)string {
    UILabel *label  = [[UILabel alloc] init];
    label.text      =  string;
    label.textColor = _textColor;
    label.backgroundColor = [UIColor clearColor];
    [label setFont:_font];
    return label;
}

- (NSString *) _parseLineBreakMark:(NSString *) text {
    NSMutableString *mutableText = text.mutableCopy;
    NSRange range = [mutableText rangeOfString:@"\n"];
    if( range.location != NSNotFound ){
        [_lineBreakPoint addObject:@(range.location)];
        [mutableText deleteCharactersInRange:range];
        mutableText = [self _parseLineBreakMark:
                       mutableText
                       ].mutableCopy;
    }
    return mutableText;
}

- (void) _adjustViewFrame {
    float maxX = 0;
    float maxY = 0;
    
    for( UILabel *label in _stringLabels ){
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

- (void) _onAllStringDisplayed {
    _isTextDisplayingCompleted = YES;
    if( _onAllTextDisplayed ){
        _onAllTextDisplayed();
    }
}

- (void) _setXPosWithUIVIew:(UIView *)view x:(float)x{
    view.frame = CGRectMake(
        x,
        view.frame.origin.y,
        view.frame.size.width,
        view.frame.size.height
    );
}

- (void) _setYPosWithUIVIew:(UIView *)view y:(float)y{
    view.frame = CGRectMake(
        view.frame.origin.x,
        y,
        view.frame.size.width,
        view.frame.size.height
    );
}

@end
