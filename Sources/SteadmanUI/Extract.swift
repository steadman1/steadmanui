//
//  Extract.swift
//
//  Created by George Elsham on 17/11/2022.
//
//  from https://github.com/GeorgeElsham/ViewExtractor

import SwiftUI

public struct Extract<Content: View, ViewsContent: View>: Extractable {
    let content: () -> Content
    let views: (Views) -> ViewsContent

    public init(_ content: Content, @ViewBuilder views: @escaping (Views) -> ViewsContent) {
        self.content = { content }
        self.views = views
    }

    public init(@ViewBuilder _ content: @escaping () -> Content, @ViewBuilder views: @escaping (Views) -> ViewsContent) {
        self.content = content
        self.views = views
    }

    public var body: some View {
        _VariadicView.Tree(
            UnaryViewRoot(views: views),
            content: content
        )
    }
}

fileprivate struct UnaryViewRoot<Content: View>: _VariadicView_UnaryViewRoot {
    let views: (Views) -> Content

    func body(children: Views) -> some View {
        views(children)
    }
}

protocol Extractable: View {
    associatedtype Content: View
    associatedtype ViewsContent: View

    var content: () -> Content { get }
    var views: (Views) -> ViewsContent { get }

    init(_ content: Content, @ViewBuilder views: @escaping (Views) -> ViewsContent)
    init(@ViewBuilder _ content: @escaping () -> Content, @ViewBuilder views: @escaping (Views) -> ViewsContent)
}

public typealias Views = _VariadicView.Children
