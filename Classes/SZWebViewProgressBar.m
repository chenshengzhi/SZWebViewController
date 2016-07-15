//
//  SZWebViewProgressBar.m
//  LoginProject
//
//  Created by 陈圣治 on 15/7/6.
//  Copyright (c) 2015年 shengzhichen. All rights reserved.
//

#import "SZWebViewProgressBar.h"

@implementation SZWebViewProgressBar

- (SZWebViewProgressBar *)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        self.backgroundColor = [UIColor clearColor];

        _progressView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, frame.size.height)];
        [self addSubview:_progressView];

        _progressView.backgroundColor = self.tintColor;

        self.progress = 0;
    }
    return self;
}

- (void)layoutSubviews {
    CGRect frame = _progressView.frame;
    frame.size.width = self.frame.size.width * _progress;
    frame.size.height = self.frame.size.height;
    self.progressView.frame = frame;
}

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    CGRect frame = _progressView.frame;
    frame.size.width = self.frame.size.width * _progress;
    self.progressView.frame = frame;

    if (progress < 1) {
        _progressView.alpha = 1.0;
    }
}

- (void)setTintColor:(UIColor *)tintColor {
    [super setTintColor:tintColor];
    _progressView.backgroundColor = tintColor;
}

- (void)setProgress:(CGFloat)value animated:(BOOL)animated {
    [UIView animateWithDuration:animated?.25:0 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^ {
        self.progress = MIN(value, 1.0);
    } completion:^(BOOL finished) {
        if (finished && _progress >= 1) {
            [UIView animateWithDuration:0.5 animations:^{
                _progressView.alpha = 0;
            }];
        }
    }];
}

@end
