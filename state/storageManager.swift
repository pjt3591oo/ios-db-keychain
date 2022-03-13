//
//  storageManager.swift
//  state
//
//  Created by 박정태 on 2022/03/13.
//

// Keychain

import Foundation
import Security

final class StorageManager {

  // MARK: Shared instance
  static let shared = StorageManager()
  private init() { }

  // MARK: Keychain
  private let account = "Service"
  private let service = Bundle.main.bundleIdentifier

  private lazy var query: [CFString: Any]? = {
    guard let service = self.service else { return nil }
    return [kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account]
  }()

    
  // SecItemAdd(_:_:) 함수를 사용해 키체인 아이템을 생성하고 성공했을 때 true를 반환합니다.
  func create<T: Decodable & Encodable>(_ d: T) -> Bool {
    guard let data = try? JSONEncoder().encode(d),
      let service = self.service else { return false }

    let query: [CFString: Any] = [kSecClass: kSecClassGenericPassword,
                                  kSecAttrService: service,
                                  kSecAttrAccount: account,
                                  kSecAttrGeneric: data]

    return SecItemAdd(query as CFDictionary, nil) == errSecSuccess
  }

  
  // SecItemCopyMatching(_:_:)함수를 사용해 키체인 아이템을 조회하여 성공했을 때 User를 반환
  func read<T: Decodable & Encodable>() -> T? {
    guard let service = self.service else { return nil }
    let query: [CFString: Any] = [kSecClass: kSecClassGenericPassword,
                                  kSecAttrService: service,
                                  kSecAttrAccount: account,
                                  kSecMatchLimit: kSecMatchLimitOne,
                                  kSecReturnAttributes: true,
                                  kSecReturnData: true]

    var item: CFTypeRef?
    if SecItemCopyMatching(query as CFDictionary, &item) != errSecSuccess { return nil }

    guard let existingItem = item as? [String: Any],
        let data = existingItem[kSecAttrGeneric as String] as? Data,
        let d = try? JSONDecoder().decode(T.self, from: data) else { return nil }

    return d
  }

  // SecItemUpdate(_:_:)함수를 사용해 키체인 아이템을 수정하고 성공했을 때 true를 반환
  func update<T: Decodable & Encodable>(_ d: T) -> Bool {
    guard let query = self.query,
      let data = try? JSONEncoder().encode(d) else { return false }
    
    let attributes: [CFString: Any] = [kSecAttrAccount: account,
                                     kSecAttrGeneric: data]

    return SecItemUpdate(query as CFDictionary, attributes as CFDictionary) == errSecSuccess
  }

  
  // SecItemDelete(_:)함수를 사용해 키체인 아이템을 삭제하고 성공했을 때 true를 반환
  func delete() -> Bool {
    guard let query = self.query else { return false }
    return SecItemDelete(query as CFDictionary) == errSecSuccess
  }
}
