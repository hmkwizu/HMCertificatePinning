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
+ (SecKeyRef) publicKeyForCertificate:(SecCertificateRef) certificate;

//utils
+ (SecCertificateRef)certForTrust:(SecTrustRef)trust;
+ (NSData *)dataForCertificate:(SecCertificateRef)certificate;
+ (SecCertificateRef)certForData:(NSData *)data;


@end
