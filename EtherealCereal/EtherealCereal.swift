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
        let count = privateKey.count
        let result = privateKey.withUnsafeMutableBytes { mutableBytes in
            SecRandomCopyBytes(kSecRandomDefault, count, mutableBytes)
        }

        guard result == 0 else { fatalError("Failed to randomly generate and copy bytes for private key generation. SecRandomCopyBytes error code: (\(result)).") }

        return privateKey
    }


    /// Returns a KECCAK-256 encoded in base64.
    ///
    /// - Parameter string: A string to KECCAK-256 encode.
    /// - Returns: A KECCAK-256-encoded base64 encoded string.
    public func sha3(string: String) -> String {
        let data = string.data(using: .utf8)!
        return self.sha3(data: data)
    }

    /// Returns a KECCAK-256 encoded in base64.
    ///
    /// - Parameter data: Data to be KECCAK-256 encoded.
    /// - Returns: A KECCAK-256-encoded base64 encoded string.
    public func sha3(data: Data) -> String {
        return (data as NSData).sha3(256).base64EncodedString()
    }

    public func sign(message: String) -> String {
        let messageData = message.data(using: .utf8)!
        return self.ether.sign(message: messageData, with: self.privateKeyData, withHashing: true)
    }

    public func sign(hex: String) -> String {
        let data = hex.hexadecimalData!
        return self.ether.sign(message: data, with: self.privateKeyData, withHashing: true)
    }

    public func sign(hash: String) -> String {
        let data = hash.hexadecimalData!
        return self.ether.sign(message: data, with: self.privateKeyData, withHashing: false)
    }

    public convenience init(privateKey: String) {
        self.init()
        self._privateKeyData = privateKey.hexadecimalData!
    }

    public override init() {
        super.init()
    }
}

public extension Data {
    public var hexadecimalString: String {
        return (self as NSData).hexadecimalString()
    }
}

struct EtherealCerealRegex {
    static var hexadecimalDataRegex: NSRegularExpression = {
        return try! NSRegularExpression(pattern: "^(?:0x)?([a-fA-F0-9]*)$", options: .caseInsensitive)
    }()
}

public extension String {
    public var hexadecimalData: Data? {
        guard let match = EtherealCerealRegex.hexadecimalDataRegex.matches(in: self, range: NSMakeRange(0, self.count)).first
            else { return nil }

        let hexadecimalString = (self as NSString).substring(with: match.range(at: 1))
        let utf16View: UTF16View
        if hexadecimalString.count % 2 == 1 {
            utf16View = "0\(hexadecimalString)".utf16
        } else {
            utf16View = hexadecimalString.utf16
        }
        guard let data = NSMutableData(capacity: utf16View.count/2) else { return nil }

        var byteChars: [CChar] = [0, 0, 0]
        var wholeByte: CUnsignedLong = 0
        var i = utf16View.startIndex

        while i < utf16View.index(before: utf16View.endIndex) {
            byteChars[0] = CChar(truncatingIfNeeded: utf16View[i])
            byteChars[1] = CChar(truncatingIfNeeded: utf16View[utf16View.index(after: i)])
            wholeByte = strtoul(byteChars, nil, 16)
            data.append(&wholeByte, length: 1)
            i = utf16View.index(i, offsetBy: 2)
        }

        return data as Data
    }
}
