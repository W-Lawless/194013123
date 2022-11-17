//
//  ElementsAPI.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/16/22.
//

import Foundation

struct ElementsAPI {
    
    private var viewModel: SeatsViewModel
    
    init(viewModel: SeatsViewModel) {
        self.viewModel = viewModel
    }
    
    private let scheme = "http"
    private let host = "10.0.0.41"
    private let baseApi = "/api/v1/elements"
    private let tables = "?type=Table"
    private let source = "?type=Source"
    private let seats = "?type=Seats"
    private let window = "?type=Window"
    private let area = "?type=Area"
    
    private var configurableEndpoint: URLComponents {
        var URI = URLComponents()
        URI.scheme = self.scheme
        URI.host = self.host
        URI.path = self.baseApi
        return URI
    }
    
    func initialFetch() async {
 
        guard let url = configurableEndpoint.url  else {
            print(" ❌: Invalid Endpoint")
            return
        }
        
        do {
            let (data, _) = try await Session.shared.data(from: url)
            let serializedData = try? JSONDecoder().decode(SeatsModel.self, from: data)
            if let model = serializedData { await viewModel.updateValues(data: model) }
        } catch { print(" ❌: Seats Api Error Decoding: \(error)") }
    }
    
}
