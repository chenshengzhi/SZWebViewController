//
//  SZWebViewController.m
//  LoginProject
//
//  Created by shengzhichen on 15/7/1.
//  Copyright (c) 2015年 shengzhichen. All rights reserved.
//

#import "SZWebViewController.h"
#import "SZWebViewProgressBar.h"

@interface SZWebViewController ()

@property (nonatomic, strong) SZWebViewProgressBar *progressBar;

@property (nonatomic) BOOL previousInteractivePopGestureRecognizerEnabled;

@end

@implementation SZWebViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        _showHtmlTitle = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];

    _webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    _webView.navigationDelegate = self;
    _webView.UIDelegate = self;
    _webView.allowsBackForwardNavigationGestures = YES;
    [self.view addSubview:_webView];
    [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];

    _progressBar = [[SZWebViewProgressBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 3)];
    if (_progressTintColor) {
        _progressBar.tintColor = _progressTintColor;
    }
    [self.view addSubview:self.progressBar];

    //设置右上角按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"关闭", nil)
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(closeWebView)];

    _previousInteractivePopGestureRecognizerEnabled = self.navigationController.interactivePopGestureRecognizer.enabled;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    if (![[_urlPath lowercaseString] hasPrefix:@"http://"] && ![[_urlPath lowercaseString] hasPrefix:@"https://"]) {
        _urlPath = [NSString stringWithFormat:@"http://%@",_urlPath];
    }
    _urlPath = [_urlPath stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_urlPath]]];
}

- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [_webView stopLoading];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    _webView.frame = self.view.bounds;
    _progressBar.frame = CGRectMake(0, self.topLayoutGuide.length, self.view.frame.size.width, 3);
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        double estimatedProgress = [change[NSKeyValueChangeNewKey] doubleValue];
        if (estimatedProgress < self.progressBar.progress) {
            self.progressBar.progress = estimatedProgress;
        } else {
            [self.progressBar setProgress:estimatedProgress animated:YES];
        }
    }
}

#pragma mark - WKNavigationDelegate -
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    WKNavigationActionPolicy policy = WKNavigationActionPolicyAllow;
    if (_decideActionBlock) {
        policy = _decideActionBlock(navigationAction);
    }
    decisionHandler(policy);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    WKNavigationResponsePolicy policy = WKNavigationResponsePolicyAllow;
    if (_decideActionBlock) {
        policy = _decideResponseBlock(navigationResponse);
    }
    decisionHandler(policy);
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    if (self.showHtmlTitle) {
        [webView evaluateJavaScript:@"document.title" completionHandler:^(NSString *title, NSError *error) {
            if ([title stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length != 0) {
                self.title = title;
            }
        }];
    }

    if (_configForGoBackBlock) {
        _configForGoBackBlock(self, [self.webView canGoBack]);
    } else {
        if ([self.webView canGoBack]) {
            self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        } else {
            self.navigationController.interactivePopGestureRecognizer.enabled = _previousInteractivePopGestureRecognizerEnabled;
        }
    }
}

#pragma mark - WKUIDelegate -
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:message
                                                                     message:nil
                                                              preferredStyle:UIAlertControllerStyleAlert];
    [alertVc addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil)
                                                style:UIAlertActionStyleCancel
                                              handler:^(UIAlertAction *action) {
                                                  completionHandler();
                                              }]];

    [self presentViewController:alertVc animated:YES completion:nil];
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler {
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:message
                                                                     message:nil
                                                              preferredStyle:UIAlertControllerStyleAlert];
    [alertVc addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil)
                                                style:UIAlertActionStyleDefault
                                              handler:^(UIAlertAction *action) {
                                                  completionHandler(YES);
                                              }]];
    [alertVc addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil)
                                                style:UIAlertActionStyleCancel
                                              handler:^(UIAlertAction *action){
                                                  completionHandler(NO);
                                              }]];

    [self presentViewController:alertVc animated:YES completion:nil];

}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString *))completionHandler {
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil
                                                                     message:prompt
                                                              preferredStyle:UIAlertControllerStyleAlert];
    [alertVc addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = defaultText;
    }];
    __weak typeof(alertVc) weakAlertVc = alertVc;
    [alertVc addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil)
                                                style:UIAlertActionStyleDefault
                                              handler:^(UIAlertAction *action) {
                                                  UITextField *field = weakAlertVc.textFields[0];
                                                  completionHandler(field.text);
                                              }]];
    [alertVc addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil)
                                                style:UIAlertActionStyleCancel
                                              handler:^(UIAlertAction *action){
                                                  completionHandler(nil);
                                              }]];

    [self presentViewController:alertVc animated:YES completion:nil];
}

#pragma mark - 内部方法 -
- (void)closeWebView {
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
