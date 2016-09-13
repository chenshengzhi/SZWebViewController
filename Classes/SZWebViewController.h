//
//  SZWebViewController.h
//  LoginProject
//
//  Created by shengzhichen on 15/7/1.
//  Copyright (c) 2015年 shengzhichen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

typedef void(^SZWebViewGoBackConfig)(BOOL canGoBack);
typedef WKNavigationActionPolicy(^SZWebViewDecidePolicyForNavigationAction)(WKNavigationAction *navigationAction);
typedef WKNavigationResponsePolicy(^SZWebViewDecidePolicyForNavigationResponse)(WKNavigationResponse *navigationResponse);

@interface SZWebViewController : UIViewController <WKNavigationDelegate, WKUIDelegate>

@property (nonatomic, strong, readonly) WKWebView *webView;

@property (nonatomic, strong) UIColor *progressTintColor;

@property (nonatomic, strong) NSString *urlPath;

@property (nonatomic, strong) NSString *html;
@property (nonatomic, strong) NSString *htmlBaseUrlPath;

//default: YES
@property (nonatomic) BOOL showHtmlTitle;

@property (nonatomic, copy) SZWebViewGoBackConfig configForGoBackBlock;

@property (nonatomic, copy) SZWebViewDecidePolicyForNavigationAction decideActionBlock;

@property (nonatomic, copy) SZWebViewDecidePolicyForNavigationResponse decideResponseBlock;

@end
