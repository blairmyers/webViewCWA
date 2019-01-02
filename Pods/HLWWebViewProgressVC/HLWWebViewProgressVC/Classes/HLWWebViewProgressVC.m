//
//  HLWWebViewProgressVC.m
//  Pods
//
//  Created by tang on 2016/12/31.
//
//

#import "HLWWebViewProgressVC.h"
#import <WebKit/WebKit.h>

static NSString *keyPathProgress = @"estimatedProgress";

@interface HLWWebViewProgressVC ()

@property (weak, nonatomic) WKWebView * webView;
@property (weak, nonatomic) UINavigationBar * navigationBar;
@property (strong, nonatomic) UIProgressView * progressView;

@end

@implementation HLWWebViewProgressVC

#pragma mark - ---------- init

+ (id)webViewProgressVCWithWebView:(WKWebView *)webView navigationBar:(UINavigationBar *)navigationBar
{
    return [[self alloc] initWithWebView:webView navigationBar:navigationBar];
}

- (id)initWithWebView:(WKWebView *)webView navigationBar:(UINavigationBar *)navigationBar
{
    self = [super init];
    if (self) {
        _webView = webView;
        _navigationBar = navigationBar;
        
        // create progress view
        CGRect frame = _navigationBar.frame;
        CGFloat progressHeight = 2;
        CGRect progressFrame = CGRectMake(0, frame.size.height - progressHeight, frame.size.width, progressHeight);
        _progressView = [[UIProgressView alloc] initWithFrame:progressFrame];
        _progressView.progressViewStyle = UIProgressViewStyleBar;
        _progressView.userInteractionEnabled = NO;
        
        // add progress view to navigation bar
        [self addProgressView];
        
        // observe webview load progress
        [_webView addObserver:self
                   forKeyPath:keyPathProgress
                      options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                      context:nil];
    }
    return self;
}

#pragma mark - ---------- add / remove progress view
- (void)addProgressView
{
    if (!_progressView.superview) {
        [_navigationBar addSubview:_progressView];
        
        // config
        _progressView.alpha = 1;
    }
}

- (void)removeProgressView
{
    [UIView animateWithDuration:1 animations:^{
        _progressView.alpha = 0;
    } completion:^(BOOL finished) {
        [_progressView removeFromSuperview];
    }];
}

#pragma mark - ---------- observe progress
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:keyPathProgress]) {
        float new = [change[@"new"] floatValue];
        float old = [change[@"old"] floatValue];
        
        NSLog(@"old = %f, new = %f", old, new);
        
        if (new < 1) {
            // show progress view when loading
            [self addProgressView];
            
            [self.progressView setProgress:new];

        } else {
            [self.progressView setProgress:new];

            // hide progress view after finishing load
            [self removeProgressView];
        }
    }
}




@end
