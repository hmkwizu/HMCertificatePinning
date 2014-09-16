//
//  ORCertificatePinning.h
//  OranIM
//
//  Created by Hussein Mkwizu on 8/25/14.
//  Copyright (c) 2014 Hussein Mkwizu. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HMCertificatePinning : NSObject

+ (NSString*)sha1FingerprintForCertificate:(SecCertificateRef)certificate;
+ (NSString*)md5FingerprintForCertificate:(SecCertificateRef)certificate;

//returns brigded SecKeyRef
+ (id) publicKeyForCertificate:(SecCertificateRef) certificate;

//utils SecCertificateRef+SecTrustRef
+ (SecCertificateRef)certForTrust:(SecTrustRef)trust;
+ (NSData *)dataForCertificate:(SecCertificateRef)certificate;
+ (SecCertificateRef)certForData:(NSData *)data;

//Self signed certs---------
+ (BOOL)shouldTrustSecTrust:(SecTrustRef)trust localCertPath:(NSString *) certPath;

/* useful with NSURLConnection*/
+ (BOOL)shouldTrustProtectionSpace:(NSURLProtectionSpace *)protectionSpace localCertPath:(NSString *) certPath;

/* useful with NSURLSession*/
+ (BOOL)shouldTrustAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge localCertPath:(NSString *) certPath;


@end
