//
//  ViewRepresentable.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2020-04-13.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

#if canImport(SwiftUI)
import UIKit.UIViewController
import SwiftUI

/// Convenient conversion from `UIViewController` to SwiftUI `View`.
@available(iOS 13, *)
public struct ViewRepresentable: UIViewControllerRepresentable {
    private let viewController: UIViewController
    
    public init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    public func makeUIViewController(context: Context) -> UIViewController {
        viewController
    }
    
    public func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // Unused
    }
}
#endif
