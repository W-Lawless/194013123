//
//  GeneralAPI.swift
//  MyCabin
//
//  Created by Lawless on 11/29/22.
//

import Foundation
import Combine
//
//protocol GCMS_API<Format, ResultModel> {
//    associatedtype Format: EndpointFormat
//    associatedtype ResultModel: Codable
//    associatedtype ViewModel: GCMSViewModel
//    var viewModel: ViewModel { get set }
//    var endpoint: Endpoint<Format, ResultModel> { get set }
//    var cancelToken: Cancellable { get set }
//    func fetch()
//}
//
//protocol GCMSViewModel {
//    associatedtype ResponseModel
//    func updateValues(_: Bool, data: [ResponseModel])
//}
//
//extension GCMS_API {
//    mutating func fetch() {
//
//        let generalEndpoint = self.endpoint
//
//        let publisher = Session.shared.publisher(for: self.endpoint, using: Self.Format.RequestData.self as! Self.Format.RequestData)
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
//                self.viewModel.updateValues(true, data: data)
//            }
//        )
//    }
//}
