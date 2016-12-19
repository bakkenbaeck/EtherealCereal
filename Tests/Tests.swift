import XCTest
import EtherealCereal

class Tests: XCTestCase {

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testAddressGenerationHash() {
        // Generating the sha3-256 of an empty string always returns "c5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470"
        // We clip it to the ethereum address size and compare.
        let emtpyStringHash = "0xdcc703c0e500b653ca82273b7bfad8045d85a470"
        let etherealCereal =  EtherealCereal()
        let address = etherealCereal.generateAddress(from: "".data(using: .ascii)!)
        XCTAssertEqual(address, emtpyStringHash)
    }

    func testSignature() {
        let etherealCereal =  EtherealCereal(privateKey: "2639f727ded571d584643895d43d02a7a190f8249748a2c32200cfc12dde7173")
        let signature = etherealCereal.sign(message: "Hello message!")

        let expectedSignature = "7f89b86ee3ca79d32324b9c2ede02385b5a32ecd7c0caf5d7ceb0b34cf7c90697627d1cb3435c16bb72866273eb14bd9f387d74591382add29d4e39b8c11167300"
        let expectedAddress = "0x675f5810feb3b09528e5cd175061b4eb8de69075"
        
        XCTAssertEqual(signature, expectedSignature)
        XCTAssertEqual(etherealCereal.address, expectedAddress)
    }
}
