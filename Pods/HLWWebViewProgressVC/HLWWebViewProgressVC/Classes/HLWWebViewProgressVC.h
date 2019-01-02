//
//  HLWWebViewProgressVC.h
//  Pods
//
//  Created by tang on 2016/12/31.
//
//

#import <Foundation/Foundation.h>


@class WKWebView;

@interface HLWWebViewProgressVC : NSObject

+ (id)webViewProgressVCWithWebView:(WKWebView *)webView navigationBar:(UINavigationBar *)navigationBar;

@property (weak, nonatomic, readonly) WKWebView * webView;
@property (weak, nonatomic, readonly) UINavigationBar * navigationBar;
@property (strong, nonatomic, readonly) UIProgressView * progressView;

- (void)addProgressView;
- (void)removeProgressView;

@end
