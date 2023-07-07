//
//  CustomSheet.swift
//  Challenge
//
//  Created by Spencer Steadman on 4/3/23.
//
#if os(iOS)

import SwiftUI

public enum SteadmanSheetClosedMode {
    case closed, reopenable
}

public struct SteadmanSheet<Content: View, LabelContent: View>: View {
    @ObservedObject var screen = Screen.shared
    @Binding public var isPresented: Bool
    @Binding public var height: CGFloat
    @State var animation: Double = 0
    @State var dragHeight: Double = 0
    @State var dragHeightStart: Double = 0
    public let mode: SteadmanSheetClosedMode
    let size = 250.0
    public let content: Content
    public let label: LabelContent
    
    let dismissRadius = 100.0
    
    public init(isPresented: Binding<Bool>,
         height: Binding<CGFloat>,
         mode: SteadmanSheetClosedMode,
         @ViewBuilder content: @escaping () -> Content,
         @ViewBuilder label: @escaping () -> LabelContent) {
        
        self._isPresented = isPresented
        if isPresented.wrappedValue {
            self._animation = State(initialValue: 1)
        }
        self._height = height
        self.mode = mode
        self.content = content()
        self.label = label()
    }
    
    public var body: some View {
        var position = screen.height + screen.halfHeight + screen.safeAreaInsets.bottom - (size * animation)
        if dragHeight > 0 {
            position = screen.halfHeight + dragHeight - 57
            if !isPresented && mode == .reopenable {
                position += 30
            }
        } else if NavigationBar.shared.isShowing {
            position -= NavigationBar.height
        }
        
        if !isPresented && mode == .reopenable {
            position -= 30
        }
        
        return ZStack {
            content
            
            ZStack {
                VStack {
                    Spacer().frame(height: 30)
                    label.frame(width: screen.width,
                                height: size + (dragHeightStart - dragHeight) - screen.safeAreaInsets.bottom - 30)
                    Spacer()
                }.frame(width: screen.width, height: screen.height + screen.safeAreaInsets.top + screen.safeAreaInsets.bottom)
                    .background(Color.white)
                    .cornerRadius(Screen.cornerRadius)
                
                VStack {
                    Spacer().frame(height: 12)
                    Rectangle()
                        .frame(width: 50, height: 6)
                        .foregroundColor(.gray.opacity(0.25))
                        .cornerRadius(100)
                    Spacer().frame(height: 12)
                }.frame(width: screen.width)
                    .background(Color.white)
                    .cornerRadius(100)
                    .offset(x: 0, y: -screen.halfHeight + 15)
                    .gesture(
                        DragGesture(coordinateSpace: .global)
                            .onChanged { drag in
                                if drag.location.y < screen.safeAreaInsets.top {
                                    return
                                } else if drag.location.y > 0 {
                                    withAnimation() {
                                        dragHeight = drag.location.y
                                        dragHeightStart = drag.startLocation.y
                                    }
                                } else {
                                    dragHeightStart = 0
                                    withAnimation(.sheetBounce) {
                                        dragHeight = 0
                                    }
                                }
                            }.onEnded { drag in
                                if drag.location.y > screen.height - dismissRadius {
                                    withAnimation(.easeOut(duration: 0.2)) {
                                        dragHeight = 0
                                        dragHeightStart = 0
                                        animation = 0
                                        isPresented = false
                                    }
                                } else {
                                    withAnimation(.sheetBounce) {
                                        dragHeight = 0
                                        dragHeightStart = 0
                                        animation = 1
                                        if !isPresented {
                                            isPresented = true
                                        }
                                    }
                                }
                            }
                    )
            }.position(x: screen.halfWidth, y: position)
        }.frame(width: screen.width)
            .onChange(of: isPresented) { newValue in
                if newValue {
                    withAnimation(.sheetBounce) {
                        animation = 1
                    }
                } else {
                    withAnimation(.easeIn(duration: 0.25)) {
                        animation = 0
                    }
                }
            }.onChange(of: position) { newValue in
                withAnimation(.sheetBounce) {
                    height = size * animation  - (dragHeight - dragHeightStart) + NavigationBar.halfHeight
                }
            }
    }
}

public struct SteadmanSheetModifier<LabelContent: View>: ViewModifier {
    @Binding public var isPresented: Bool
    @Binding public var height: CGFloat
    public let mode: SteadmanSheetClosedMode
    public let label: LabelContent

    public func body(content: Content) -> some View {
        SteadmanSheet(isPresented: $isPresented, height: $height, mode: mode) {
            content
        } label: {
            label
        }
    }
}

extension View {
    public func steadmanSheet<LabelContent>(isPresented: Binding<Bool>,
                                   height: Binding<CGFloat>,
                                   mode: SteadmanSheetClosedMode = .closed,
                              @ViewBuilder label: @escaping () -> LabelContent) -> some View where LabelContent: View {
        
        self.modifier(SteadmanSheetModifier(isPresented: isPresented,
                                          height: height,
                                          mode: mode,
                                          label: label()))
    }
}

extension Animation {
    static let sheetBounce: Animation = .interpolatingSpring(stiffness: 250, damping: 20)
}
#endif
