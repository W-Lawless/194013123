//
//  UserDefaults.swift
//  MyCabin
//
//  Created by Lawless on 11/30/22.
//

import Foundation

//
//struct UserDefaultsUtil {
//
//    static let shared = UserDefaults.standard
//
//    private static var typeMap: [String:String] = [:]
//
//    static func setValue<T>(value: T, key: String) {
//        shared.set(value, forKey: key)
//
//        let valueType = type(of: value)
//        
//        switch(valueType) {
//        case is Bool:
//            typeMap[key] = "boolean"
//        default:
//            typeMap[key] = "This"
//        }
//
////        typeMap[key] = value.self
//    }
//
//    static func retrieveValue<T>(key: String) -> T {
//        let value = typeMap[key]
//        switch (value) {
//        case "boolean":
//            return shared.bool(forKey: key)
//        default:
//            shared.object(forKey: key)
//        }
//    }
//}


@propertyWrapper
struct UserDefaultUtil<T> {
    private let key: String
    private let defaultValue: T
    private let userDefaults: UserDefaults

    init(_ key: String, defaultValue: T, userDefaults: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.userDefaults = userDefaults
    }

    var wrappedValue: T {
        get {
            guard let value = userDefaults.object(forKey: key) else {
                return defaultValue
            }

            return value as? T ?? defaultValue
        }
        set {
            if let value = newValue as? OptionalProtocol, value.isNil() {
                userDefaults.removeObject(forKey: key)
            } else {
                userDefaults.set(newValue, forKey: key)
            }
        }
    }
}

fileprivate protocol OptionalProtocol {
    func isNil() -> Bool
}
