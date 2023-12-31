//
//  Extensions.swift
//  SteadmanUI
//
//  Created by Spencer Steadman on 5/13/23.
//

import SwiftUI

public enum PastelIntensity: Double {
    case low = 0.1, mid = 0.2, high = 0.25
}

extension Color {
    public func pastelLighten(intensity: PastelIntensity = .low, animatedValue: Double = 1) -> Color {
        return self.opacity(intensity.rawValue * animatedValue)
    }

    public static var clear: Color = Color.white.opacity(0.00001)
}

extension Array where Element: Equatable {
    public func without(_ elementToRemove: Element) -> [Element] {
        var array = self
        for (index, element) in zip(self.indices, self) {
            if element == elementToRemove {
                array.remove(at: index)
            }
        }
        return array
    }
}

extension Font {
    public static let description = Font.system(size: 15, weight: .bold)
    public static let miniIcon = Font.system(size: 20)
    public static let icon = Font.system(size: 30)
}

extension View {
    public func alignLeft() -> some View {
        self.modifier(LeftAligned())
    }
    
    public func alignRight() -> some View {
        self.modifier(RightAligned())
    }
    
    public func alignCenter() -> some View {
        self.modifier(CenterAligned())
    }
}
