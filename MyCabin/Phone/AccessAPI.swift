//
//  AccessAPI.swift
//  MyCabin
//
//  Created by Lawless on 12/1/22.
//

import Foundation
import UIKit
import Combine

class AccessAPI {
    
    var cancelToken: Cancellable?

    let endpoint = Endpoint<EndpointFormats.Get, AccessModel>(path: .access)
    
    
    func fetch() {
        let publisher = Session.shared.publisherForArrayResponse(for: endpoint, using: Void())
        
        self.cancelToken = publisher.sink(
            receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print(error)
                case .finished:
                    return
                }
            },
            receiveValue: { levels in
                levels.forEach{ level in
                    print(level.id, terminator: "\n")
                }
            }
        )
    }
    
    func registerDevice() {
        
        var address: String?

        // Get list of all interfaces on the local machine:
        var ifaddr: UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0, let firstAddr = ifaddr else {
            return
        }

        // For each interface ...
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee

            // Check for IPv4 or IPv6 interface:
            let addrFamily = interface.ifa_addr.pointee.sa_family
            
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                // Check interface name:
                let name = String(cString: interface.ifa_name)
                //check wifi
                if name == NetworkInterface.wifi.rawValue {
                    // Convert interface address to a human readable string:
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                                &hostname, socklen_t(hostname.count),
                                nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostname)
                }
            }
        }
        freeifaddrs(ifaddr)

        let id = UIDevice.current.identifierForVendor?.uuidString ?? ""
        let pin = String(describing: Int.random(in: 1000...9999))
        let random = String(describing: Int.random(in: 0...9))
        let createdAt = Int((Date().timeIntervalSince1970 * 1000).rounded())
        let name = "SANDBOX-DEVICE-\(random)"
        let encodedName = name.data(using: .utf8)?.base64EncodedString()
//        print(encodedName)
        let encodedID = id.data(using: .utf8)?.base64EncodedString()
//        print(encodedID)
        
        let newDevice = DeviceModel(id: id, name: "SANDBOX-DEVICE-\(random)", label: "", ipAddress: address ?? "", macAddress: id, accessLevel: "GUEST", enabled: true, immutable: false, pin: pin, accessLevelRequested: false, deviceType: "IPHONE", createdAt: createdAt, lastSeenAt: createdAt)
        
//        print(newDevice)
        
        let endpoint = Endpoint<EndpointFormats.Put<DeviceModel>, DeviceModel>(path: .registerDevice)
        let ipRequestHeader: [String:String] = ["gcms-ip-address": "4.2.6.7"]
        let publisher = Session.shared.publisher(for: endpoint, using: newDevice)
        
        
        self.cancelToken = publisher.sink (
            receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("there was an error", error)
                case .finished:
                    return
                }
            },
            receiveValue: { deviceRegistration in
                    print("put request data", deviceRegistration)
            }
        )
        
    }
}

enum NetworkInterface: String {
    case wifi = "en0"
    case cellular = "pdp_ip0"
    case localhost = "lo0"
    case airdrop = "awdl0"
    case firewire = "fw0"
    case ipv6toipv4 = "stf0"
    case ipv4toipv6 = "gif0"
    case bridge = "bridge0"
    case backToMyMac = "utun0"
    case vpn = "utun1"
}


