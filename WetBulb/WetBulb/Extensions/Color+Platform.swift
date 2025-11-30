//
//  Color+Platform.swift
//  WetBulb
//
//  Created by Claude on 11/29/25.
//

import SwiftUI

extension Color {
    /// Platform-compatible system gray 6 color
    static var systemGray6: Color {
        #if os(iOS)
        return Color(UIColor.systemGray6)
        #elseif os(macOS)
        return Color(NSColor.systemGray)
        #else
        return Color.gray.opacity(0.1)
        #endif
    }
}
