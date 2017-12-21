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

    func testSimpleSignature() {
        let etherealCereal =  EtherealCereal(privateKey: "2639f727ded571d584643895d43d02a7a190f8249748a2c32200cfc12dde7173")
        let signature = etherealCereal.sign(message: "Hello message!")

        let expectedSignature = "7f89b86ee3ca79d32324b9c2ede02385b5a32ecd7c0caf5d7ceb0b34cf7c90697627d1cb3435c16bb72866273eb14bd9f387d74591382add29d4e39b8c11167300"
        let expectedAddress = "0x675f5810feb3b09528e5cd175061b4eb8de69075"
        
        XCTAssertEqual(signature, expectedSignature)
        XCTAssertEqual(etherealCereal.address, expectedAddress)
    }

    func testSignatureWithoutHex() {
        let etherealCereal =  EtherealCereal(privateKey: "774681694ad86635346b6e9b92fa8aa4806265336dc6766623029a6264a162c1")
        let signature = etherealCereal.sign(hash: "0x9dd2c369a187b4e6b9c402f030e50743e619301ea62aa4c0737d4ef7e10a3d49")

        let expectedSignature = "16f89ddb9bf9ec08ff696bc766e675da7cfcb4f0b10bc8ce7c1a87a414a65a4f19c05c207e1b59f2e1cd18053cb8406fb7c6d22cec5e348d6217febbff8fc19801"
        let expectedAddress = "0x7e7cbf2e3f7611f860d41411a8287cc86cc789f3"

        XCTAssertEqual(signature, expectedSignature)
        XCTAssertEqual(etherealCereal.address, expectedAddress)
    }

    func testSignature() {
        let etherealCereal =  EtherealCereal(privateKey: "2639f727ded571d584643895d43d02a7a190f8249748a2c32200cfc12dde7173")
        let signature = etherealCereal.sign(hex: "0xe5808504a817c80082520894f59fc5a335e75060ff18beed2d6c8fbbbdab0dc2843b9aca0080")

        let expectedSignature = "8152ada8bece83905602d6b9a8a0f137dace41cd6a2da9d3fb26baa9fb79e2080e871937b634213a0e4cd7dee00c119567fa53096532e88ddf0fb183097bb4d701"
        let expectedAddress = "0x675f5810feb3b09528e5cd175061b4eb8de69075"

        XCTAssertEqual(signature, expectedSignature)
        XCTAssertEqual(etherealCereal.address, expectedAddress)
    }

    func testHexToData() {
        let hexString = "0x100000000000000000000000000000000000000000000000000000000000000000"
        let expected: [UInt8] = [16, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        XCTAssertEqual(hexString.hexadecimalData!, Data(expected))
    }

    func testHexToDataOddSizeInput() {
        let hexString = "0x10000000000000000000000000000000000000000000000000000000000000000"
        let expected: [UInt8] = [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        XCTAssertEqual(hexString.hexadecimalData!, Data(expected))
    }

    func testHexToDataWithout0x() {
        let hexString = "102030405060708090a0b0c0d0e0f2"
        let expected: [UInt8] = [16, 32, 48, 64, 80, 96, 112, 128, 144, 160, 176, 192, 208, 224, 242]
        XCTAssertEqual(hexString.hexadecimalData!, Data(expected))
    }

    func testBadHexData() {
        let hexString = "abcdog"
        XCTAssertNil(hexString.hexadecimalData)
    }
}
