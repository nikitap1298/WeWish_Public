//
//  IntroduceTab-Model.swift
//  WeWish
//
//  Created by Nikita Pishchugin on 19.12.23.
//

import Foundation

struct IntroduceTabModel {
    let id: Int
    let mainImageName: String
    let mainText: String
}

struct IntroduceTabRowModel: Identifiable {
    let id: Int
    let imageName: String
    let text: String
    let description: String
}

struct IntroduceTabRowData {
    static let owned = [
        IntroduceTabRowModel(id: 0,
                             imageName: "plus",
                             text: "Create Wishes",
                             description: "Create wishes manually or partially fill in the data using website links or photos."),
        IntroduceTabRowModel(id: 1,
                             imageName: "square.and.arrow.up",
                             text: "Share Wishes",
                             description: "Share your wishes with other users.")
    ]
    
    static let shared = [
        IntroduceTabRowModel(id: 0,
                             imageName: "person",
                             text: "See the wishes that are Shared with you",
                             description: "You'll see the list here when someone starts sharing their wishes with you."),
        IntroduceTabRowModel(id: 1,
                             imageName: "link",
                             text: "Invitation Link",
                             description: "Click on the invitation link sent to you by another user (the application should be running in the background). The Wishlist will appear here within a few seconds."),
        IntroduceTabRowModel(id: 2,
                             imageName: "bookmark",
                             text: "\"I'll buy\" Button",
                             description: "Mark shared wish as I'll buy (only if there are more than 2 users). Other users (except owner) will see that someone will buy a specific wish.")
    ]
    
    static let manageAccount = [
        IntroduceTabRowModel(id: 0,
                             imageName: "figure.walk.arrival",
                             text: "Log Out",
                             description: "All your data will be saved if you Log Out."),
        IntroduceTabRowModel(id: 1,
                             imageName: "trash",
                             text: "Delete Account",
                             description: "All your data will be irretrievably deleted from all devices."),
    ]
}
