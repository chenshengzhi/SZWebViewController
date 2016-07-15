//
//  SZWebViewProgressBar.h
//  LoginProject
//
//  Created by 陈圣治 on 15/7/6.
//  Copyright (c) 2015年 shengzhichen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SZWebViewProgressBar : UIView

@property (nonatomic, strong, readonly) UIView *progressView;
@property (nonatomic) CGFloat progress;

- (SZWebViewProgressBar *)initWithFrame:(CGRect)frame;

- (void)setProgress:(CGFloat)value animated:(BOOL)animated;

@end
