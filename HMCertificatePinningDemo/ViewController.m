//
//  ViewController.m
//  HMCertificatePinningDemo
//
//  Created by Hussein Mkwizu on 9/9/14.
//  Copyright (c) 2014 Oran Teknoloji. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "HMCertificatePinning.h"

@interface ViewController ()<NSURLConnectionDataDelegate,NSURLConnectionDelegate>
@property(nonatomic,strong) NSMutableData *data;
@end

@implementation ViewController

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
    NSLog(@"Received data");
    [self.data appendData:data];
}

-(void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    NSLog(@"Received response");
    self.data = [NSMutableData data];
}
-(void) connectionDidFinishLoading:(NSURLConnection *)connection{
    
    NSString *resp = [[NSString alloc] initWithBytes:self.data.bytes length:self.data.length encoding:NSASCIIStringEncoding];
    
    NSLog(@"Finished loading:%@",resp);
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
    return [HMCertificatePinning shouldTrustProtectionSpace:protectionSpace localCertPath:certPath];
    
    
    
//    CFDataRef certDataRef = (__bridge_retained CFDataRef)certData;
//    SecCertificateRef cert = SecCertificateCreateWithData(NULL, certDataRef);
//    
//    // Establish a chain of trust anchored on our bundled certificate.
//    CFArrayRef certArrayRef = CFArrayCreate(NULL, (void *)&cert, 1, NULL);
//    SecTrustRef serverTrust = protectionSpace.serverTrust;
//    SecTrustSetAnchorCertificates(serverTrust, certArrayRef);
//    
//    // Verify that trust.
//    SecTrustResultType trustResult;
//    SecTrustEvaluate(serverTrust, &trustResult);
//    
//    // Clean up.
//    CFRelease(certArrayRef);
//    CFRelease(cert);
//    CFRelease(certDataRef);
//    
//	// Did our custom trust chain evaluate successfully?
//    return trustResult == kSecTrustResultUnspecified;
}




//- (AFHTTPRequestOperation *)HTTPRequestOperationWithRequest:(NSURLRequest *)urlRequest
//                                                    success:(void (^)(AFHTTPRequestOperation *, id))success
//                                                    failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure {
//    AFHTTPRequestOperation *operation = [super HTTPRequestOperationWithRequest:urlRequest success:success failure:failure];
//    
//    // Indicate that we want to validate "server trust" protection spaces.
//    [operation setAuthenticationAgainstProtectionSpaceBlock:^BOOL(NSURLConnection *connection, NSURLProtectionSpace *protectionSpace) {
//        return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
//    }];
//    
//    // Handle the authentication challenge.
//    [operation setAuthenticationChallengeBlock:^(NSURLConnection *connection, NSURLAuthenticationChallenge *challenge) {
//        if ([self shouldTrustProtectionSpace:challenge.protectionSpace]) {
//            [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust]
//                 forAuthenticationChallenge:challenge];
//        } else {
//            [challenge.sender performDefaultHandlingForAuthenticationChallenge:challenge];
//        }
//    }];
//    
//    return operation;
//}

@end
