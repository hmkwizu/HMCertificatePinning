//
//  NSURLSessionViewController.m
//  HMCertificatePinning
//
//  Created by Hussein Mkwizu on 9/11/14.
//  Copyright (c) 2014 Oran Teknoloji. All rights reserved.
//

#import "NSURLSessionViewController.h"
#import "HMCertificatePinning.h"

@interface NSURLSessionViewController ()<NSURLConnectionDataDelegate,NSURLConnectionDelegate,NSURLSessionDelegate>
@property(nonatomic,weak) IBOutlet UIWebView *webView;
@end

@implementation NSURLSessionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    
    NSURL *url = [NSURL URLWithString:@"https://facebook.com"];
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: self delegateQueue: [NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithURL:url
                                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                        if(error == nil)
                                                        {
                                                            NSString *resp = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
                                                            //NSLog(@"Data: %@",text);
                                                            
                                                            
                                                            [self.webView loadHTMLString:resp baseURL:nil];
                                                        }
                                                        else
                                                        {
                                                            NSLog(@"Error: %@", error);
                                                        }
                                                    }];
    
    [dataTask resume];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *))completionHandler
{
    if([challenge.protectionSpace.authenticationMethod
        isEqualToString:NSURLAuthenticationMethodServerTrust])
    {
        // Loading bundled certificate.
        NSString *certPath = [[NSBundle mainBundle] pathForResource:@"facebook" ofType:@"cer"];
        BOOL flag = [HMCertificatePinning shouldTrustAuthenticationChallenge:challenge localCertPath:certPath];
        if (flag) {
            
            NSURLCredential *credential =
            [NSURLCredential credentialForTrust:
             challenge.protectionSpace.serverTrust];
            completionHandler(NSURLSessionAuthChallengeUseCredential,credential);
        }
        else
            completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
        
        
    }
}

@end
