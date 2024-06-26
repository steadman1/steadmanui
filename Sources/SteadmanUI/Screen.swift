//
//  Screen.swift
//  SteadmanUI
//
//  Created by Spencer Steadman on 12/26/22.
//

import SwiftUI
import UIKit

public class Screen: ObservableObject {
    @ObservedObject public static var shared = Screen()
    @Published public var safeAreaInsets = EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
#if os(iOS)
    @Published public var width = UIScreen.main.bounds.size.width
    @Published public var halfWidth = UIScreen.main.bounds.size.width / 2
    @Published public var height = UIScreen.main.bounds.size.height
    @Published public var halfHeight = UIScreen.main.bounds.size.height / 2
    public var initialSafeAreaInsets = EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
    public static var widthToLargestIPhone: Double {
        let LARGEST_IPHONE_WIDTH = 393.0
        return Screen.shared.width > LARGEST_IPHONE_WIDTH ? LARGEST_IPHONE_WIDTH : Screen.shared.width - Screen.padding * 2
    }
    public static let size = UIScreen.main.bounds.size
#endif
    public static let padding = 16.0
    public static let halfPadding = 8.0
    public static let cornerRadius = 18.0
#if os(iOS)
    public static func impact(enabled: Bool, style: UIImpactFeedbackGenerator.FeedbackStyle = .light) {
        if enabled {
            UIImpactFeedbackGenerator(style: style).impactOccurred()
        }
    }

    public static func notification(enabled: Bool, style: UINotificationFeedbackGenerator.FeedbackType = .success) {
        if enabled {
            UINotificationFeedbackGenerator().notificationOccurred(style)
        }
    }
    
    public static func rollingImpact(n: Int = 0) {
        let impacts: [UIImpactFeedbackGenerator.FeedbackStyle] = [
            .rigid,
            .heavy,
            .medium,
            .light,
            .soft
        ]
        
        if n == impacts.count {
            return
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                UIImpactFeedbackGenerator(style: impacts[n]).impactOccurred(intensity: 1)
                rollingImpact(n: n + 1)
            }
        }
    }
#endif
}

public struct VPad: View {
    public var size: CGFloat = Screen.padding
    public var body: some View {
        Spacer().frame(height: size)
    }
}

public struct HPad: View {
    public var size: CGFloat = Screen.padding
    public var body: some View {
        Spacer().frame(width: size)
    }
}

public struct SheetXMark: View {
    @Binding public var presentationMode: PresentationMode
    public var body: some View {
        HStack {
            Spacer()
            
            Button {
                $presentationMode.wrappedValue.dismiss()
            } label: {
                ZStack {
                    Image(systemName: "xmark")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(Color.gray)
                }.padding(Screen.halfPadding)
                    .background(Color.gray.pastelLighten(intensity: .mid))
                    .cornerRadius(100)
            }
        }.padding([.leading, .trailing, .bottom], Screen.padding)
    }
}

public struct LeftAligned: ViewModifier {
    public func body(content: Content) -> some View {
        HStack {
            content
            Spacer()
        }
    }
}

public struct RightAligned: ViewModifier {
    public func body(content: Content) -> some View {
        HStack {
            Spacer()
            content
        }
    }
}

public struct CenterAligned: ViewModifier {
    public func body(content: Content) -> some View {
        HStack {
            Spacer()
            content
            Spacer()
        }
    }
}
