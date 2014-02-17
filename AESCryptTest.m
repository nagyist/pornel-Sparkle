//
//  AESCryptTest.m
//  Sparkle
//
//  Created by istvan on 14.2.17..
//
//

#import <Cocoa/Cocoa.h>
#import <SenTestingKit/SenTestingKit.h>
#import "NSData+AESCrypt.h"


@interface AESCryptTest : SenTestCase

@end

@implementation AESCryptTest

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

- (void)testExample
{
    
    //STFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
    // NSData *encryptedData = [UIImagePNGRepresentation(@"Resources/test.png" /*your image*/)
      //                       AES256EncryptWithKey:"test1"/*your enc key*/];
    
    //NSData *plainData = [encryptedData AES256DecryptWithKey:"test"/*your enc key*/];
    
    // CIImage *img =[CIImage imageWithData:plainData];
}

@end
