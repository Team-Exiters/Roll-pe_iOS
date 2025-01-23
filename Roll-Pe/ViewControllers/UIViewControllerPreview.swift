//
//  UIViewControllerPreview.swift
//  Roll-Pe
//
//  Created by 김태은 on 1/23/25.
//

import SwiftUI

struct UIViewControllerPreview: UIViewControllerRepresentable {
    let viewController: () -> UIViewController

    init(_ viewController: @escaping () -> UIViewController) {
        self.viewController = viewController
    }

    func makeUIViewController(context: Context) -> UIViewController {
        return viewController()
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
