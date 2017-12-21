#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (Hex)

- (NSString *)hexadecimalString;

/**
 Despite its name, this actually does a Keccak elliptical curve hashing. The name is kept as SHA3 for legacy reasons.
 
 @param digest The length of the hashing. Ethereum requires 256.
 @return The hashed version of original data object. Non-mutating.

 @discussion Currently only used internally to hash a message pre-signing.
 */
- (NSData *)sha3:(NSUInteger)digest;

@end

@interface EtherWrapper : NSObject


/**
 Derive a public key from a given private key (in raw data format).

 @param privateKey The original raw data private key. Always keep this safe.
 @return The generated public key, as raw data.
 */
- (NSData *)generatePublicKeyFromPrivateKey:(NSData *)privateKey NS_SWIFT_NAME(generatePublicKey(from:));


/**
 Derive the Ethereum address string for a given public key (always raw data).

 @param publicKey The public key in raw data format.
 @return A 40 character hexadecimal string, that is the public address for the Ethereum user.
 */
- (NSString *)generateAddressFromPublicKey:(NSData *)publicKey NS_SWIFT_NAME(generateAddress(from:));


/**
 Sign a message/transaction with a given private key (always raw data).

 @param message The message or transaction to be signed.
 @param privateKey The raw data private key from the user. Should be kept safe at all costs.
 @param withHashing Whether sha3 should be called on the message
 @return A 130 character hexadecimal string. This is the signature for a given message. If you have this and the original message, you can recover an address. Use it to guaratee the message originator.
 */
- (NSString *)signMessage:(NSData *)message withKey:(NSData *)privateKey withHashing:(BOOL)withHashing NS_SWIFT_NAME(sign(message:with:withHashing:));

@end

NS_ASSUME_NONNULL_END
