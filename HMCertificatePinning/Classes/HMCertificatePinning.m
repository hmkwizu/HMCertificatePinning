//
//  ORCertificatePinning.m
//  OranIM
//
//  Created by Hussein Mkwizu on 8/25/14.
//  Copyright (c) 2014 Hussein Mkwizu. All rights reserved.
//

#import "HMCertificatePinning.h"
#import <Security/Security.h>
#import <CommonCrypto/CommonCrypto.h>


@implementation HMCertificatePinning

#pragma mark
#pragma mark utils
+ (NSData *)dataForCertificate:(SecCertificateRef)certificate {
    if (certificate) {
        return (__bridge_transfer NSData *)SecCertificateCopyData(certificate);
    }
    return nil;
}

+ (SecCertificateRef)certForTrust:(SecTrustRef)trust {
    SecCertificateRef certificate = nil;
    CFIndex certificateCount = SecTrustGetCertificateCount(trust);
    if (certificateCount) {
        certificate = SecTrustGetCertificateAtIndex(trust, 0);
    }
    return certificate;
}

+ (SecCertificateRef)certForData:(NSData *)data {
    SecCertificateRef allowedCertificate = NULL;
    if([ data length]) {
        allowedCertificate = SecCertificateCreateWithData(NULL, (__bridge CFDataRef)data);
    }
    return allowedCertificate;
}

+(NSString*)sha1FingerprintForCertificate:(SecCertificateRef)certificate {
    NSData * certData = [self dataForCertificate:certificate];
    unsigned char sha1Buffer[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(certData.bytes, (CC_LONG)certData.length, sha1Buffer);
    NSMutableString *fingerprint = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 3];
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; ++i)
    {
        [fingerprint appendFormat:@"%02x ",sha1Buffer[i]];
    }
    
    return [fingerprint stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}
+ (NSString*)md5FingerprintForCertificate:(SecCertificateRef)certificate{
    NSData * certData = [self dataForCertificate:certificate];
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(certData.bytes, (CC_LONG)certData.length, md5Buffer);
    NSMutableString *fingerprint = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 3];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; ++i)
    {
        [fingerprint appendFormat:@"%02x ",md5Buffer[i]];
    }
    
    return [fingerprint stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

+ (id) publicKeyForCertificate:(SecCertificateRef) allowedCertificate{
    NSParameterAssert(allowedCertificate);
    
    SecCertificateRef allowedCertificates[] = {allowedCertificate};
    CFArrayRef tempCertificates = CFArrayCreate(NULL, (const void **)allowedCertificates, 1, NULL);
    
    SecPolicyRef policy = SecPolicyCreateBasicX509();
    SecTrustRef allowedTrust = NULL;
    SecTrustCreateWithCertificates(tempCertificates, policy, &allowedTrust);

    // check the trust.
    SecTrustResultType result = 0;
    SecTrustEvaluate(allowedTrust, &result);

    
    SecKeyRef allowedPublicKey = NULL;
    switch (result) {
            
        case kSecTrustResultInvalid:
            
//        case kSecTrustResultConfirm: //deprecated
            
        case kSecTrustResultDeny:
            
        case kSecTrustResultUnspecified:
            
            allowedPublicKey = SecTrustCopyPublicKey(allowedTrust);
            
            break;
            
        case kSecTrustResultFatalTrustFailure:
            
        case kSecTrustResultOtherError:
            
            break;
            
        case kSecTrustResultRecoverableTrustFailure:
            allowedPublicKey = SecTrustCopyPublicKey(allowedTrust);
            
            break;
            
        case kSecTrustResultProceed:
            
            allowedPublicKey = SecTrustCopyPublicKey(allowedTrust);
            break;
            
    }
    

    CFRelease(allowedTrust);
    CFRelease(policy);
    CFRelease(tempCertificates);

    
    return (__bridge_transfer id)allowedPublicKey;
}

#pragma mark
#pragma mark Self signed
+ (BOOL)shouldTrustSecTrust:(SecTrustRef)serverTrust localCertPath:(NSString *) certPath{
    // Load up the bundled certificate.
    NSData *certData = [[NSData alloc] initWithContentsOfFile:certPath];
    CFDataRef certDataRef = (__bridge_retained CFDataRef)certData;
    SecCertificateRef cert = SecCertificateCreateWithData(NULL, certDataRef);
    
    // Establish a chain of trust anchored on our bundled certificate.
    CFArrayRef certArrayRef = CFArrayCreate(NULL, (void *)&cert, 1, NULL);
    SecTrustSetAnchorCertificates(serverTrust, certArrayRef);
    SecTrustSetAnchorCertificatesOnly(serverTrust, NO);//enable built-in anchor certs
    
    
    // Verify that trust.
    SecTrustResultType trustResult;
    SecTrustEvaluate(serverTrust, &trustResult);
    
    // Clean up.
    CFRelease(certArrayRef);
    CFRelease(cert);
    CFRelease(certDataRef);
    
    // Did our custom trust chain evaluate successfully?
    return trustResult == kSecTrustResultUnspecified;
}

+ (BOOL)shouldTrustProtectionSpace:(NSURLProtectionSpace *)protectionSpace localCertPath:(NSString *) certPath{
    return [HMCertificatePinning shouldTrustSecTrust:protectionSpace.serverTrust localCertPath:certPath];
}
+ (BOOL)shouldTrustAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge localCertPath:(NSString *) certPath{
    return [HMCertificatePinning shouldTrustProtectionSpace:challenge.protectionSpace localCertPath:certPath];
}

@end
