//
//  WeWish.swift
//  WeWish
//
//  Created by Nikita Pishchugin on 30.10.23.
//

import CloudKit
import CoreData
import FirebaseCore
import RevenueCat
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        FirebaseApp.configure()
        
        Purchases.logLevel = .info
        Purchases.configure(withAPIKey: RevenueCat.apiKey)
        
        return true
    }
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        let sceneConfig = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
        sceneConfig.delegateClass = SceneDelegate.self
        return sceneConfig
    }
}

class SceneDelegate: NSObject, UIWindowSceneDelegate {
    func windowScene(_ windowScene: UIWindowScene, userDidAcceptCloudKitShareWith cloudKitShareMetadata: CKShare.Metadata) {
        let shareStore = CoreDataModel.shared.sharedPersistentStore
        let persistentContainer = PersistenceController.shared.container
        persistentContainer.acceptShareInvitations(from: [cloudKitShareMetadata], into: shareStore) { _, error in
            if error != nil {
                NotificationCenter.default.post(name: NotificationNames.errorDuringAcceptingShare,
                                                object: nil,
                                                userInfo: nil)
            }
            NotificationCenter.default.post(name: NotificationNames.shareSuccessfullyAccepted, 
                                            object: nil,
                                            userInfo: nil)
        }
    }
}

@main
struct wishlist_app: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(SignInWithAppleManager())
                .environmentObject(CoreDataModel())
                .environmentObject(SubscriptionManager())
                .environmentObject(CloudShareManager())
                .environmentObject(NetworkManager())
                .environmentObject(BlurContentView())
                .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
        }
    }
}
