//
//  NSData+AESCrypt.h
//  Sparkle
//
//  Created by istvan on 14.2.17..
//
//

#import <Foundation/Foundation.h>

//  http://stackoverflow.com/questions/10072124/iphone-how-to-encrypt-nsdata-with-public-key-and-decrypt-with-private-key/10072378#10072378

@interface NSData_AESCrypt : NSObject

- (NSData *)AES256EncryptWithKey:(NSString *)key;
- (NSData *)AES256DecryptWithKey:(NSString *)key;

+ (NSData *)dataWithBase64EncodedString:(NSString *)string;
- (id)initWithBase64EncodedString:(NSString *)string;

- (NSString *)base64Encoding;
- (NSString *)base64EncodingWithLineLength:(NSUInteger)lineLength;

- (BOOL)hasPrefixBytes:(const void *)prefix length:(NSUInteger)length;
- (BOOL)hasSuffixBytes:(const void *)suffix length:(NSUInteger)length;

@end
