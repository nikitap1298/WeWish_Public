//
//  Tips.swift
//  WeWish
//
//  Created by Nikita Pishchugin on 04.12.23.
//

import TipKit

struct ShareFolderTip: Tip {
    var title: Text {
        Text("Share Wishes")
    }

    var message: Text? {
        Text("Share your wishes with other users (subscription required).")
    }
}

struct EditSettingButtonTip: Tip {
    var title: Text {
        Text("Manage your account")
    }

    var message: Text? {
        Text("Tap to manage your account.")
    }
}

struct IWillBuyButtonTip: Tip {
    var title: Text {
        Text("Mark as I'll buy")
    }
    
    var message: Text? {
        Text("Other users (except owner) will see that someone will buy this wish.")
    }
}
