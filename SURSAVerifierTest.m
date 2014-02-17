//
//  SURSAVerifierTest.m
//  Sparkle
//
//  Created by macdeveloper on 2014.02.17..
//
//
const size_t BUFFER_SIZE = 64;
const size_t CIPHER_BUFFER_SIZE = 1024;
const uint32_t PADDING = kSecPaddingNone;
static const UInt8 publicKeyIdentifier[] = "com.apple.sample.publickey";
static const UInt8 privateKeyIdentifier[] = "com.apple.sample.privatekey";

#import <SenTestingKit/SenTestingKit.h>

@interface SURSAVerifierTest : SenTestCase

- (void)testAsymmetricEncryptionAndDecryption;

@end

@implementation SURSAVerifierTest

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
    STFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}

- (void)testAsymmetricEncryptionAndDecryption {
    
    uint8_t *plainBuffer;
    uint8_t *cipherBuffer;
    uint8_t *decryptedBuffer;
    
    
    
    const char inputString[] = "This is a test demo for RSA Implementation in Objective C";
    int len = strlen(inputString);
    // TODO: this is a hack since i know inputString length will be less than BUFFER_SIZE
    if (len > BUFFER_SIZE) len = BUFFER_SIZE-1;
    
    plainBuffer = (uint8_t *)calloc(BUFFER_SIZE, sizeof(uint8_t));
    cipherBuffer = (uint8_t *)calloc(CIPHER_BUFFER_SIZE, sizeof(uint8_t));
    decryptedBuffer = (uint8_t *)calloc(BUFFER_SIZE, sizeof(uint8_t));
    
    strncpy( (char *)plainBuffer, inputString, len);
    
    NSLog(@"init() plainBuffer: %s", plainBuffer);
    //NSLog(@"init(): sizeof(plainBuffer): %d", sizeof(plainBuffer));
    [self encryptWithPublicKey:(UInt8 *)plainBuffer cipherBuffer:cipherBuffer];
    NSLog(@"encrypted data: %s", cipherBuffer);
    //NSLog(@"init(): sizeof(cipherBuffer): %d", sizeof(cipherBuffer));
    [self decryptWithPrivateKey:cipherBuffer plainBuffer:decryptedBuffer];
    NSLog(@"decrypted data: %s", decryptedBuffer);
    //NSLog(@"init(): sizeof(decryptedBuffer): %d", sizeof(decryptedBuffer));
    NSLog(@"====== /second test =======================================");
    
    free(plainBuffer);
    free(cipherBuffer);
    free(decryptedBuffer);
}

@end
