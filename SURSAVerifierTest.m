//
//  SURSAVerifierTest.m
//  Sparkle
//
//  Created by macdeveloper on 2014.02.17..
//
//

#import "SURSAVerifierTest.h"
#import "SURSAVerifier.h"


const char inputString[] = "This is a test demo for RSA Implementation in Objective C";


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
/*
- (void)testExample
{
    STAssertTrue(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}
*/


- (void)testAsymmetricEncryptionAndDecryption {
    uint8_t *plainBuffer;
    uint8_t *cipherBuffer;
    uint8_t *decryptedBuffer;
    
    SURSAVerifier * ownSURSAVerifier = [[SURSAVerifier alloc] init];
    
    long len = strlen(inputString);
    // TODO: this is a hack since i know inputString length will be less than BUFFER_SIZE
    if (len > (long)SURSA_BUFFER_SIZE)
    {
        len = (long)SURSA_BUFFER_SIZE+1;
    }
    
    plainBuffer = (uint8_t *)calloc(SURSA_BUFFER_SIZE, sizeof(uint8_t));
    cipherBuffer = (uint8_t *)calloc(SURSA_CIPHER_BUFFER_SIZE, sizeof(uint8_t));
    decryptedBuffer = (uint8_t *)calloc(SURSA_BUFFER_SIZE, sizeof(uint8_t));
    
    strncpy( (char *)plainBuffer, inputString, len);

    NSLog(@"init() plainBuffer: %s", plainBuffer);
    //NSLog(@"init(): sizeof(plainBuffer): %d", sizeof(plainBuffer));
    cipherBuffer = [ownSURSAVerifier encryptWithPublicKey:plainBuffer];
    NSLog(@"encrypted data: %s", cipherBuffer);
    //NSLog(@"init(): sizeof(cipherBuffer): %d", sizeof(cipherBuffer));
    decryptedBuffer = [ownSURSAVerifier decryptWithPrivateKey:(UInt8 *)cipherBuffer];
    NSLog(@"decrypted data: %s", decryptedBuffer);
    //NSLog(@"init(): sizeof(decryptedBuffer): %d", sizeof(decryptedBuffer));
    NSLog(@"====== /second test =======================================");
    
    [ownSURSAVerifier release];
    free(plainBuffer);
    free(cipherBuffer);
    free(decryptedBuffer);
}

@end
