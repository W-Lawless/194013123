//
//  Haptics.swift
//  Gulfstream-Sandbox
//
//  Created by Lawless on 11/9/22.
//

import SwiftUI

struct HapticFeedback: ViewModifier {
    private let generator: UIImpactFeedbackGenerator
    private let cb: (_: Codable?) -> ()
    private let data: Codable?
    
    init(feedbackStyle: UIImpactFeedbackGenerator.FeedbackStyle, cb: @escaping (_: Codable?) -> (), data: Codable?) {
        generator = UIImpactFeedbackGenerator(style: feedbackStyle)
        self.cb = cb
        self.data = data
    }
    
    func body(content: Content) -> some View {
        content
            .onTapGesture {
                generator.impactOccurred()
                self.cb(self.data)
            }

    }
}

struct LongPressHaptic: ViewModifier {
    private let generator: UIImpactFeedbackGenerator
    private let cb: () -> ()
    
    init(feedbackStyle: UIImpactFeedbackGenerator.FeedbackStyle, cb: @escaping () -> ()) {
        generator = UIImpactFeedbackGenerator(style: feedbackStyle)
        self.cb = cb
    }
    
    func body(content: Content) -> some View {
        content
            .onLongPressGesture {
                generator.impactOccurred()
                self.cb()
            }
    }
}

extension View {
    func hapticFeedback(feedbackStyle: UIImpactFeedbackGenerator.FeedbackStyle = .heavy, cb: @escaping (_:  Codable?) -> (), data: Codable? = nil) -> some View {
        self.modifier(HapticFeedback(feedbackStyle: feedbackStyle, cb: cb, data: data))
    }
}

extension View {
    func longPressHaptic(feedbackStyle: UIImpactFeedbackGenerator.FeedbackStyle = .heavy, cb: @escaping () -> ()) -> some View {
        self.modifier(LongPressHaptic(feedbackStyle: feedbackStyle, cb: cb))
    }
}
