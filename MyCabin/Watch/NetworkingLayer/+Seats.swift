//
//  CallAttendant.swift
//  wearable Watch App
//
//  Created by Lawless on 11/10/22.
//

import Foundation

class SeatsApi: ObservableObject {

    @Published var seatList: [Seat]?
    
    private let scheme = "http"
    private let host = "10.0.0.41"
    private let baseApi = "/api/v1/seats"
    private let seatState = "/state"
    
    func getSeats() async {
        var endpoint: URL? {
            var URI = URLComponents()
            URI.scheme = self.scheme
            URI.host = self.host
            URI.path = self.baseApi
            return URI.url
        }
        
        guard let url = endpoint  else {
            print(" ❌: Invalid Endpoint")
            return
        }
        
        do {
            let (data, _) = try await Session.shared.data(from: url)
            let serializedData = try? JSONDecoder().decode(SeatsModel.self, from: data)
            
            if let model = serializedData {
                DispatchQueue.main.async {
                    var out = [Seat]()
                    
                    model.results.forEach { Seat in
                        out.append(Seat)
                    }
                    
                    self.seatList = out
                }
            }
        } catch { print(" ❌: Seats Api Error Decoding: \(error)") }
    }
    
    func call(seat: Seat) async {
        var endpoint: URL? {
            var URI = URLComponents()
            URI.scheme = self.scheme
            URI.host = self.host
            URI.path = "\(self.baseApi)"
            URI.path.append("/\(seat.id)")
            URI.path.append(self.seatState)
            return URI.url
        }
        
        guard let url = endpoint  else {
            print(" ❌: Invalid Endpoint")
            return
        }
        
        print(url)
        
        var request = URLRequest(url: url, timeoutInterval: 1)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let encodeObj = Seat.state(call: true, identifier: seat.id)
        let requestBody = try? JSONEncoder().encode(encodeObj)
        
        request.httpBody = requestBody
        do {
            let (_, res) = try await Session.shared.data(for: request)
            if let res = res as? HTTPURLResponse {
                print("Seat Call Response: \(res.statusCode)")
            }
        } catch { print(" ❌: Seats Api Error Decoding: \(error)") }
    }
    
    func call(byName: String) async {
        var endpoint: URL? {
            var URI = URLComponents()
            URI.scheme = self.scheme
            URI.host = self.host
            URI.path = "\(self.baseApi)/\(byName)/\(self.seatState)"
            return URI.url
        }
        
        guard let url = endpoint  else {
            print(" ❌: Invalid Endpoint")
            return
        }
        
        var request = URLRequest(url: url, timeoutInterval: 1)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let encodeObj = Seat.state(call: true, identifier: byName)
        let requestBody = try? JSONEncoder().encode(encodeObj)
        request.httpBody = requestBody
        do {
            let (_, res) = try await Session.shared.data(for: request)
            if let res = res as? HTTPURLResponse {
                print("Seat Call Response: \(res.statusCode)")
            }
        } catch { print(" ❌: Seats Api Error Decoding: \(error)") }
    }
}


struct SeatsModel: Codable {
    var results: [Seat]
    var length: Int
}

struct StateModel: Codable {
    var results: [State]
    var length:Int
    struct State: Codable {
        var call: Bool
        var identifier: String
    }
}

struct Seat: Codable, Identifiable {
    var id: String
    var name: String
    struct rect: Codable {
        var x: Float
        var y: Float
        var w: Float
        var h: Float
        var r: Float
    }
    var side: String
    var sub: [String?]
    var assoc: [Assoc?]
    var type: String
    var short_name: String
    var chirality: String
    struct state: Codable {
        var call: Bool
        var identifier: String
    }
}

struct Assoc: Codable {
    var decoratorType: String
    var id: String
    
    enum CodingKeys: String, CodingKey {
        case decoratorType = "@type"
        case id
    }
}


