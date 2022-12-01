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
//        cache.setObject([data], forKey: foo)

        cache.setObject(StructWrapper(wrappedStruct: data), forKey: foo)
    }
    
}

final class StructWrapper<T>: NSObject {
    let wrappedStruct: [T]
    init(wrappedStruct: [T]) {
        self.wrappedStruct = wrappedStruct
    }
}


struct FileCacheUtil {
    
    private static let plistPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("MyCabinCache.plist")
    
    private static var encoder: PropertyListEncoder {
        get {
            let configurable = PropertyListEncoder()
            configurable.outputFormat = .xml
            return configurable
        }
    }
    
    static func cacheToFile<T: Codable>(data: Array<T>) {
        
        data.forEach { item in
            print(item, terminator: "\n")
        }
        
        do {
            let data = try encoder.encode(data)
            print("Data Encoded as:", data)
            try data.write(to: plistPath)
            print("data created in plist")

            let plist = try PropertyListSerialization.propertyList(from: data, options: .mutableContainers, format: nil) 
            print(plist)
        } catch {
            print(error)
        }
    }
    
    static func retrieveCachedFile<T>(dataModel: T) throws -> T? {
        
        do {
            let data = try? Data(contentsOf: plistPath)
            if let data = data {
                print("file found & data stream opened")
                let plist = try! PropertyListSerialization.propertyList(from: data, options: .mutableContainers, format: nil) as? T ?? [] as! T
                print(plist)
                return plist
            } else {
                throw MyError()
            }
        } catch {
            print(error)
        }
        return nil
    }
    
}

struct MyError: Error {
    let message = "No cached file"
}
