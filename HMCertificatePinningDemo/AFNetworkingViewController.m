//
//  AFNetworkingViewController.m
//  HMCertificatePinning
//
//  Created by Hussein Mkwizu on 9/11/14.
//  Copyright (c) 2014 Oran Teknoloji. All rights reserved.
//

#import "AFNetworkingViewController.h"
#import "AFNetworking.h"
#import "HMSecurityPolicy.h"

@interface AFNetworkingViewController ()
@property(nonatomic,weak) IBOutlet UIWebView *webView;
@end

@implementation AFNetworkingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    NSString *url = @"https://facebook.com";
    
    
    //Use manager
    AFHTTPRequestOperationManager *mananger = [AFHTTPRequestOperationManager manager];
    mananger.securityPolicy = [self getSecurityPolicy];
    mananger.responseSerializer = [AFHTTPResponseSerializer serializer];
    [mananger GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self.webView loadHTMLString:operation.responseString baseURL:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error:%@",error.localizedDescription);
    }];
    
    
    

    //Or Operation
//    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
//    operation.securityPolicy = [self getSecurityPolicy];
//    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//
//        [self.webView loadHTMLString:operation.responseString baseURL:nil];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error:%@",error.localizedDescription);
//    }];
//    
//    [operation start];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (AFSecurityPolicy*) getSecurityPolicy
{
    /**** SSL Pinning ****/
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"facebook" ofType:@"cer"];
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    AFSecurityPolicy *securityPolicy = [[HMSecurityPolicy alloc] init];
    [securityPolicy setAllowInvalidCertificates:NO];
    [securityPolicy setPinnedCertificates:@[certData]];
    [securityPolicy setSSLPinningMode:AFSSLPinningModeCertificate];
    [securityPolicy setValidatesCertificateChain:NO];
    /**** SSL Pinning ****/
    
    return securityPolicy;
    
    
}



@end
