//
//  EmailHelper.swift
//  WeWish
//
//  Created by Nikita Pishchugin on 07.12.23.
//

import MessageUI
import SwiftUI
import UIDeviceComplete

struct EmailHelper {
    let toAddress: String
    let subject: String
    let messageHeader: String
    var body: String {
        """
        \(messageHeader)
        
        --------------------------------------------
        iOS: \(UIDevice.current.systemVersion)
        Device Model: \(UIDevice.current.dc.commonDeviceName)
        App Version: \(UIApplication.appVersion ?? "")
        App Build: \(String(describing: Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") ?? ""))
        """
    }
    
    func send(openURL: OpenURLAction) {
        let urlString = "mailto:\(toAddress)?subject=\(subject.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? "")&body=\(body.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? "")"
        
        guard let url = URL(string: urlString) else { return }
        openURL.callAsFunction(url) { accepted in
            if !accepted {
                print("""
                This device doesn't support email
                \(body)
                """)
            }
        }
//        openURL(url) { accepted in
//            if !accepted {
//                print("""
//                This device doesn't support email
//                \(bodym )
//                """)
//            }
//        }
    }
}
