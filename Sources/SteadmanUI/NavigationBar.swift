//
//  NavigationBar.swift
//  SteadmanUI
//
//  Created by Spencer Steadman on 4/25/23.
//
#if os(iOS)
import SwiftUI

public struct NavigationItem: View {
    @Environment(\.index) var index
    @ObservedObject public var bar = NavigationBar.shared
    @State var animation: CGFloat = 0
    @State public var icon: Image
    public var activeIcon: Image?
    public var name: String
	public var width: CGFloat
    
    public init(bar: NavigationBar = NavigationBar.shared, name: String, icon: Image, width: CGFloat = 100) {
        self.bar = bar
        self.name = name
        self.icon = icon
	    self.width = width
    }
    
    public init(bar: NavigationBar = NavigationBar.shared, name: String, from: Image, to: Image, width: CGFloat = 100) {
        self.bar = bar
        self.name = name
        self.icon = from
        self.activeIcon = to
	    self.width = width
    }
    
    public var body: some View {
        let isActive = bar.selectionIndex == index
        let foregroundColor: Color = NavigationBar.foregroundItemColor //isActive ? NavigationBar.foregroundItemColor : .black
        return HStack {
            if activeIcon != nil && isActive {
                activeIcon
                    .font(NavigationBar.iconFont)
                    .foregroundColor(foregroundColor)
            } else {
                icon	
			.font(NavigationBar.iconFont)
			.foregroundColor(foregroundColor)
                    
            }
            if animation != 0 {
                HStack {
                    Spacer()
                    Text(name)
                        .font(NavigationBar.font)
                        .foregroundColor(NavigationBar.foregroundItemColor)
                    Spacer()
                }
            }
        }.frame(width: 16 + width * animation, height: 48)
            .padding([.leading, .trailing], 12)
            .padding([.top, .bottom], 8)
            .background(NavigationBar.foregroundColor.opacity(animation))
            .cornerRadius(NavigationBar.cornerRadius)
            .onAppear {
                animation = isActive ? 1 : 0
            }.onTapGesture {
                if bar.isChangeable {
                    Screen.impact()
                    bar.selectionIndex = index
                }
            }.onChange(of: bar.selectionIndex) { newValue in
                withAnimation(.navigationItemBounce) {
                    if bar.selectionIndex == index {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                            withAnimation(.navigationItemBounce) {
                                animation = 1
                            }
                        }
                    } else {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                            withAnimation(.navigationItemBounce) {
                                animation = 0
                            }
                        }
                    }
                }
            }.onChange(of: animation) { newValue in
                bar.isChangeable = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    bar.isChangeable = true
                }
            }
    }
}

public class NavigationBar: ObservableObject {
    @ObservedObject public static var shared = NavigationBar()
    @Published public var isShowing = false
    @Published public var isChangeable = true
    @Published public var selectionIndex = 0
    public static var foregroundColor: Color = .blue.pastelLighten()
    public static var foregroundItemColor: Color = .blue
    public static var backgroundColor: Color = .white
    public static var cornerRadius: CGFloat = 50
    public static var iconFont: Font = .miniIcon
    public static var font: Font = .system(size: 14).bold()
    static let height: CGFloat = 116
    static let halfHeight: CGFloat = 58
    static let itemHeight: CGFloat = 45
    static let topPadding: CGFloat = 16
}

public struct CustomNavigationBar<Content: View>: View {
    @ObservedObject var bar = NavigationBar.shared
    @ObservedObject var screen = Screen.shared
    public let items: [NavigationItem]
    public let content: Content
    //let label: LabelContent
    
    public init(items: [NavigationItem], @ViewBuilder content: @escaping () -> Content) {
        self.content = content()
        self.items = items
    }
    
    public var body: some View {
        ZStack {
            Extract(content) { views in
            // ^ from https://github.com/GeorgeElsham/ViewExtractor
                VStack {
                    ForEach(Array(zip(views.indices, views)), id: \.0) { index, view in
                        if bar.selectionIndex == index {
                            view
                        }
                    }
                }
            }

            Rectangle() // only shows shadow
                .frame(width: screen.width, height: NavigationBar.height)
                .background(NavigationBar.backgroundColor)
                .position(x: screen.halfWidth, y: screen.height - NavigationBar.halfHeight + screen.safeAreaInsets.bottom)
                .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: -4)
            
            ZStack {
                HStack {
                    ForEach(Array(zip(items.indices, items)), id: \.0) { index, item in
						item.environment(\.index, index)
			                        
						if (index < items.count - 1) {
						    Spacer()
						}
                    }
                }.frame(width: screen.width - Screen.padding * 2)
            }.frame(width: screen.width, height: NavigationBar.height)
                .background(NavigationBar.backgroundColor)
		.padding(.top, (NavigationBar.height - NavigationBar.itemHeight) / -2 + NavigationBar.topPadding)
                .position(x: screen.halfWidth, y: screen.height - NavigationBar.halfHeight + screen.safeAreaInsets.bottom)
            // Rectangle()
            //     .frame(width: screen.width, height: 2)
            //     .foregroundColor(.gray.pastelLighten())
            //     .position(x: screen.halfWidth, y: screen.height - NavigationBar.height + screen.safeAreaInsets.bottom)
            
        }.onAppear {
            bar.isShowing = true
        }.onDisappear {
            bar.isShowing = false
        }
    }
}

extension Animation {
    public static let navigationItemBounce: Animation = .interpolatingSpring(stiffness: 250, damping: 22).speed(1.25)
}

extension EnvironmentValues {
  public var index: Int {
    get { self[IndexKey.self] }
    set { self[IndexKey.self] = newValue }
  }
}

private struct IndexKey: EnvironmentKey {
  public static let defaultValue = 0
}
#endif
