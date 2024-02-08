//
//  ActivityViewController.swift
//  WeWish
//
//  Created by Nikita Pishchugin on 02.11.23.
//

import SwiftUI

struct ActivityViewController: UIViewControllerRepresentable {
    var activityItems: [Any]
    var appicationActivities: [UIActivity]?

    func makeUIViewController(context _: Context) -> some UIViewController {
        let viewController = UIActivityViewController(activityItems: activityItems,
                                                      applicationActivities: appicationActivities)
        return viewController
    }

    func updateUIViewController(_: UIViewControllerType, context _: Context) {}
}
