//
//  Extensions.swift
//  SteadmanUI
//
//  Created by Spencer Steadman on 5/13/23.
//

import SwiftUI

enum PastelIntensity: Double {
    case low = 0.1, mid = 0.2, high = 0.25
}

extension Color {
    func pastelLighten(intensity: PastelIntensity = .low, animatedValue: Double = 1) -> Color {
        return self.opacity(intensity.rawValue * animatedValue)
    }
}

extension Array where Element: Equatable {
    func without(_ elementToRemove: Element) -> [Element] {
        var array = self
        for (index, element) in zip(self.indices, self) {
            if element == elementToRemove {
                array.remove(at: index)
            }
        }
        return array
    }
}
