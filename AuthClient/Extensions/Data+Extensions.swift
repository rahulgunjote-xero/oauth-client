import CommonCrypto
import Foundation

private typealias ChecksumAlgorithm = (UnsafeRawPointer?, CC_LONG, UnsafeMutablePointer<UInt8>?) -> UnsafeMutablePointer<UInt8>?

extension Data {
    
    public var sha1: Data {
        return computeChecksum(CC_SHA1_DIGEST_LENGTH, CC_SHA1)
    }
    
    public var sha256: Data {
        return computeChecksum(CC_SHA256_DIGEST_LENGTH, CC_SHA256)
    }

    private func computeChecksum(_ checksumLength: Int32, _ algorithm: ChecksumAlgorithm) -> Data {
        var checksum = Data(count: Int(checksumLength))
        withUnsafeBytes { (dataPtr: UnsafeRawBufferPointer) -> Void in
            checksum.withUnsafeMutableBytes { (checksumPtr: UnsafeMutableRawBufferPointer) -> Void in
                precondition(count <= CC_LONG.max)
                _ = algorithm(
                   dataPtr.baseAddress,
                   CC_LONG(count),
                   checksumPtr.baseAddress!.assumingMemoryBound(to: UInt8.self))
            }
        }
        return checksum
    }
    
    public var hexString: String {
        var result = ""
        for byte in self {
            result += String(format: "%02x", byte)
        }
        return result
    }
    
}


public extension Data {

    func base64urlEncodedString() -> String {
        base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
    }
    
    static func fromBase64urlEncodedString(_ string: String) -> Data? {
        let length = string.count
        return Data(
            base64Encoded: string
                .replacingOccurrences(of: "-", with: "+")
                .replacingOccurrences(of: "_", with: "/")
                .padding(
                    toLength: length + (4 - length % 4) % 4,
                    withPad: "=",
                    startingAt: 0
                )
        )
    }

}


extension Data {
    var prettyJson: String? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let jsonAsString = String(data: data, encoding:.utf8) else { return nil }

        return jsonAsString
    }
}
