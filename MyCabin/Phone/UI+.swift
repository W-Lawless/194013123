//
//  UI+.swift
//  MyCabin
//
//  Created by Lawless on 5/4/23.
//

import SwiftUI

protocol GCMSViewModel {
    func updateValues(_ data: [Codable])
}

protocol ParentViewModel: ViewWithSubViews & ObservableObject {}

protocol ViewWithSubViews {
    func showSubView(forID: String)
}

extension HorizontalAlignment {
    enum Custom: AlignmentID {
        static func defaultValue(in d: ViewDimensions) -> CGFloat {
            d[HorizontalAlignment.trailing]
        }
    }
    static let custom = HorizontalAlignment(Custom.self)
}
extension VerticalAlignment {
    enum Custom: AlignmentID {
        static func defaultValue(in d: ViewDimensions) -> CGFloat {
            d[VerticalAlignment.center]
        }
    }
    static let custom = VerticalAlignment(Custom.self)
}
extension Alignment {
    static let custom = Alignment(horizontal: .custom,
                                  vertical: .custom)
}
