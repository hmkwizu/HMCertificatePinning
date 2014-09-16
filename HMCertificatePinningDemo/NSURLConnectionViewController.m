//
//  NSURLConnectionViewController.m
//  HMCertificatePinning
//
//  Created by Hussein Mkwizu on 9/11/14.
//  Copyright (c) 2014 Oran Teknoloji. All rights reserved.
//

#import "NSURLConnectionViewController.h"
#import "HMCertificatePinning.h"

@interface NSURLConnectionViewController ()<NSURLConnectionDataDelegate,NSURLConnectionDelegate>
@property(nonatomic,strong) NSMutableData *data;
@property(nonatomic,weak) IBOutlet UIWebView *webView;
@end

@implementation NSURLConnectionViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://google.com"]];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void ) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"Connection failed with error");
}

-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [self.data appendData:data];
}

-(void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    self.data = [NSMutableData data];
}
-(void) connectionDidFinishLoading:(NSURLConnection *)connection{
    
    NSString *resp = [[NSString alloc] initWithBytes:self.data.bytes length:self.data.length encoding:NSASCIIStringEncoding];
    
    self.data = nil;
    
    [self.webView loadHTMLString:resp baseURL:nil];
}

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    if ([self shouldTrustProtectionSpace:challenge.protectionSpace]) {
        [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
    } else {
        [challenge.sender performDefaultHandlingForAuthenticationChallenge:challenge];
    }
}


- (BOOL)shouldTrustProtectionSpace:(NSURLProtectionSpace *)protectionSpace{
    
    // Load up the bundled certificate.
    NSString *certPath = [[NSBundle mainBundle] pathForResource:@"google" ofType:@"cer"];
    BOOL flag = [HMCertificatePinning shouldTrustProtectionSpace:protectionSpace localCertPath:certPath];
    return flag;
}



@end
