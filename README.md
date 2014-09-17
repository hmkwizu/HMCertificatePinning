Purpose
--------------

HMCertificatePinning is a class designed  to simplify SSL Certificate Pinning in Objective-C. It provides helper methods to handle
NSURLConnectionDelegate and NSURLSession methods responsible for handling SSL handshake(Read below). In addition to these methods it 
provides methods to extract fields such as sha1/MD5 fingerprints, public keys from a certificate.

Supported OS & SDK Versions
-----------------------------

HMCertificatePinning works from iOS 6 and above.

ARC Compatibility
------------------

HMCertificatePinning requires ARC. If you wish to use HMCertificatePinning in a non-ARC project, just add the -fobjc-arc compiler flag to the HMCertificatePinning.m class. To do this, go to the Build Phases tab in your target settings, open the Compile Sources group, double-click HMCertificatePinning.m in the list and type -fobjc-arc into the popover.


Thread Safety
--------------

HMCertificatePinning is completely thread safe.

Installation
--------------

- Cocoapods

CocoaPods is the recommended way to add HMCertificatePinning to your project.
```
    Add a pod entry for HMCertificatePinning to your Podfile pod 'HMCertificatePinning', '~> 1.0.0'
    Install the pod(s) by running pod install.
    Include HMCertificatePinning wherever you need it with #import "HMCertificatePinning.h".
```

- Source files

To use HMCertificatePinning in an app, just drag the HMCertificatePinning class files into your project and add the Security framework.


Usage
-----

- Using NSURLConnection

You need to implement two methods of NSURLConnectionDelegate. The methods are `- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace `
and `- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge`.
In the first method you should return, whether the client should authenticate against protection space, and in the second you should evaluate the received challange.
To Evaluate the challenge, HMCertificatePinning provides a method `+ (BOOL)shouldTrustProtectionSpace:(NSURLProtectionSpace *)protectionSpace localCertPath:(NSString *) certPath`, which returns a boolean.
Here is an example for how you can use this.


```objective-c
    - (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
    {
        return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
    }
    - (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
    {
        if ([self shouldTrustProtectionSpace:challenge.protectionSpace]) {
            [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
        } else {
            [challenge.sender performDefaultHandlingForAuthenticationChallenge:challenge];
        }
    }
    - (BOOL)shouldTrustProtectionSpace:(NSURLProtectionSpace *)protectionSpace
    {
        // Load up the bundled certificate.
        NSString *certPath = [[NSBundle mainBundle] pathForResource:@"mycert" ofType:@"cer"];
        BOOL flag = [HMCertificatePinning shouldTrustProtectionSpace:protectionSpace localCertPath:certPath];
        return flag;
    }
```

- Using NSURLSession

You need to implement `- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *))completionHandler` of NSURLSessionDelegate.
Here is an example of how you would do it.

```objective-c
    - (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *))completionHandler
    {
        if([challenge.protectionSpace.authenticationMethod
            isEqualToString:NSURLAuthenticationMethodServerTrust])
        {
            // Loading bundled certificate.
            NSString *certPath = [[NSBundle mainBundle] pathForResource:@"mycert" ofType:@"cer"];
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
```


