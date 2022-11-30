//
//  Cache.swift
//  MyCabin
//
//  Created by Lawless on 11/30/22.
//

import Foundation

struct CacheUtil {
    
    static var cache = NSCache<NSString, AnyObject>()
    
    static func store<T>(_ key: String, data: [T]) {
        let foo = NSString(string: key)
        cache.setObject(StructWrapper(wrappedStruct: data), forKey: foo)
    }
    
}

final class StructWrapper<T>: NSObject {
    let wrappedStruct: [T]
    init(wrappedStruct: [T]) {
        self.wrappedStruct = wrappedStruct
    }
}


struct CachedFileUtil {
    
    private static let plistPath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0].appendingPathComponent("MyCabinCache.plist")
    private static var encoder: PropertyListEncoder {
        get {
            let configurable = PropertyListEncoder()
            configurable.outputFormat = .xml
            return configurable
        }
    }
    
    static func cacheToFile<T: Codable>(data: Array<T>) {
        do {
            let data = try encoder.encode(data)
            try data.write(to: plistPath)
            print("data created in plist")
        } catch {
            print(error)
        }
    }
    
    static func retriveCachedFile<T>() -> [T] {
        
        let data = try! Data(contentsOf: plistPath)
        print("file found & data stream opened")
        let plist = try! PropertyListSerialization.propertyList(from: data, options: .mutableContainers, format: nil) as? [T] ?? [T]()
        print(plist)
        return plist
    }
    
}
