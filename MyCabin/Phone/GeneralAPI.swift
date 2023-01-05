//
//  GeneralAPI.swift
//  MyCabin
//
//  Created by Lawless on 11/29/22.
//

import Foundation
import Combine

protocol GCMS_API {

    var cancelToken: AnyCancellable { get set }
    mutating func fetch<F: EndpointFormat, RT: Codable>(for endpoint: Endpoint<F,RT>, viewModel: GCMSViewModel, putData: F.RequestData)
}

protocol GCMSViewModel {
    func updateValues(_: Bool, data: [some Codable])
}

enum GCMS_APIResult<ResultType> {
    case success(data: ResultType)
    case failure
}

extension GCMS_API {
    mutating func fetch<F: EndpointFormat,RT: Codable>(for endpoint: Endpoint<F,RT>, viewModel: GCMSViewModel, putData: F.RequestData) {

        let publisher = Session.shared.publisher(for: endpoint, using: putData)

        self.cancelToken = publisher.sink(
            receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print(error)
                case .finished:
                    return
                }
            },
            receiveValue: { data in
                viewModel.updateValues(true, data: data)
            }
        )

    }
}

struct TestGeneral: GCMS_API {
    var cancelToken = AnyCancellable {}
}
