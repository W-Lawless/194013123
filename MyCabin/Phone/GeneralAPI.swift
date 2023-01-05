//
//  GeneralAPI.swift
//  MyCabin
//
//  Created by Lawless on 11/29/22.
//

import Foundation
import Combine

//protocol GCMS_API {
//
//    var cancelToken: AnyCancellable { get set }
//    mutating func fetch(for endpoint: Endpoint<some EndpointFormat, some Codable>, viewModel: some GCMSViewModel)
//}
//
//protocol GCMSViewModel {
//    func updateValues(_: Bool, data: [some Codable])
//}
//
//extension GCMS_API {
//    mutating func fetch(for endpoint: Endpoint<some EndpointFormat, some Codable>, viewModel: some GCMSViewModel) {
//
//        let publisher = Session.shared.publisher(for: endpoint, using: nil)
//
//        self.cancelToken = publisher.sink(
//            receiveCompletion: { completion in
//                switch completion {
//                case .failure(let error):
//                    print(error)
//                case .finished:
//                    return
//                }
//            },
//            receiveValue: { data in
//                viewModel.updateValues(true, data: data)
//            }
//        )
//
//    }
//}
//
//struct TestGeneral: GCMS_API {
//    var cancelToken = AnyCancellable {}
//}
