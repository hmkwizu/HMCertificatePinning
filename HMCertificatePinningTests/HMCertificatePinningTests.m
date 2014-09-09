//
//  HMCertificatePinningTests.m
//  HMCertificatePinningTests
//
//  Created by Hussein Mkwizu on 9/9/14.
//  Copyright (c) 2014 Oran Teknoloji. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "HMCertificatePinning.h"

@interface HMCertificatePinningTests : XCTestCase

@end

@implementation HMCertificatePinningTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

/*!
 @function testCertificatePinningSHA1_MD5
 @discussion this testCase tests whether extracting sha1/md5 fingerprints
 works properly.
 
 */

-(void) testCertificatePinningSHA1_MD5{
    
    //correct values
    NSString *sha1Fingerprint_correct = @"dc c8 c5 f7 4f 2a 9e 3c 02 cf ec c6 87 59 cc 5a 30 03 db f8";
    NSString *md5Fingerprint_correct = @"a2 cc a1 da 9f 0b 2a 56 6c 7c 9e 50 52 ab d1 0a";
    
    
    //data
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"google" ofType:@"cer"];
    NSData *certData = [NSData dataWithContentsOfFile:path];
    XCTAssertNotNil(certData, @"Certificate data must not be nil");
    SecCertificateRef certRef = [HMCertificatePinning certForData:certData];
    
    
    NSString *sha1FingerPrint = [HMCertificatePinning sha1FingerprintForCertificate:certRef];
    
    NSString *md5FingerPrint = [HMCertificatePinning md5FingerprintForCertificate:certRef];
    
    
    XCTAssertEqualObjects(sha1Fingerprint_correct, sha1FingerPrint, @"SHA1 Fingerprints must be equal");
    XCTAssertEqualObjects(md5Fingerprint_correct, md5FingerPrint, @"MD5 Fingerprints must be equal");
    
    
    
}

@end
