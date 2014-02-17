//
//  SURSAVerifier.h
//  Sparkle
//
//  Created by macdeveloper on 2014.02.17..
//
//
#ifndef SURSAVERIFIER_H
#define SURSAVERIFIER_H


#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>

// http://stackoverflow.com/questions/10222524/rsa-implementations-in-objective-c
// Special thanks to: @Parth Bath
// https://developer.apple.com/library/mac/#documentation/security/conceptual/CertKeyTrustProgGuide/iPhone_Tasks/iPhone_Tasks.html
// http://stackoverflow.com/questions/10072124/iphone-how-to-encrypt-nsdata-with-public-key-and-decrypt-with-private-key/10072378#10072378
@interface SURSAVerifier : NSObject
{
    SecKeyRef publicKey;
    SecKeyRef privateKey;
    NSData *publicTag;
    NSData *privateTag;
}

- (void)encryptWithPublicKey:(uint8_t *)plainBuffer cipherBuffer:(uint8_t *)cipherBuffer;
- (void)decryptWithPrivateKey:(uint8_t *)cipherBuffer plainBuffer:(uint8_t *)plainBuffer;
- (SecKeyRef)getPublicKeyRef;
- (SecKeyRef)getPrivateKeyRef;
- (void)testAsymmetricEncryptionAndDecryption;
- (void)generateKeyPair:(NSUInteger)keySize;

@end

#endif