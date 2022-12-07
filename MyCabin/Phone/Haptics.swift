//
//  Haptics.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/9/22.
//

import SwiftUI

struct HapticFeedback: ViewModifier {
    private let generator: UIImpactFeedbackGenerator
    private let cb: () -> ()
    
    init(feedbackStyle: UIImpactFeedbackGenerator.FeedbackStyle, cb: @escaping () -> ()) {
        generator = UIImpactFeedbackGenerator(style: feedbackStyle)
        self.cb = cb
    }
    
    func body(content: Content) -> some View {
        content
            .onTapGesture {
                generator.impactOccurred()
                self.cb()
            }
    }
}

extension View {
    func hapticFeedback(feedbackStyle: UIImpactFeedbackGenerator.FeedbackStyle = .heavy, cb: @escaping () -> ()) -> some View {
        self.modifier(HapticFeedback(feedbackStyle: feedbackStyle, cb: cb))
    }
}
