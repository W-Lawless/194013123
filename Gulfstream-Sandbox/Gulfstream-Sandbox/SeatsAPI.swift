//
//  Seats.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/10/22.
//

import Foundation


struct SeatsAPI {
    
    private var viewModel: SeatsViewModel
    
    init(viewModel: SeatsViewModel) {
        self.viewModel = viewModel
    }
    
    private let scheme = "http"
    private let host = "10.0.0.41"
    private let baseApi = "/api/v1/seats"
    private let seatState = "/state"
    private var configurableEndpoint: URLComponents {
        var URI = URLComponents()
        URI.scheme = self.scheme
        URI.host = self.host
        URI.path = self.baseApi
        return URI
    }
    
    func getSeats() async {

        guard let url = configurableEndpoint.url  else {
            print(" ❌: Invalid Endpoint")
            return
        }

        do {
            let (data, _) = try await Session.shared.data(from: url)
            let serializedData = try? JSONDecoder().decode(NetworkResponse<SeatModel>.self, from: data)
            if let model = serializedData { await viewModel.updateValues(data: model) }
        } catch { print(" ❌: Seats Api Error Decoding: \(error)") }
    }

    func call(seat: SeatModel) async {
        var URI = self.configurableEndpoint
        URI.path.append("/\(seat.id)")
        URI.path.append(self.seatState)

        guard let url = URI.url  else {
            print(" ❌: Invalid Endpoint")
            return
        }

        var request = URLRequest(url: url, timeoutInterval: 1)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let encodeObj = SeatModel.state(call: true, identifier: seat.id)
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
