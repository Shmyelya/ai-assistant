import Foundation

enum Secrets {
    static let obfuscatedKey: [UInt8] = []

    private static let salt = "test.groq.v1"

    /// Байт `i` ключа хранится как `keyUTF8[i] ^ saltUTF8[i % saltUTF8.count]`.
    /// Соль — UTF-8 строка `test.groq.v1`. Декодирование — тот же XOR.
    static func decodedKey() -> String {
        let saltBytes = Array(salt.utf8)
        guard !obfuscatedKey.isEmpty, !saltBytes.isEmpty else { return "" }

        var decoded = [UInt8]()
        decoded.reserveCapacity(obfuscatedKey.count)
        for (index, byte) in obfuscatedKey.enumerated() {
            decoded.append(byte ^ saltBytes[index % saltBytes.count])
        }
        return String(bytes: decoded, encoding: .utf8) ?? ""
    }
}
