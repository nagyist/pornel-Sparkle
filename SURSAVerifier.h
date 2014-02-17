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


extern const size_t SURSA_BUFFER_SIZE;
extern const size_t SURSA_CIPHER_BUFFER_SIZE;
extern const uint32_t SURSA_PADDING;

/* Constants used by SecKeyGeneratePair() - in SecKey.h.  Never used in any SecItem apis directly. */
// SEC_CONST_DECL (kSecPrivateKeyAttrs, "private");
// SEC_CONST_DECL (kSecPublicKeyAttrs, "public");

extern const char SURSA_kSecPublicKeyAttrs[];
extern const char SURSA_kSecPrivateKeyAttrs[];

extern const UInt8 SURSA_publicKeyIdentifier[];
extern const UInt8 SURSA_privateKeyIdentifier[];

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
- (UInt8 *)encryptWithPublicKey:(uint8_t *)plainBuffer;
- (UInt8 *)decryptWithPrivateKey:(uint8_t *)cipherBuffer;
- (SecKeyRef)getPublicKeyRef;
- (SecKeyRef)getPrivateKeyRef;
// - (void)testAsymmetricEncryptionAndDecryption;
- (void)generateKeyPair:(NSUInteger)keySize;

@end

#endif