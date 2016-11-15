import Foundation
import Security
import EtherealCereal.EtherWrapper

public class EtherealCereal: NSObject {

    public lazy var publicKey: String = {
        return self.publicKeyData.hexadecimalString
    }()

    public var privateKey: String {
        return self.privateKeyData.hexadecimalString
    }

    public lazy var publicKeyData: Data = {
        return self.generatePublicKey(from: self.privateKeyData)
    }()

    public lazy var address: String = {
        return self.generateAddress(from: self.publicKeyData)
    }()

    fileprivate var _privateKeyData: Data?

    public var privateKeyData: Data  {
        get {
            if let _privateKeyData = self._privateKeyData {
                return _privateKeyData
            }

            let _privateKeyData = self.generatePrivateKeyData()
            self._privateKeyData = _privateKeyData

            return _privateKeyData
        }

        set {
            self._privateKeyData = newValue
        }
    }

    fileprivate lazy var ether: EtherWrapper = {
        return EtherWrapper()
    }()

    public func generateAddress(from publicKeyData: Data) -> String {
        return self.ether.generateAddress(from: publicKeyData)
    }

    public func generatePublicKey(from privateKeyData: Data) -> Data {
        return self.ether.generatePublicKey(from: privateKeyData)
    }


    /// Cryptocurrencies require a very safely kept private key to sign transactions.
    /// This is used to guarantee that the user is who they say they are. 
    /// It's defined for Ethereum as a random, high-entropy 32-byte string.
    /// On iOS the safest way to create this is by using SecRandomCopyBytes() to generate it from /dev/random.
    /// For more information on the /dev/random random-number generator, see the manual page for random(4).
    ///
    /// - Returns: A private key in raw data format.
    public func generatePrivateKeyData() -> Data {
        var privateKey = Data(count: 32)

        // This creates the private key inside a block, result is of internal type ResultType.
        // We just need to check if it's 0 to ensure that there were no errors.
        let result = privateKey.withUnsafeMutableBytes { mutableBytes in
            SecRandomCopyBytes(kSecRandomDefault, privateKey.count, mutableBytes)
        }

        guard result == 0 else { fatalError("Failed to randomly generate and copy bytes for private key generation. SecRandomCopyBytes error code: (\(result)).") }

        return privateKey
    }

    public func sign(message: String) -> String {
        let messageData = message.data(using: .utf8)!
        
        return self.ether.sign(message: messageData, with: self.privateKeyData)
    }

    public convenience init(privateKey: String) {
        self.init()
        self._privateKeyData = privateKey.hexadecimalData!
    }
}

public extension Data {
    public var hexadecimalString: String {
        return (self as NSData).hexadecimalString()
    }
}

public extension String {
    public var hexadecimalData: Data? {
        let utf16 = self.utf16
        guard let data = NSMutableData(capacity: utf16.count/2) else { return nil }

        var byteChars: [CChar] = [0, 0, 0]
        var wholeByte: CUnsignedLong = 0
        var i = utf16.startIndex
        while i != utf16.endIndex {
            byteChars[0] = CChar(truncatingBitPattern: utf16[i])
            byteChars[1] = CChar(truncatingBitPattern: utf16[i.advanced(by: 1)])
            wholeByte = strtoul(byteChars, nil, 16)
            data.append(&wholeByte, length: 1)
            i = i.advanced(by: 2)
        }

        return data as Data
    }
}
