//
//  SURSAVerifier.m
//  Sparkle
//
//  Created by macdeveloper on 2014.02.17..
//
//

#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>
#import <Security/cssm.h>
#import <Security/Security.h>
#import "SURSAVerifier.h"

const size_t SURSA_BUFFER_SIZE = 64;
const size_t SURSA_CIPHER_BUFFER_SIZE = 1024;
const uint32_t SURSA_PADDING = kSecPaddingNone;

/* Constants used by SecKeyGeneratePair() - in SecKey.h.  Never used in any SecItem apis directly. */
// SEC_CONST_DECL (kSecPrivateKeyAttrs, "private");
// SEC_CONST_DECL (kSecPublicKeyAttrs, "public");

const char SURSA_kSecPublicKeyAttrs[] = "public";
const char SURSA_kSecPrivateKeyAttrs[] = "private";

const UInt8 SURSA_publicKeyIdentifier[] = "com.apple.sample.publickey";
const UInt8 SURSA_privateKeyIdentifier[] = "com.apple.sample.privatekey";

@implementation SURSAVerifier




- (id)init
{
    self = [super init];
    
    if(self) {
        
        privateTag = [[NSData alloc] initWithBytes:SURSA_privateKeyIdentifier
                                            length:sizeof(SURSA_privateKeyIdentifier)];
        publicTag = [[NSData alloc] initWithBytes:SURSA_publicKeyIdentifier
                                           length:sizeof(SURSA_publicKeyIdentifier)];
        // [self testAsymmetricEncryptionAndDecryption];
    }
    
    return self;
}

-(SecKeyRef)getPublicKeyRef {
    
    OSStatus sanityCheck = noErr;
    SecKeyRef publicKeyReference = NULL;
    
    if (publicKeyReference == NULL) {
        [self generateKeyPair:512];
        NSMutableDictionary *queryPublicKey = [[NSMutableDictionary alloc] init];
        
        // Set the public key query dictionary.
        [queryPublicKey setObject:(__bridge id)kSecClassKey forKey:(__bridge id)kSecClass];
        [queryPublicKey setObject:publicTag forKey:(__bridge id)kSecAttrApplicationTag];
        [queryPublicKey setObject:(__bridge id)kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
        [queryPublicKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecReturnRef];
        
        // Get the key.
        sanityCheck = SecItemCopyMatching((__bridge CFDictionaryRef)queryPublicKey, (CFTypeRef *)&publicKeyReference);
        
        
        if (sanityCheck != noErr)
        {
            publicKeyReference = NULL;
        }
        
        //        [queryPublicKey release];
        
    } else { publicKeyReference = publicKey; }
    
    return publicKeyReference;
}

/* Borrowed from:
 * https://developer.apple.com/library/mac/#documentation/security/conceptual/CertKeyTrustProgGuide/iPhone_Tasks/iPhone_Tasks.html
 */
- (uint8_t *)encryptWithPublicKey:(uint8_t *)plainBuffer
{
    
    NSLog(@"== encryptWithPublicKey()");
    
    OSStatus status = noErr;
    
    NSLog(@"** original plain text 0: %s", plainBuffer);
    
    size_t plainBufferSize = strlen((char *)plainBuffer);
    size_t cipherBufferSize = SURSA_CIPHER_BUFFER_SIZE;
    
    uint8_t * cipherBuffer = (uint8_t *)calloc(SURSA_CIPHER_BUFFER_SIZE, sizeof(uint8_t));
    
    NSLog(@"SecKeyGetBlockSize() public = %lu", SecKeyGetBlockSize([self getPublicKeyRef]));
    //  Error handling
    // Encrypt using the public.
    status = SecKeyEncrypt([self getPublicKeyRef],
                           SURSA_PADDING,
                           plainBuffer,
                           plainBufferSize,
                           &cipherBuffer[0],
                           &cipherBufferSize
                           );
    NSLog(@"encryption result code: %ld (size: %lu)", status, cipherBufferSize);
    NSLog(@"encrypted text: %s", cipherBuffer);
    
    return cipherBuffer;
}

- (uint8_t *)decryptWithPrivateKey:(uint8_t *)cipherBuffer
{
    OSStatus status = noErr;
    
    size_t cipherBufferSize = strlen((char *)cipherBuffer);
    
    NSLog(@"decryptWithPrivateKey: length of buffer: %lu", SURSA_BUFFER_SIZE);
    NSLog(@"decryptWithPrivateKey: length of input: %lu", cipherBufferSize);
    
    // DECRYPTION
    size_t plainBufferSize = SURSA_BUFFER_SIZE;
    
    uint8_t * plainBuffer = (uint8_t *)calloc(SURSA_BUFFER_SIZE, sizeof(uint8_t));
    //  Error handling
    status = SecKeyDecrypt([self getPrivateKeyRef],
                           SURSA_PADDING,
                           &cipherBuffer[0],
                           cipherBufferSize,
                           &plainBuffer[0],
                           &plainBufferSize
                           );
    NSLog(@"decryption result code: %ld (size: %lu)", status, plainBufferSize);
    NSLog(@"FINAL decrypted text: %s", plainBuffer);
    
    
    return plainBuffer;
}



- (SecKeyRef)getPrivateKeyRef {
    OSStatus resultCode = noErr;
    SecKeyRef privateKeyReference = NULL;
    //    NSData *privateTag = [NSData dataWithBytes:@"ABCD" length:strlen((const char *)@"ABCD")];
    //    if(privateKey == NULL) {
    [self generateKeyPair:512];
    NSMutableDictionary * queryPrivateKey = [[NSMutableDictionary alloc] init];
    
    // Set the private key query dictionary.
    [queryPrivateKey setObject:(__bridge id)kSecClassKey forKey:(__bridge id)kSecClass];
    [queryPrivateKey setObject:privateTag forKey:(__bridge id)kSecAttrApplicationTag];
    [queryPrivateKey setObject:(__bridge id)kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    [queryPrivateKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecReturnRef];
    
    // Get the key.
    resultCode = SecItemCopyMatching((__bridge CFDictionaryRef)queryPrivateKey, (CFTypeRef *)&privateKeyReference);
    NSLog(@"getPrivateKey: result code: %ld", resultCode);
    
    if(resultCode != noErr)
    {
        privateKeyReference = NULL;
    }
    
    //        [queryPrivateKey release];
    //    } else {
    //        privateKeyReference = privateKey;
    //    }
    
    return privateKeyReference;
}

#ifdef IOS

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

#endif

- (void)generateKeyPair:(NSUInteger)keySize {
    OSStatus sanityCheck = noErr;
    publicKey = NULL;
    privateKey = NULL;
    
    //  LOGGING_FACILITY1( keySize == 512 || keySize == 1024 || keySize == 2048, @"%d is an invalid and unsupported key size.", keySize );
    
    // First delete current keys.
    //  [self deleteAsymmetricKeys];
    
    // Container dictionaries.
    NSMutableDictionary * privateKeyAttr = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * publicKeyAttr = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * keyPairAttr = [[NSMutableDictionary alloc] init];
    
    // Set top level dictionary for the keypair.
    [keyPairAttr setObject:(__bridge id)kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    [keyPairAttr setObject:[NSNumber numberWithUnsignedInteger:keySize] forKey:(__bridge id)kSecAttrKeySizeInBits];
    
    // Set the private key dictionary.
    [privateKeyAttr setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecAttrIsPermanent];
    [privateKeyAttr setObject:privateTag forKey:(__bridge id)kSecAttrApplicationTag];
    // See SecKey.h to set other flag values.
    
    // Set the public key dictionary.
    [publicKeyAttr setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecAttrIsPermanent];
    [publicKeyAttr setObject:publicTag forKey:(__bridge id)kSecAttrApplicationTag];
    // See SecKey.h to set other flag values.
    
    // Set attributes to top level dictionary.
    [keyPairAttr setObject:privateKeyAttr forKey:(__bridge id)SURSA_kSecPrivateKeyAttrs];
    [keyPairAttr setObject:publicKeyAttr forKey:(__bridge id)SURSA_kSecPublicKeyAttrs];
    
    // SecKeyGeneratePair returns the SecKeyRefs just for educational purposes.
    sanityCheck = SecKeyGeneratePair((__bridge CFDictionaryRef)keyPairAttr, &publicKey, &privateKey);
    //  LOGGING_FACILITY( sanityCheck == noErr && publicKey != NULL && privateKey != NULL, @"Something really bad went wrong with generating the key pair." );
    if(sanityCheck == noErr  && publicKey != NULL && privateKey != NULL)
    {
        NSLog(@"Successful");
    }
    //  [privateKeyAttr release];
    //  [publicKeyAttr release];
    //  [keyPairAttr release];
}

@end

